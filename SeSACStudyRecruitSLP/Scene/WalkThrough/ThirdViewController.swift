//
//  ThirdViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/7/22.
//

import UIKit

class ThirdViewController: BaseViewController {
    
    // MARK: - property
    let mainView = SplashView()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        super.configure()
        mainView.setData(text: "SeSAC Study", image: "onboarding_img3")
        mainView.notiLabel.font = UIFont(name: "NotoSansCJKkr-Medium", size: 24)
    }
    
}
