//
//  EmailViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class EmailViewController: BaseViewController {
    
    // MARK: - property
    let mainView = EmailView()
    let viewModel = EmailViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        mainView.emailTextField.becomeFirstResponder()
        bind()
    }
    
    func bind() {
        let input = EmailViewModel.Input(
            emailText: mainView.emailTextField.rx.text,
            tap: mainView.nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.validStatus
            .withUnretained(self)
            .bind { (vc, value) in
                let bgcolor: UIColor = value ? ColorPalette.green : ColorPalette.gray6
                let txcolor: UIColor = value ? .white : .black
                vc.mainView.nextButton.configuration?.baseBackgroundColor = bgcolor
                vc.mainView.nextButton.configuration?.attributedTitle?.foregroundColor = txcolor
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .bind { _ in
                let emailRule = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailRule)
                guard let email = self.mainView.emailTextField.text else { return }
                
                if emailCheck.evaluate(with: email) {
                    UserDefaultsManager.emailSU = email
                    print("🦄이메일 유저디폴츠 저장완료 | UserDefaultsManager.emailSU = \(UserDefaultsManager.emailSU)")
                    let vc = GenderViewController()
                    self.transition(vc, transitionStyle: .push)
                } else {
                    self.mainView.makeToast("이메일 형식이 올바르지 않습니다.", duration: 1.0, position: .center)
                }
            }
            .disposed(by: disposeBag)
    }
    

    
}
