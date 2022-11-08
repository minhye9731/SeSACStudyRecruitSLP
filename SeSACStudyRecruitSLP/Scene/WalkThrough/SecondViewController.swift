//
//  SecondViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/7/22.
//

import UIKit

class SecondViewController: BaseViewController {
    
    // MARK: - property
    let mainView = SplashView()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        super.configure()
        mainView.setData(text: "스터디를 원하는 친구를\n찾을 수 있어요", image: "onboarding_img2")
        giveColorString(label: mainView.notiLabel, colorStr: "스터디를 원하는 친구", color: ColorPalette.green)
    }
}
