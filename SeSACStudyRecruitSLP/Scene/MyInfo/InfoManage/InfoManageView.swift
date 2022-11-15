//
//  InfoManageView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/15/22.
//

import UIKit

final class InfoManageView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        view.register(CustomTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomTableViewHeaderView.reuseIdentifier)
        
        view.register(profileCell.self, forCellReuseIdentifier: profileCell.reuseIdentifier)
        
        view.register(genderCell.self, forCellReuseIdentifier: genderCell.reuseIdentifier)
        view.register(oftenStudyCell.self, forCellReuseIdentifier: oftenStudyCell.reuseIdentifier)
        view.register(pnumPermitCell.self, forCellReuseIdentifier: pnumPermitCell.reuseIdentifier)
        view.register(ageRangeCell.self, forCellReuseIdentifier: ageRangeCell.reuseIdentifier)
        view.register(withdrawCell.self, forCellReuseIdentifier: MyProfileInfoCell.reuseIdentifier)
        
        return view
    }()
    
    override func configureUI() {
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }

}

