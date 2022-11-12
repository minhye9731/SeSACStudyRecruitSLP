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
                
                print("인증을 시도해볼 인증코드는 : \(veriNum)")
                
                if veriNum.count == 6 {
                    checkVeriNumMatch(num: veriNum) // 인증하기 함수 실행
                } else {
                    self.mainView.makeToast("인증번호 전체를 입력해주세요.", duration: 1.0, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
        
        func checkVeriNumMatch(num: String) {
            
            guard let verficationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: "AKf9Wb3Kl89MUXMgWQDrlC7I8NBB5i_T9wUIQVfVhFT4TrwFgHydbMp3j4KwXZgsnpmAlOzkVECxMO0efLr1MWEIjw2QdKm3Y04bAVLRn8jAx_vOmgICkUkx-eVoNqzPmGOgEtuHXHcMJTUqMqvqeW1Cs8NtEA4EgLPTSmC9eTADO4IObnx0x4rRGzV3JDSdHIchX8xCqSvgVgJePYkHBrk95dpzJo8MMOrbHh6dhqufM01T0XySO-o", //verficationID,
                verificationCode: "676430" //num
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("error 발생 : \(error.localizedDescription)")
                    
                    let code = (error as NSError).code
                    print("error code 확인 : \(code)")
                    
                    // 케이스별 예외처리 필요할 듯
                    self.mainView.makeToast("로그인에 에러가 발생했습니다. 다시 시도해주세요 :)", duration: 1.0, position: .center)
                    self.mainView.verifyNumberTextField.text = ""
                    return
                }
                print("로그인 성공! 이제 서버랑 통신하자~~~~")
                print("authResult = \(authResult)")
                
                // idtoken 저장
                UserDefaults.standard.set(authResult, forKey: "idtoken")
                
                // 서버로부터 사용자 정보를 확인 : 신규&기존 사용자 여부 판단
                
            }
            
            
            
            
        }
        
        
        
        
    }
    
//    let vc = NickNameViewController()
//    self.transition(vc, transitionStyle: .push)
    
}
