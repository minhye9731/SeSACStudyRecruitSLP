//
//  WriteReviewViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/28/22.
//

import UIKit

final class WriteReviewViewController : BaseViewController {
    
    enum Section {
        case main
    }
    
    // MARK: - property
    let mainView = WriteReviewView()
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    let reviewSet = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    
    // MARK: - Lifecycle
    override func loadView()  {
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        view.layer.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6).cgColor

        mainView.closebtn.addTarget(self, action: #selector(closebtnTapped), for: .touchUpInside)
        configureDataSource()
        mainView.collectionView.delegate = self
    }
    
}

// MARK: - collectionView
extension WriteReviewViewController {

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TagCell, String> { (cell, indexPath, identifier) in

            cell.tagLabel.text = identifier
            cell.layer.borderColor = ColorPalette.gray4.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.isUserInteractionEnabled = true
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: mainView.collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(reviewSet)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

// MARK: - 리뷰 클릭시
extension WriteReviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let review = self.dataSource.itemIdentifier(for: indexPath) else { return }
        print("👍🏻선택한 리뷰 = \(reviewSet[indexPath.row])")
    }
}

// MARK: - 기타
extension WriteReviewViewController {
    
    @objc func closebtnTapped() {
        self.dismiss(animated: true)
    }
    
}
