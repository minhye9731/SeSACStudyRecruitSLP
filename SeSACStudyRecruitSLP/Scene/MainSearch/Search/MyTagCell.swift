//
//  MyTagCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/23/22.
//

import UIKit

class MyTagCell: BaseCollectionViewCell {
    
    let myTabButton: UIButton = {
       let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.image = UIImage(named: Constants.ImageName.smallClose.rawValue)?.withRenderingMode(.alwaysTemplate)
        config.baseForegroundColor = ColorPalette.green
        config.imagePadding = 4
        config.imagePlacement = NSDirectionalRectEdge.trailing
        var title = AttributedString.init(" ")
        title.font = CustomFonts.title4_R14()
        title.foregroundColor = ColorPalette.green
        config.attributedTitle = title
        
        btn.configuration = config
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    override func configure() {
        super.configure()
        contentView.addSubview(myTabButton)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = ColorPalette.green.cgColor
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        myTabButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setMyWishData(indexPath: IndexPath) {
        let value =  UserDefaultsManager.mywishTagList[indexPath.row]
        myTabButton.configuration?.title = value as? String
    }
    
}
