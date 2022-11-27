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
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var collectionView: UICollectionView! = nil
    let reviewSet = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    let closebtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.ImageName.bigClose.rawValue), for: .normal)
        button.tintColor = ColorPalette.gray6
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let maintitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "리뷰 등록"
        label.font = CustomFonts.title3_M14()
        label.textAlignment = .center
        return label
    }()
    let subtitle: UILabel = {
        let label = UILabel()
        label.textColor = ColorPalette.green
        label.text = "ooo님과의 스터디는 어떠셨나요?" //test
        label.font = CustomFonts.title4_R14()
        label.textAlignment = .center
        return label
    }()
    
    let reviewTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = ColorPalette.gray1
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    let registerbtn: UIButton = {
        let button = UIButton.generalButton(title: "리뷰 등록하기", textcolor: ColorPalette.gray3, bgcolor: ColorPalette.gray6, font: CustomFonts.body3_R14())
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        view.layer.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6).cgColor
       
        view.addSubview(popupView)
        [closebtn, maintitle, subtitle, reviewTextView, registerbtn].forEach {
            popupView.addSubview($0)
        }
        
        closebtn.addTarget(self, action: #selector(closebtnTapped), for: .touchUpInside)
        
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self // modern 방식이고, diffable로 데이터를 준다해도 didselect 인식하려면 delegate 등록해야함
    }
    
    override func setConstraints() {
        super.setConstraints()

        popupView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(popupView.snp.width).multipliedBy(1.3)
            $0.centerY.equalTo(self.view.center)
        }
        
        closebtn.snp.makeConstraints {
            $0.top.equalTo(popupView.snp.top).offset(16)
            $0.trailing.equalTo(popupView.snp.trailing).offset(-16)
            $0.width.height.equalTo(popupView.snp.width).multipliedBy(0.07)
        }
        
        maintitle.snp.makeConstraints {
            $0.top.equalTo(popupView.snp.top).offset(17)
            $0.centerX.equalTo(popupView.snp.centerX)
        }
        subtitle.snp.makeConstraints {
            $0.top.equalTo(maintitle.snp.bottom).offset(17)
            $0.centerX.equalTo(popupView.snp.centerX)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(subtitle.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(popupView).inset(16)
            $0.bottom.equalTo(reviewTextView.snp.top).offset(-24)
        }
        
        reviewTextView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(popupView).inset(16)
            $0.bottom.equalTo(registerbtn.snp.top).offset(-24)
            $0.height.equalTo(reviewTextView.snp.width).multipliedBy(0.398)
        }
        
        registerbtn.snp.makeConstraints {
            $0.horizontalEdges.equalTo(popupView).inset(16)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-16)
            $0.height.equalTo(registerbtn.snp.width).multipliedBy(0.154)
        }
    }
    
    
}

// MARK: - collectionView
extension WriteReviewViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        popupView.addSubview(collectionView)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TagCell, String> { (cell, indexPath, identifier) in

            cell.tagLabel.text = identifier
            cell.layer.borderColor = ColorPalette.gray4.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 8
            cell.isUserInteractionEnabled = true
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
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
