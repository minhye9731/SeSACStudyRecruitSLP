//
//  MyInfoCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class MyInfoCell: BaseTableViewCell {
    
    // MARK: - property
    let menuimage: UIImageView = {
       let image = UIImageView()
        image.tintColor = .black
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = CustomFonts.title2_R16()
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        [titleLabel, menuimage].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        menuimage.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.height.width.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(menuimage.snp.trailing).offset(14)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.5)
            
        }
    }
}
