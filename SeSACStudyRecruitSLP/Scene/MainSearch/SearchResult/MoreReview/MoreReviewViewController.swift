//
//  MoreReviewViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/27/22.
//

import UIKit

final class MoreReviewViewController: BaseViewController {
    
    // MARK: - property
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    var reviewList: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "새싹 리뷰"
        configureHierarchy()
        configureDataSource()
    }
    
    // MARK: - functions
    func createLayout() -> UICollectionViewLayout {
        let estimatedHeight = CGFloat(100)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                       subitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view)
        }
    }
    
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration
        <ReviewCollectionViewCell, String> { (cell, indexPath, reviewItem) in

            cell.reviewLabel.text = reviewItem
        }
        
        dataSource = UICollectionViewDiffableDataSource
        <Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: String) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        // load our data
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(reviewList)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
