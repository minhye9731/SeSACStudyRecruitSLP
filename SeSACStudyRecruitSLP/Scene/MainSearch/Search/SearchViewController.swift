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
        
        self.view.backgroundColor = .brown
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
    }
    
    
    
}
