//
//  TagCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/22/22.
//

import UIKit

class TagCell: BaseCollectionViewCell {
    
    // MARK: - property
    let tagLabel: UILabel = {
       let label = UILabel()
        label.font = CustomFonts.title4_R14()
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        contentView.addSubview(tagLabel)
        contentView.backgroundColor = .white
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    func setAroundData(data: [String], indexPath: IndexPath, rcmNum: Int) {
        
        let value = data[indexPath.row]
        tagLabel.text = value
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        
        tagLabel.textColor = indexPath.row <= rcmNum ? ColorPalette.error : .black
        contentView.layer.borderColor = indexPath.row <= rcmNum ? ColorPalette.error.cgColor : ColorPalette.gray4.cgColor
    }
    
}
