//
//  WriteReviewView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/10/22.
//

import UIKit

final class WriteReviewView: BaseView {
    
    // MARK: - property
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = .white
        view.isScrollEnabled = false
        return view
    }()
    
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
        label.font = CustomFonts.title4_R14()
        label.textAlignment = .center
        return label
    }()
    
    let reviewTextView: UITextView = {
        let view = UITextView()
        view.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 12, right: 14)
        view.backgroundColor = ColorPalette.gray1
        view.layer.cornerRadius = 8
        view.text = Constants.Word.reviewPlaceholder.rawValue
        view.textColor = ColorPalette.gray7
        view.font = CustomFonts.body3_R14()
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        return view
    }()
    
    let registerbtn: UIButton = {
        let button = UIButton.generalButton(title: "리뷰 등록하기", textcolor: ColorPalette.gray3, bgcolor: ColorPalette.gray6, font: CustomFonts.body3_R14())
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        
        self.addSubview(popupView)
        [closebtn, collectionView, maintitle, subtitle, reviewTextView, registerbtn].forEach {
            popupView.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        popupView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(popupView.snp.width).multipliedBy(1.3)
            $0.centerY.equalTo(safeAreaLayoutGuide)
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
    
    func createLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.28))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(8)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
