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
        btn.contentEdgeInsets = UIEdgeInsets(top: 1.5, left: 6, bottom: 1.5, right: 6)
        btn.titleLabel?.font = CustomFonts.title5_M12()
        btn.layer.cornerRadius = 10 // check
        btn.clipsToBounds = true
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
            $0.centerY.equalTo(productNameLabel.snp.centerY)
            $0.height.equalTo(20) // check
            $0.trailing.equalTo(contentView)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(8)
            $0.directionalHorizontalEdges.bottom.equalTo(contentView)
        }
    }
    
    func setData(data: SesacController.SesacItem, collection: [Int], indexPath: IndexPath) {
        
        productImg.image = UIImage(named: data.image)
        productNameLabel.text = data.name
        descriptionLabel.text = data.description
        
        let price = collection.contains(indexPath.row) ? "보유" : data.price
        let bgColor = collection.contains(indexPath.row) ? ColorPalette.gray2 : ColorPalette.green
        let textColor =  collection.contains(indexPath.row) ? ColorPalette.gray7 : .white
        
        priceButton.setTitle(price, for: .normal)
        priceButton.setTitleColor(textColor, for: .normal)
        priceButton.backgroundColor = bgColor
    }
    
}
