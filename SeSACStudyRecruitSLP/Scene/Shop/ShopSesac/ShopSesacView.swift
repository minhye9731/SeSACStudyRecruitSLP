//
//  ShopSesacView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/13/22.
//

import UIKit

final class ShopSesacView: BaseView {

    enum Section {
        case main
    }
    
    // MARK: - property
    var sesacCollection: [Int] = []
    var ssPriceButtonActionHandler: (() -> ())?
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
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
    
    func configureDataSource() {
        let faceController = SesacController()
        
        let cellRegistration = UICollectionView.CellRegistration<ShopSesacCollectionViewCell, SesacController.SesacItem> { (cell, indexPath, faceItem) in
            
            cell.setData(data: faceItem, collection: self.sesacCollection, indexPath: indexPath)
            
            cell.priceButton.addTarget(self, action: #selector(self.priceBtnTappedClicked), for: .touchUpInside)
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
    
    @objc func priceBtnTappedClicked() {
        ssPriceButtonActionHandler!()
    }
}
