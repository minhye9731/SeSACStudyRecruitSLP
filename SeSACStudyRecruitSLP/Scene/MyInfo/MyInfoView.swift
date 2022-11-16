//
//  MyInfoView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class MyInfoView: BaseView {
    
    // MARK: - property
    let tableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.register(MyInfoCell.self, forCellReuseIdentifier: MyInfoCell.reuseIdentifier)
        view.register(MyProfileInfoCell.self, forCellReuseIdentifier: MyProfileInfoCell.reuseIdentifier)
        return view
    }()
    
    // MARK: - functions
    override func configureUI() {
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
