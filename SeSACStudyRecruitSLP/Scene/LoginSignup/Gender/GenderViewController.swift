//
//  GenderViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit
import Toast
import FirebaseAuth

final class GenderViewController: BaseViewController {
    
    // MARK: - property
    let mainView = GenderView()
    var womanSelected = false
    var manSelected = false
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        mainView.womanButton.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        mainView.manButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
    }
    
    @objc func femaleButtonTapped() {
        womanSelected.toggle()
        manSelected = false
        isValidGender()
        changeGenderBtnClr()
    }
    
    @objc func maleButtonTapped() {
        manSelected.toggle()
        womanSelected = false
        isValidGender()
        changeGenderBtnClr()
    }
    
    func isValidGender() {
        let value =  (manSelected && !womanSelected) || (!manSelected && womanSelected)
        let bgcolor: UIColor = value ? ColorPalette.green : ColorPalette.gray6
        let txcolor: UIColor = value ? .white : .black
        
        self.mainView.nextButton.configuration?.baseBackgroundColor = bgcolor
        self.mainView.nextButton.configuration?.attributedTitle?.foregroundColor = txcolor
    }
    
    func changeGenderBtnClr() {
        mainView.womanButton.configuration?.baseBackgroundColor = womanSelected ? ColorPalette.whitegreen : .white
        mainView.manButton.configuration?.baseBackgroundColor = manSelected ? ColorPalette.whitegreen : .white
        mainView.womanButton.configuration?.background.strokeColor = womanSelected ? ColorPalette.whitegreen : ColorPalette.gray4
        mainView.manButton.configuration?.background.strokeColor = manSelected ? ColorPalette.whitegreen : ColorPalette.gray4
    }
    
    @objc func nextButtonTapped() {
        if !manSelected && !womanSelected {
            self.mainView.makeToast("성별을 선택해 주세요.", duration: 1.0, position: .center)
        } else {
            let value = (manSelected && !womanSelected) ? "1" : "0"
            UserDefaultsManager.genderSU = value
            print("🦄성별 유저디폴츠 저장완료 |  UserDefaultsManager.genderSU = \( UserDefaultsManager.genderSU)")
            trySignup()
        }
    }
    
    func trySignup() {
        let api = APIRouter.signup(
            phoneNumber: UserDefaultsManager.phoneNumSU,
            FCMtoken: UserDefaultsManager.fcmTokenSU,
            nick: UserDefaultsManager.nickNameSU,
            birth: UserDefaultsManager.realAgeSU,
            email: UserDefaultsManager.emailSU,
            gender: UserDefaultsManager.genderSU
        )
        print("회원가입 api = \(api)")
        
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let statusCode = statusCode else { return }
            guard let status = SignupError(rawValue: statusCode) else { return }
            
            switch status {
            case .success:
                UserDefaultsManager.nick = UserDefaultsManager.nickNameSU // 삭제예정
                UserDefaultsManager.background = UserDefaultsManager.background // 삭제예정
                
                self?.mainView.makeToast("회원가입이 완료되었습니다.", duration: 0.5, position: .center) { didTap in
                    let vc = TabBarController()
                    self?.changeRootVC(vc: vc)
                }
                return
                
            case .existUser:
                self?.mainView.makeToast(status.signupErrorDescription, duration: 0.5, position: .center) { didTap in
                    let vc = PhoneNumberViewController()
                    self?.changeRootNavVC(vc: vc)
                }
                return

            case .invalidNickname:
                self?.mainView.makeToast(status.signupErrorDescription, duration: 0.5, position: .center) { didTap in
                    self?.navigationController?.popViewControllers(3)
                }
                return

            case .fbTokenError:
                self?.refreshIDToken()
                return
                
            default :
                self?.mainView.makeToast(status.signupErrorDescription, duration: 1.0, position: .center)
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
                
                let api = APIRouter.signup(
                    phoneNumber: UserDefaultsManager.phoneNumSU,
                    FCMtoken: UserDefaultsManager.fcmTokenSU,
                    nick: UserDefaultsManager.nickNameSU,
                    birth: UserDefaultsManager.realAgeSU,
                    email: UserDefaultsManager.emailSU,
                    gender: UserDefaultsManager.genderSU
                )
                
                Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let statusCode = statusCode else { return }
                    guard let status = SignupError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        UserDefaultsManager.nick = UserDefaultsManager.nickNameSU // 삭제예정
                        UserDefaultsManager.background = UserDefaultsManager.background // 삭제예정
                        
                        self?.mainView.makeToast("회원가입이 완료되었습니다.", duration: 0.5, position: .center) { didTap in
                            let vc = TabBarController()
                            self?.changeRootVC(vc: vc)
                        }
                        return
                        
                    case .existUser:
                        self?.mainView.makeToast(status.signupErrorDescription, duration: 0.5, position: .center) { didTap in
                            let vc = PhoneNumberViewController()
                            self?.changeRootNavVC(vc: vc)
                        }
                        return

                    case .invalidNickname:
                        self?.mainView.makeToast(status.signupErrorDescription, duration: 0.5, position: .center) { didTap in
                            self?.navigationController?.popViewControllers(3)
                        }
                        return

                    default :
                        self?.mainView.makeToast(status.signupErrorDescription, duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
    
    
    
}
