//
//  ShopSesacViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/5/22.
//

import UIKit

final class ShopSesacViewController: BaseViewController {
    
    enum Section {
        case main
    }
    
    // MARK: - property
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, SesacController.SesacItem>!
    
    // MARK: - Lifecycle
    
    
    // MARK: - functions
    override func configure() {
        super.configure()
        configureHierarchy()
        configureDataSource()
    }
}

extension ShopSesacViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureDataSource() {
        
        let faceController = SesacController()
        
        let cellRegistration = UICollectionView.CellRegistration<ShopSesacCollectionViewCell, SesacController.SesacItem> { (cell, indexPath, faceItem) in

            cell.productImg.image = UIImage(named: faceItem.image)
            cell.productNameLabel.text = faceItem.name
            cell.descriptionLabel.text = faceItem.description
            cell.priceButton.setTitle(faceItem.price, for: .normal)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, SesacController.SesacItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: SesacController.SesacItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        let fcItems = faceController.faces
        var snapshot = NSDiffableDataSourceSnapshot<Section, SesacController.SesacItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(fcItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(width * 0.745))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(12)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = spacing * 2
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
