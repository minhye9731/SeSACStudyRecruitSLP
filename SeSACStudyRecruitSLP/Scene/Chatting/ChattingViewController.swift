//
//  ChattingViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/20/22.
//

import UIKit

final class ChattingViewController: BaseViewController {
    
    // MARK: - property
    let mainView = ChattingView()
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        setBarButtonItem()
        self.title = "고래밥" // 매칭완료된 상대방 닉네임
    }
    
    override func setConstraints() {
        super.setConstraints()
        
    }
    

}

// MARK: - 기타
extension ChattingViewController {
    
    func setBarButtonItem() {
        let navibarAppearance = UINavigationBarAppearance()
        let barbuttonItemAppearance = UIBarButtonItemAppearance()
        barbuttonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black, .font: CustomFonts.title3_M14()]
        navibarAppearance.buttonAppearance = barbuttonItemAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.ImageName.moreDot.rawValue), style: .plain, target: self, action: #selector(chattingMoreMenuTapped))
    }
    
    @objc func chattingMoreMenuTapped() {
        print("위에서 아래로 스르르 내려오는 애니메이션")
        let vc = MoreMenuViewController()
        transition(vc, transitionStyle: .presentFull) // test
    }
    
}
