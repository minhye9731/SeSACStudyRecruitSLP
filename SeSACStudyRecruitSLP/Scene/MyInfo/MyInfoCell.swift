//
//  MyInfoCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class MyInfoCell: BaseTableViewCell {
    
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


//final class MyInfoCell: BaseCollectionViewCell {
//
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.black
//        label.font = CustomFonts.title2_R16()
//        label.textAlignment = .left
//        return label
//    }()
//
//    let menuimage: UIImageView = {
//       let image = UIImageView()
//        image.tintColor = .black
//        return image
//    }()
//
//    let nextPage: UIImageView = {
//       let image = UIImageView()
//        image.tintColor = ColorPalette.gray7
////        image.image = UIImage(systemName: Constants.ImageName.more.rawValue)
//        return image
//    }()
//
//    override func configure() {
//        super.configure()
//        [titleLabel, menuimage, nextPage].forEach {
//            contentView.addSubview($0)
//        }
//    }
//
//    override func setConstraints() {
//        super.setConstraints()
//
//        menuimage.snp.makeConstraints { make in
//            make.leading.equalTo(self.safeAreaLayoutGuide)
//            make.centerY.equalTo(self.safeAreaLayoutGuide)
//            make.height.width.equalTo(20)
//        }
//
//        titleLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(self.safeAreaLayoutGuide)
//            make.leading.equalTo(menuimage.snp.trailing).offset(14)
//            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.5)
//        }
//
//        nextPage.snp.makeConstraints { make in
//            make.trailing.equalTo(self.safeAreaLayoutGuide)
//            make.centerY.equalTo(self)
//            make.width.height.equalTo(24)
//        }
//
//    }
//
//}
