//
//  ShopSesacCollectionViewCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/6/22.
//

import UIKit

final class ShopSesacCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    let productImg: UIImageView = {
       let image = UIImageView()
        image.layer.borderColor = ColorPalette.gray2.cgColor
        image.backgroundColor = .white
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 8
        image.contentMode = .scaleAspectFit
        return image
    }()
    let priceButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = ColorPalette.gray2
        btn.setTitle("보유", for: .normal) // test
        btn.setTitleColor(ColorPalette.gray7, for: .normal)
        btn.titleLabel?.font = CustomFonts.title5_M12()
        return btn
    }()
    let productNameLabel: UILabel = {
       let label = UILabel()
        label.font = CustomFonts.title2_R16()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    let descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = CustomFonts.body3_R14()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    
    // MARK: - functions
    override func configure() {
        super.configure()

        [productImg, priceButton, productNameLabel, descriptionLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        productImg.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalTo(contentView)
            $0.height.equalTo(productImg.snp.width)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImg.snp.bottom).offset(8)
            $0.leading.equalTo(contentView)
        }
        
        priceButton.snp.makeConstraints {
            $0.top.equalTo(productImg.snp.bottom).offset(8)
            $0.trailing.equalTo(contentView)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(8)
            $0.directionalHorizontalEdges.bottom.equalTo(contentView)
        }
     
    }
    
}
