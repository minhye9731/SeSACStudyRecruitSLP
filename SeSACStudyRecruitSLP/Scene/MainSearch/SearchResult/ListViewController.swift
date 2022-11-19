//
//  ListViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit

final class ListViewController: BaseViewController {
    
    // MARK: - property
    let mainView = ListView()
    var aroundOrAccepted: SearchMode = .aroundSesac
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        
        mainView.emptyView.mainNotification.text = aroundOrAccepted == .aroundSesac ? "아쉽게도 주변에 새싹이 없어요ㅠ" : "아직 받은 요청이 없어요ㅠ"
        
        mainView.emptyView.refreshBtn.addTarget(self, action: #selector(refreshBtnTapped), for: .touchUpInside)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
    }
    
    @objc func refreshBtnTapped() {
        print("뒤로가기 버튼 눌림") // 눌리지가 않음
        self.navigationController?.popViewController(animated: true)
    }
    
}
