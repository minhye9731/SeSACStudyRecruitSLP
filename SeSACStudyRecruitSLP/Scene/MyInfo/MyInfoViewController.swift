//
//  MyInfoViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class MyInfoViewController: BaseViewController {
    
    // MARK: - property


    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
    }
    
    // MARK: - functions
    
    override func configure() {
        super.configure()
        setNav()
        view.backgroundColor = .lightGray
    }

}

extension MyInfoViewController {
    
    func setNav() {
        self.navigationItem.title = "내정보"
        self.navigationController?.navigationBar.tintColor = .black
        let navibarAppearance = UINavigationBarAppearance()
        navibarAppearance.backgroundColor = .white
        navibarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: CustomFonts.title3_M14()]
        
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
    }
}
