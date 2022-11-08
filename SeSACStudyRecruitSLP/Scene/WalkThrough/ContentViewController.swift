//
//  ContentViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/9/22.
//

import UIKit

class ContentViewController: BaseViewController {
    
    // MARK: - property
    let mainView = SplashView()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        super.configure()
    }
    
}
