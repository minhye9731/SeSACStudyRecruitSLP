//
//  MyInfoView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class MyInfoView: BaseView {
    
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
    
    override func configureUI() {
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }

}

//final class MyInfoView: BaseView {
//
//    lazy var collectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
//        collectionView.isScrollEnabled = false
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.showsVerticalScrollIndicator = false
//
//        collectionView.register(MycellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MycellHeaderView.reuseIdentifier)
//        // configure
//        return collectionView
//    }()
//
//    override func configureUI() {
//        self.addSubview(collectionView)
//    }
//
//    override func setConstraints() {
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalTo(self.safeAreaLayoutGuide)
//        }
//    }
//
//}
