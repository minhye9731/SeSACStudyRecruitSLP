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
        
        //        let realtoken = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ3YjE5MTI0MGZjZmYzMDdkYzQ3NTg1OWEyYmUzNzgzZGMxYWY4OWYiLCJ0eXAiOiJKV1QifQ"
        //        UserDefaults.standard.set(realtoken, forKey: "idtoken")
        //        self.login()
        
        
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
                    self.checkVeriNumMatch(num: veriNum) // 인증하기 함수 실행
                } else {
                    self.mainView.makeToast("인증번호 전체를 입력해주세요.", duration: 1.0, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func checkVeriNumMatch(num: String) {
        
        guard let verficationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verficationID,
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
            authResult?.user.getIDTokenResult { idToken, error in
                print("파베 인증코드 인증 성공! 이제 서버랑 통신하자~~~~")
                print("idToken = \(idToken?.token)")
                let realtoken = idToken?.token
                //                let realtoken = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ3YjE5MTI0MGZjZmYzMDdkYzQ3NTg1OWEyYmUzNzgzZGMxYWY4OWYiLCJ0eXAiOiJKV1QifQ"
                UserDefaults.standard.set(realtoken, forKey: "idtoken")
                self.login()
            }
        }
    }
    
    func login() {
        
        let api = APIRouter.login
        Network.share.requestLogin(type: LoginResponse.self, router: api) { [weak self] response in
            
            switch response {
            case .success(let loginData):
                print("===로그인 성공! (홈 화면으로 전환)====")
                self?.mainView.makeToast("로그인이 완료되었습니다.", duration: 0.5, position: .center) { _ in
                    let vc = MainViewController()
//                    vc.userData = loginData
                    self?.changeRootVC(vc: vc)
                }
                
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = LoginError(rawValue: code) else { return }
                print("failure // code = \(code), errorCode = \(errorCode)")
                
                switch errorCode {
                case .unknownUser :
                    print("회원가입 화면으로 이동!")
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center) { _ in
                        let vc = NickNameViewController()
                        self?.changeRootVC(vc: vc)
                    }
                default :
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                }
            }
        }
    }
}
    
    
    
    
//    func login() {
//
//
//        viewModel.verify
//            .withUnretained(self)
//            .subscribe { (vc, value) in
//                print("로그인 성공! 홈화면으로 가자")
//                print(value)
//                let vc = MainViewController()
//                self.transition(vc, transitionStyle: .push)
//
//            } onError: { error in
//                print(error.localizedDescription)
//
//                self.mainView.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
//

//                switch LoginError {
//                case .fbTokenError:
//                    self.mainView.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
//                case .unknownUser:
//                    self.mainView.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
//                case .serverError:
//                    self.mainView.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
//                case .clientError:
//                    self.mainView.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
//                }
                
//            }
//    }
    

