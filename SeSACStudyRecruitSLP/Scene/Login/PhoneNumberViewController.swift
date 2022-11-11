//
//  PhoneNumberViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/9/22.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa
import Toast

final class PhoneNumberViewController: BaseViewController {
    
    // MARK: - property
    let mainView = PhoneNumberView()
    let viewModel = PhoneNumberViewModel()
    let disposeBag = DisposeBag()
//    var phoneNumber = "+82 010-7597-6263" // 가상의 번호
    
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        bind()
        Auth.auth().languageCode = "KO"
    }
    
    func bind() {
        let input = PhoneNumberViewModel.Input(
            phoneNumberText: mainView.phoneNumberTextField.rx.text,
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
                let phoneNumForm = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
                let phoneNumCheck = NSPredicate(format: "SELF MATCHES %@", phoneNumForm)
                guard let phoneNum = self.mainView.phoneNumberTextField.text else { return }
                
                if phoneNumCheck.evaluate(with: phoneNum) {
                    
                    
                    
                    print("Firebase 전화 번호 인증 시작")
                    self.provePhoneNumber(num: phoneNum)
                } else {
                    self.mainView.makeToast("잘못된 전화번호 형식입니다.", duration: 1.0, position: .center)
                }
            }
            .disposed(by: disposeBag)

    }

    func provePhoneNumber(num: String) {
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(num, uiDelegate: nil) { verficationID, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    
                    let code = (error as NSError).code
                    print(code) //17048
                    
                    return
                }
                
                UserDefaults.standard.set(verficationID, forKey: "authVerificationID")
                UserDefaults.standard.set(num, forKey: "phoneNum")
                print("phoneNum \(num), verficationID = \(verficationID) 저장 성공")
                
                let vc = VerifyNumberViewController()
                self.transition(vc, transitionStyle: .push)
            }
        
    }
    
    
    
    
    
    
}
