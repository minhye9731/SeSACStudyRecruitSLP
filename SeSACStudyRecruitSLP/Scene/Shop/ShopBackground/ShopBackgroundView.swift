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
            
            cell.productImg.image = UIImage(named: bgItem.image)
            cell.productNameLabel.text = bgItem.name
            cell.descriptionLabel.text = bgItem.description
            cell.priceButton.setTitle(bgItem.price, for: .normal)
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
}
