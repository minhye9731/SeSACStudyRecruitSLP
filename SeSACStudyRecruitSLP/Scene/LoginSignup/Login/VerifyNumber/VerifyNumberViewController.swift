//
//  VerifyNumberViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

final class VerifyNumberViewController: BaseViewController {
    
    // MARK: - property
    let mainView = VerifyNumberView()
    let viewModel = VerifyNumberViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainView.makeToast("인증번호를 발송했습니다.", duration: 1.0, position: .center) // 한 번만 발송되도록 제한 필요
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        bind()
    }
    
    func bind() {
        let input = VerifyNumberViewModel.Input(
            veriNumText: mainView.verifyNumberTextField.rx.text,
            tap: mainView.startButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.validStatus
            .withUnretained(self)
            .bind { (vc, value) in
                let bgcolor: UIColor = value ? ColorPalette.green : ColorPalette.gray6
                let txcolor: UIColor = value ? .white : .black
                vc.mainView.startButton.configuration?.baseBackgroundColor = bgcolor
                vc.mainView.startButton.configuration?.attributedTitle?.foregroundColor = txcolor
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .bind { _ in
                guard let veriNum = self.mainView.verifyNumberTextField.text else { return }
                if veriNum.count == 6 {
                    self.checkVeriNumMatch(num: veriNum)
                } else {
                    self.mainView.makeToast("인증번호 전체를 입력해주세요.", duration: 1.0, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func checkVeriNumMatch(num: String) {
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: UserDefaultsManager.authVerificationID,
            verificationCode: num
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error as NSError? {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                print("error 발생 : \(errorCode.rawValue), errorcode: \(errorCode)")
                
                switch errorCode {
                case .tooManyRequests:
                    return self.mainView.makeToast("과도한 인증 요청 시도가 있었습니다. 잠시 후 다시 시도해 주세요.", duration: 1.0, position: .center)
                default:
                    return self.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해 주세요.", duration: 1.0, position: .center)
                }
            }
            authResult?.user.getIDToken { idToken, error in
                print("~~~~파베 인증코드 인증 성공! 이제 서버랑 통신하자~~~~")
                guard let idToken = idToken else { return }
                UserDefaultsManager.idtoken = idToken
                print("🦄idToken 유저디폴츠 저장완료 | UserDefaultsManager.idtoken = \( UserDefaultsManager.idtoken)")
                self.login()
            }
        }
    }
    
    func login() {
        let api = APIRouter.login
        Network.share.requestUserLogin(router: api) { [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status = LoginError(rawValue: statusCode) else { return }
            
            switch status {
            case .success:
                UserDefaultsManager.nick = value.nick // 삭제예정
                UserDefaultsManager.background = value.background // 삭제예정
                
                self?.mainView.makeToast("로그인이 완료되었습니다.", duration: 0.5, position: .center, completion: { didTap in
                    
                    if value.fcMtoken == UserDefaultsManager.fcmTokenSU {
                        self?.changeRootVC(vc: TabBarController())
                        return
                    } else {
                        self?.requestFCMUpdate(fcm: value.fcMtoken)
                        UserDefaultsManager.fcmTokenSU = value.fcMtoken
                        return
                    }
                })
                
            case .unknownUser:
                self?.mainView.makeToast(status.loginErrorDescription, duration: 0.5, position: .center, completion: { didTap in
                    let vc = NickNameViewController()
                    self?.transition(vc, transitionStyle: .push)
                })
                return
                
            case .fbTokenError:
                self?.refreshIDToken()
                return
                
            default :
                self?.mainView.makeToast(status.loginErrorDescription, duration: 1.0, position: .center)
                return
            }
        }
    }

    func refreshIDToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default:
                    self.mainView.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
                }
                return
            } else if let idToken = idToken {
                UserDefaultsManager.idtoken = idToken
                print("🦄갱신된 idToken 저장완료 |  UserDefaultsManager.idtoken = \(UserDefaultsManager.idtoken)")
                
                let api = APIRouter.login
                Network.share.requestUserLogin(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let value = value else { return }
                    guard let statusCode = statusCode else { return }
                    guard let status = LoginError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        UserDefaultsManager.nick = value.nick // 삭제예정
                        UserDefaultsManager.background = value.background // 삭제예정
                        
                        self?.mainView.makeToast("로그인이 완료되었습니다.", duration: 0.5, position: .center, completion: { didTap in
                            self?.changeRootVC(vc: TabBarController())
                        })
                        return
                        
                    case .unknownUser:
                        self?.mainView.makeToast(status.loginErrorDescription, duration: 0.5, position: .center, completion: { didTap in
                            let vc = NickNameViewController()
                            self?.transition(vc, transitionStyle: .push)
                        })
                        return
                        
                    default :
                        self?.mainView.makeToast(status.loginErrorDescription, duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
    
    func requestFCMUpdate(fcm: String) {
        let api = APIRouter.fcmUpdate(fcmToken: fcm)
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let statusCode = statusCode else { return }
            guard let status = GeneralError(rawValue: statusCode) else { return }
            
            switch status {
            case .success:
                self?.changeRootVC(vc: TabBarController())
                return
                
            case .fbTokenError:
                self?.refreshIDTokenFCMToken(fcmToken: fcm)
                return
                
            default:
                self?.view.makeToast(status.errorDescription, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenFCMToken(fcmToken: String) {
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default:
                    self.view.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
                }
                return
                
            } else if let idToken = idToken {
                UserDefaults.standard.set(idToken, forKey: "idtoken")
                
                let api = APIRouter.fcmUpdate(fcmToken: fcmToken)
                Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let statusCode = statusCode else { return }
                    guard let status = GeneralError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        self?.changeRootVC(vc: TabBarController())
                        return
                        
                    default:
                        self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }

    
}
    
