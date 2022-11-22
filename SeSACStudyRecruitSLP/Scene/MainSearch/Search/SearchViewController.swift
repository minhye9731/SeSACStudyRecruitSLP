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
    
    var aroundTagList = ["아무거나", "SeSAC", "코딩", "Swift", "SwiftUI", "CoreData", "Python", "Java"]
    var mywishTagList = ["코딩", "부동산투자", "주식", "너?", "불어", "HIG", "알고리즘"]

    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        self.tabBarController?.tabBar.isHidden = true
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.searchBtn.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        setNav()

    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? aroundTagList.count : mywishTagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionTitleSupplementaryView.reuseIdentifier,
                for: indexPath
            ) as! SectionTitleSupplementaryView
            
            let header = indexPath.section == 0 ? "지금 주변에는" : "내가 하고 싶은"
            supplementaryView.prepare(title: header)
            
            return supplementaryView
        default: return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let aroundCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        guard let myWishCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTagCell.reuseIdentifier, for: indexPath) as? MyTagCell else { return UICollectionViewCell() }
        
        
        switch indexPath.section {
        case 0:
            aroundCell.setAroundData(data: aroundTagList, indexPath: indexPath)
            return aroundCell
        case 1:
            myWishCell.setMyWishData(data: mywishTagList, indexPath: indexPath)
            return myWishCell
        default: return myWishCell
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    // 셀 크기설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        guard let aroundCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as? TagCell else { return .zero }
//        guard let myWishCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTagCell.reuseIdentifier, for: indexPath) as? MyTagCell else { return .zero }
//
//        aroundCell.sizeToFit()
//        myWishCell.sizeToFit()
//
//        let aroundCellWidth = aroundCell.tagLabel.frame.width
//        let myWishCellWidth = myWishCell.tagLabel.frame.width + 20
       
   
        let label: UILabel = {
            let label = UILabel()
            label.font = CustomFonts.title4_R14()
            label.text = indexPath.section == 0 ? aroundTagList[indexPath.item] : mywishTagList[indexPath.item]
            label.sizeToFit()
            return label
        }()

        let size = label.frame.size
        
//        return CGSize(width: size.width + 16, height: size.height + 5)
        return indexPath.section == 0 ? CGSize(width: size.width + 32, height: size.height + 5) : CGSize(width: size.width + 52, height: size.height + 5)
//        return indexPath.section == 0 ? CGSize(width: aroundCellWidth + 16, height: 32) : CGSize(width: myWishCellWidth + 16, height: 32)
    }
    
}

extension SearchViewController {
    
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


