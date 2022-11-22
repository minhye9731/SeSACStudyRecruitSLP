//
//  SearchView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit

final class SearchView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        layout.headerReferenceSize = .init(width: UIScreen.main.bounds.size.width - 32, height: 18)
        
        collectionView.isScrollEnabled = false
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseIdentifier)
        collectionView.register(SectionTitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionTitleSupplementaryView.reuseIdentifier)
        
        return collectionView
    }()
    
    let searchBtn: UIButton = {
        let button = UIButton.generalButton(title: "새싹 찾기", textcolor: .white, bgcolor: ColorPalette.green, font: CustomFonts.body3_R14())
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func configureUI() {
        super.configureUI()
        [collectionView, searchBtn].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(32)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(searchBtn.snp.top).offset(-16) // 버튼을 여기에 적용할지 아니면, mainview자체의 위에다가 붙일지 고민중. 실험 필요
        }
        
        searchBtn.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(searchBtn.snp.width).multipliedBy(0.14)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        
    }
    
    
    
}
