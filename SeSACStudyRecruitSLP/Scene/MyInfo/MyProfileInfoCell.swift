//
//  MyProfileInfoCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/15/22.
//

import UIKit

final class MyProfileInfoCell: BaseTableViewCell {
    
    lazy var cellImage: UIImageView = {
        let image = UIImageView()
        image.layer.borderColor = ColorPalette.gray2.cgColor
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let cellTitle: UILabel = {
        let label = UILabel()
        label.font = CustomFonts.title1_M16()
        return label
    }()
    
    let moreViewImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: Constants.ImageName.more.rawValue)
        return image
    }()
    
    override func configure() {
        super.configure()
        [cellImage, cellTitle, moreViewImage].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        cellImage.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalTo(self)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
        
        cellTitle.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(cellImage.snp.trailing).offset(13)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.5)
        }
        
        moreViewImage.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(self)
            make.width.height.equalTo(24)
        }
    }
    
}




