//
//  LoginViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/9/22.
//

import Foundation

final class LoginViewController: BaseViewController {
    
    // MARK: - property
    let mainView = LoginView()
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    
    // MARK: - functions
    override func configure() {
        
        super.configure()
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        
    }
    
    
    
}
