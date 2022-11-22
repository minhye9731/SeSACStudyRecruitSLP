//
//  SearchView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit

final class SearchView: BaseView {
    
    // MARK: - property
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 24, right: 0)
        layout.headerReferenceSize = .init(width: UIScreen.main.bounds.size.width - 32, height: 18)
        
        collectionView.isScrollEnabled = false
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseIdentifier)
        collectionView.register(MyTagCell.self, forCellWithReuseIdentifier: MyTagCell.reuseIdentifier)
        collectionView.register(SectionTitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionTitleSupplementaryView.reuseIdentifier)
        
        collectionView.keyboardDismissMode = .onDrag
        
        return collectionView
    }()
    
    lazy var searchBtn: UIButton = {
        let button = UIButton.generalButton(title: "새싹 찾기", textcolor: .white, bgcolor: ColorPalette.green, font: CustomFonts.body3_R14())
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var accSearchBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 0.128))
        button.setTitleColor(.white, for: .normal)
        button.setTitle("새싹 찾기", for: .normal)
        button.titleLabel?.font = CustomFonts.body3_R14()
        button.backgroundColor = ColorPalette.green
        return button
    }()
    
    // MARK: - functions
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
            $0.bottom.equalTo(searchBtn.snp.top).offset(-16)
        }
        
        searchBtn.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(searchBtn.snp.width).multipliedBy(0.14)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        
    }
    
    
    
}
