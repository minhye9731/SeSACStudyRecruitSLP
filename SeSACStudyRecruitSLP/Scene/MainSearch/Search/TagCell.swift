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
        label.textColor = .black
        return label
    }()
    
    override func configure() {
        super.configure()
        contentView.addSubview(tagLabel)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
    }
    
    override func setConstraints() {
        super.setConstraints()
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
