//
//  TagCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/22/22.
//

import UIKit

class TagCell: BaseCollectionViewCell {
    
    let tagLabel: UILabel = {
       let label = UILabel()
        label.font = CustomFonts.title4_R14()
        return label
    }()
    
    override func configure() {
        super.configure()
        contentView.addSubview(tagLabel)
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    func setAroundData(data: [String], indexPath: IndexPath) {
        
        let value = data[indexPath.row]
        tagLabel.text = value
        tagLabel.textColor = ColorPalette.error // 분기처리
        
        contentView.layer.borderColor = ColorPalette.error.cgColor // 분기처리
    }
    
}
