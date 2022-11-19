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
