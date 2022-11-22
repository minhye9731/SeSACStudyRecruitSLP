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
import Toast

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
        Network.share.requestLogin(type: LoginResponse.self, router: api) { [weak self] response in
            
            switch response {
            case .success(let loginData):
                self?.mainView.makeToast("로그인이 완료되었습니다.", duration: 0.5, position: .center)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    let vc = TabBarController()
                    UserDefaultsManager.nick = loginData.nick
                    UserDefaultsManager.background = loginData.background
                    print("배경이미지 번호 : \(UserDefaultsManager.background)")
                    self?.changeRootVC(vc: vc)
                }
                
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = LoginError(rawValue: code) else { return }
                print("failure // code = \(code), errorCode = \(errorCode)")
                
                switch errorCode {
                case .unknownUser:
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 0.5, position: .center)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let vc = NickNameViewController()
                        self?.changeRootVC(vc: vc)
                    }
                case .fbTokenError:
                    self?.refreshIDToken()
                default :
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                }
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
                Network.share.requestLogin(type: LoginResponse.self, router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let loginData):
                        let vc = TabBarController()
                        UserDefaultsManager.nick = loginData.nick
                        UserDefaultsManager.background = loginData.background
                        self?.changeRootVC(vc: vc)
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = LoginError(rawValue: code) else { return }
                        switch errorCode {
                        case .unknownUser:
                            self?.changeRootVC(vc: NickNameViewController())
                        default:
                            self?.showAlertMessage(title: "서버에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)")
                        }
                    }
                }
            }
        }
    } 
}
    
