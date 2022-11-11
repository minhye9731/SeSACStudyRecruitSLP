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
        self.mainView.makeToast("인증번호를 보냈습니다.", duration: 1.0, position: .center) // 이후화면에서 돌아올때 표기여부 확인
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
                checkVeriNumMatch(num: veriNum)
                if veriNum.count == 6 {
                    // 인증하기 함수 실행
                } else {
                    
                }
                
            }
            .disposed(by: disposeBag)
        
        // 전화번호 인증하는 함수, 여기서 로그인을 시도한다.
        func checkVeriNumMatch(num: String) {
            
            // 로그인 통신
            // 서버로부터 사용자 정보를 확인
            // 기사용자 여부에 따른 화면 이동
            // (임시확인용 일방통행)
            let vc = NickNameViewController()
            self.transition(vc, transitionStyle: .push)
            // 에러처리
            
            
            
        }
        
        
        
        
    }
    
    
//    @objc func test() {
//        let vc = NickNameViewController()
//        transition(vc, transitionStyle: .push)
//    }
    
}
