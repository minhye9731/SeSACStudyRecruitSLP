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
       let tableview = UITableView()
        tableview.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
        tableview.register(CollapsibleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: CollapsibleTableViewHeader.reuseIdentifier)
//        tableview.rowHeight = 50
        return tableview
    }()
    
    let emptyView: EmptyView = {
       let view = EmptyView()
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        [emptyView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
//        tableView.snp.makeConstraints { make in
//            make.edges.equalTo(self.safeAreaLayoutGuide)
//        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
