//
//  NickNameViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class NickNameViewController: BaseViewController {
    
    // MARK: - property
    let mainView = NickNameView()
    let viewModel = NickNameViewModel()
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
        mainView.nicknameTextField.becomeFirstResponder()
    }
    
    func bind() {
        let input = NickNameViewModel.Input(
            nicknameText: mainView.nicknameTextField.rx.text,
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
                
                guard let nickname = self.mainView.nicknameTextField.text else { return }
                
                if nickname.count > 10 || nickname.count == 0 {
                    self.mainView.makeToast("닉네임은 1자 이상 10자 이내로 부탁드려요.", duration: 1.0, position: .center)
                } else {
                    UserDefaults.standard.set(nickname, forKey: "nickName")

                    let vc = BirthdayViewController()
                    self.transition(vc, transitionStyle: .push)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
}




