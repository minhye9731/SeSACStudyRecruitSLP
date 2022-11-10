//
//  NickNameViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit

final class NickNameViewController: BaseViewController {
    
    // MARK: - property
    let mainView = NickNameView()
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    
    override func configure() {
        super.configure()
        mainView.nextButton.addTarget(self, action: #selector(test), for: .touchUpInside)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
    }
    
    @objc func test() {
        let vc = NickNameViewController()
        transition(vc, transitionStyle: .push)
    }
    
    
    
}




