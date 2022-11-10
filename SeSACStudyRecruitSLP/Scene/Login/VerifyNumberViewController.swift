//
//  VerifyNumberViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit
import FirebaseAuth

final class VerifyNumberViewController: BaseViewController {
    
    // MARK: - property
    let mainView = VerifyNumberView()
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        mainView.startButton.addTarget(self, action: #selector(test), for: .touchUpInside)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
    }
    
    @objc func test() {
        let vc = NickNameViewController()
        transition(vc, transitionStyle: .push)
    }
    
}
