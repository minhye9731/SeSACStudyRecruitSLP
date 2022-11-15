//
//  InfoManageView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/15/22.
//

import UIKit

final class InfoManageView: BaseView {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.showsVerticalScrollIndicator = false
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 100
        view.separatorStyle = .none
        
        view.register(CustomTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomTableViewHeaderView.reuseIdentifier)
        
        view.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
        
        view.register(GenderCell.self, forCellReuseIdentifier: GenderCell.reuseIdentifier)
        view.register(OftenStudyCell.self, forCellReuseIdentifier: OftenStudyCell.reuseIdentifier)
        view.register(PnumPermitCell.self, forCellReuseIdentifier: PnumPermitCell.reuseIdentifier)
        view.register(AgeRangeCell.self, forCellReuseIdentifier: AgeRangeCell.reuseIdentifier)
        view.register(WithdrawCell.self, forCellReuseIdentifier: WithdrawCell.reuseIdentifier)
        
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

