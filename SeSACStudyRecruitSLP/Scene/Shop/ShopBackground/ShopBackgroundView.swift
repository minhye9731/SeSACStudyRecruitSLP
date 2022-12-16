//
//  ShopBackgroundView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/13/22.
//

import UIKit

final class ShopBackgroundView: BaseView {
    
    enum Section {
        case main
    }
    
    // MARK: - property
    var backgroundCollection: [Int] = []
    var bgPriceButtonActionHandler: (() -> ())?
    var row = 0
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = .white
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, SesacController.SesacItem>!
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        self.addSubview(collectionView)
        configureDataSource()
    }
    
    override func setConstraints() {
        super.setConstraints()
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(width * 0.441))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        let backgroundController = SesacController()
        
        let cellRegistration = UICollectionView.CellRegistration<ShopBackgroundCollectionViewCell, SesacController.SesacItem> { (cell, indexPath, bgItem) in

            cell.setData(data: bgItem, collection: self.backgroundCollection, indexPath: indexPath)
            
            cell.priceButton.addTarget(self, action: #selector(self.priceBtnTappedClicked), for: .touchUpInside)
            cell.priceButton.row = indexPath.row
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, SesacController.SesacItem>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: SesacController.SesacItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        let bgItems = backgroundController.backgrounds
        var snapshot = NSDiffableDataSourceSnapshot<Section, SesacController.SesacItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(bgItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc func priceBtnTappedClicked(sender: PriceButton) {
        row = sender.row!
        bgPriceButtonActionHandler!()
    }
}
