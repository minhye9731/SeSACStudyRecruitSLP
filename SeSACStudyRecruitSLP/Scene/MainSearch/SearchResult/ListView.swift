//
//  ListView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit

final class ListView: BaseView {
    
    // MARK: - property
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.showsVerticalScrollIndicator = false
        tableview.rowHeight = UITableView.automaticDimension
        tableview.separatorStyle = .none
        tableview.tableFooterView =
        UIView(frame: CGRect(origin: .zero,
                             size: CGSize(width:CGFloat.leastNormalMagnitude,
                                          height: CGFloat.leastNormalMagnitude)))
        tableview.backgroundColor = .white
        
        tableview.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
        tableview.register(CollapsibleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: CollapsibleTableViewHeader.reuseIdentifier)
        return tableview
    }()
    
    let emptyView: EmptyView = {
       let view = EmptyView()
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        [tableView, emptyView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
