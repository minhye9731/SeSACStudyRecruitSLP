//
//  SearchViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    // MARK: - property
    let mainView = SearchView()
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    override func configure() {
        super.configure()
        
        self.tabBarController?.tabBar.isHidden = true
        mainView.searchBtn.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        setNav()
    }
    
    override func setConstraints() {
        super.setConstraints()
        
    }
    
    func setNav() {
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 0))
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    @objc func searchBtnTapped() {
        let vc = SearchResultViewController()
        
        transition(vc, transitionStyle: .push)
    }
    
}
