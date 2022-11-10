//
//  PhoneNumberViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/9/22.
//

import UIKit
import FirebaseAuth

final class PhoneNumberViewController: BaseViewController {
    
    // MARK: - property
    let mainView = PhoneNumberView()
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
        
        Auth.auth().languageCode = "KO"
//
//        PhoneAuthProvider.provider()
//            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verficationID, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    let code = (error as NSError).code
//                    print(code) //17048
//                    return
//                }
//                // 에러 없으면 사용자에게 인증코드와 verificationID(인증ID) 전달
//
//                print(verficationID)
//                UserDefaults.standard.set(verficationID, forKey: "authVerificationID")
//
//            }
        
        mainView.startButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        
    }
    
    @objc func test() {
//        let credential = PhoneAuthProvider.provider().credential(
//            withVerificationID: verificationID,
//            verificationCode: verificationCode
//        )
        let vc = VerifyNumberViewController()
        transition(vc, transitionStyle: .push)
        
    }
    
    
    
    
    
    
    
}
