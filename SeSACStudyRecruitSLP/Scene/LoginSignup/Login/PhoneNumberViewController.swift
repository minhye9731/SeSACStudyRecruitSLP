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
            phoneNumberEditing: mainView.phoneNumberTextField.rx.controlEvent(.editingDidBegin),
            phoneNumberDone: mainView.phoneNumberTextField.rx.controlEvent(.editingDidEnd),
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
        
        output.changeForm
            .drive(
                mainView.phoneNumberTextField.rx.text
            )
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .bind { _ in
                guard let numberToCheck = self.mainView.phoneNumberTextField.text?.autoRemoveHyphen() else { return }
                
                self.mainView.startButton.configuration?.baseBackgroundColor == ColorPalette.green ? self.provePhoneNumber(num: numberToCheck) : self.mainView.makeToast("잘못된 전화번호 형식입니다.", duration: 1.0, position: .center)
            }
            .disposed(by: disposeBag)
    }
    
    func provePhoneNumber(num: String) {
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(num, uiDelegate: nil) { verficationID, error in
                
                if let error = error as NSError? {
                    guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                    
                    switch errorCode {
                    case .tooManyRequests:
                        self.mainView.makeToast("과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요.", duration: 1.0, position: .center)
                        return
                    default:
                        self.mainView.makeToast("에러가 발생했습니다. 다시 시도해주세요.", duration: 1.0, position: .center)
                        return
                    }
                }
                
                guard let verficationID = verficationID else { return }
                
                UserDefaultsManager.authVerificationID = verficationID
                UserDefaultsManager.phoneNumSU = num
                print("🦄verficationID 저장완료 |  UserDefaultsManager.authVerificationID = \(UserDefaultsManager.authVerificationID)")
                print("🦄폰번호 유저디폴츠 저장완료 |  UserDefaultsManager.phoneNumSU = \( UserDefaultsManager.phoneNumSU)")
                
                let vc = VerifyNumberViewController()
                self.transition(vc, transitionStyle: .push)
            }
    }
}
