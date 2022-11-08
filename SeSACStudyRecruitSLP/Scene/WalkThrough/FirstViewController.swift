//
//  FirstViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/7/22.
//

import UIKit

class FirstViewController: BaseViewController {
    
    // MARK: - property
    let mainView = SplashView()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        super.configure()
        mainView.setData(text: "위치 기반으로 빠르게\n주위 친구들 확인", image: "onboarding_img1")
        giveColorString(label: mainView.notiLabel, colorStr: "위치 기반", color: ColorPalette.green)
    }
    
}
