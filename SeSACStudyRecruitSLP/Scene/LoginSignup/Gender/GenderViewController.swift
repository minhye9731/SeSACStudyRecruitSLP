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
        
        Network.share.requestForResponseString(router: api) { [weak self] response in
            
            switch response {
            case .success(let success):
                print("===회원가입 성공! (홈 화면으로 전환)====")
                print("회원가입 요청 바디 : \(api)")
                
                self?.mainView.makeToast("회원가입이 완료되었습니다.", duration: 0.5, position: .center)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    let vc = TabBarController()
                    self?.changeRootVC(vc: vc)
                }
                
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = SignupError(rawValue: code) else { return }
                print("failure // code = \(code), errorCode = \(errorCode)")
                
                switch errorCode {
                case .existUser:
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let vc = PhoneNumberViewController()
                        self?.changeRootVC(vc: vc)
                    }
                case .invalidNickname:
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let vc = NickNameViewController() // 이거말고 뷰컨기준 3개 뒤로가기 하자
                        self?.changeRootVC(vc: vc) // 이거말고 뷰컨기준 3개 뒤로가기 하자
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
                
                let api = APIRouter.signup(
                    phoneNumber: UserDefaultsManager.phoneNumSU,
                    FCMtoken: UserDefaultsManager.fcmTokenSU,
                    nick: UserDefaultsManager.nickNameSU,
                    birth: UserDefaultsManager.realAgeSU,
                    email: UserDefaultsManager.emailSU,
                    gender: UserDefaultsManager.genderSU
                )
                
                Network.share.requestForResponseString(router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let success):
                        print("===회원가입 성공! (홈 화면으로 전환)====")
                        print("회원가입 요청 바디 : \(api)")
                        
                        self?.mainView.makeToast("회원가입이 완료되었습니다.", duration: 0.5, position: .center)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            let vc = TabBarController()
                            self?.changeRootVC(vc: vc)
                        }
                        return
                        
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = SignupError(rawValue: code) else { return }
                        switch errorCode {
                        case .existUser:
                            self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                let vc = PhoneNumberViewController()
                                self?.changeRootVC(vc: vc)
                            }
                            return
                        case .invalidNickname:
                            self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                let vc = NickNameViewController()
                                self?.changeRootVC(vc: vc)
                            }
                            return
                        default:
                            self?.showAlertMessage(title: "서버에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)")
                            return
                        }
                    }
                }
            }
        }
    }
}
