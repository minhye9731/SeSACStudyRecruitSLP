//
//  MycellHeaderView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class MycellHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "MycellHeaderView-reuse-identifier"
    
    let profileimage: UIImageView = {
       let image = UIImageView()
        image.layer.borderWidth = 1
        image.layer.borderColor = ColorPalette.gray2.cgColor
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        return image
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = CustomFonts.title1_M16()
        label.textAlignment = .left
        return label
    }()
    
    let nextPage: UIImageView = {
       let image = UIImageView()
        image.tintColor = ColorPalette.gray7
        image.image = UIImage(systemName: Constants.ImageName.more.rawValue)
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setconstraints()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() {
        [profileimage, userNameLabel, nextPage].forEach {
            self.addSubview($0)
        }
        self.backgroundColor = .white
    }
    
    func setconstraints() {
        profileimage.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalTo(self)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(2)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileimage.snp.trailing).offset(13)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.5)
        }
        
        nextPage.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide)
            make.centerY.equalTo(self)
            make.width.height.equalTo(24)
        }
        
    }
}
