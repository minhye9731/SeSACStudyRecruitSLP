//
//  GenderViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit
import Toast

final class GenderViewController: BaseViewController {
    
    // MARK: - property
    let mainView = GenderView()
    var femaleSelected = false
    var maleSelected = false
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        mainView.FemaleButton.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        mainView.MaleButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
    }
    
    @objc func femaleButtonTapped() {
        femaleSelected.toggle()
        maleSelected = false
        isValidGender()
        changeGenderBtnClr()
    }
    
    @objc func maleButtonTapped() {
        maleSelected.toggle()
        femaleSelected = false
        isValidGender()
        changeGenderBtnClr()
    }
    
    func isValidGender() {
        let value =  (maleSelected && !femaleSelected) || (!maleSelected && femaleSelected)
        let bgcolor: UIColor = value ? ColorPalette.green : ColorPalette.gray6
        let txcolor: UIColor = value ? .white : .black

        self.mainView.nextButton.configuration?.baseBackgroundColor = bgcolor
        self.mainView.nextButton.configuration?.attributedTitle?.foregroundColor = txcolor
    }
    
    func changeGenderBtnClr() {
        mainView.FemaleButton.configuration?.baseBackgroundColor = femaleSelected ? ColorPalette.whitegreen : .white
        mainView.MaleButton.configuration?.baseBackgroundColor = maleSelected ? ColorPalette.whitegreen : .white
        mainView.FemaleButton.configuration?.background.strokeColor = femaleSelected ? ColorPalette.whitegreen : ColorPalette.gray4
        mainView.MaleButton.configuration?.background.strokeColor = maleSelected ? ColorPalette.whitegreen : ColorPalette.gray4
    }
    
    @objc func nextButtonTapped() {
        if !maleSelected && !femaleSelected {
            self.mainView.makeToast("성별을 선택해 주세요.", duration: 1.0, position: .center)
        } else {
            let value = (maleSelected && !femaleSelected) ? "1" : "0"
            print("성별선택 저장값 = \(value)")
            UserDefaults.standard.set(value, forKey: "gender")
            trySignup()
        }
    }
    
    func trySignup() {
        // 회원가입 정보 property wrapper 정리하자
        let api = APIRouter.signup(
            phoneNumber: UserDefaults.standard.string(forKey: "phoneNum")!,
            FCMtoken: UserDefaults.standard.string(forKey: "fcmToken")!,
            nick: UserDefaults.standard.string(forKey: "nickName")!,
            birth: UserDefaults.standard.string(forKey: "realAge")!,
            email: UserDefaults.standard.string(forKey: "email")!,
            gender: UserDefaults.standard.string(forKey: "gender")!
        )
        
        Network.share.requestSignup(router: api) { [weak self] response in
            
            switch response {
            case .success(let success):
                print("===회원가입 성공! (홈 화면으로 전환)====")
                self?.mainView.makeToast("회원가입이 완료되었습니다.", duration: 0.5, position: .center)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    let vc = MainViewController()
                    self?.changeRootVC(vc: vc)
                }
                
            case .failure(let error):
                
                let code = (error as NSError).code
                print("failure // code = \(code)")
                
                guard let errorCode = SignupError(rawValue: code) else { return }
                print("failure // errorCode = \(errorCode)")
                
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
                        let vc = NickNameViewController()
                        self?.changeRootVC(vc: vc)
                    }
                case .fbTokenError:
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center) { _ in
                        // 토큰 갱신 후 재요청
                    }
                    
                default :
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                }
            }
        }
    }
    
    
    
    
}
