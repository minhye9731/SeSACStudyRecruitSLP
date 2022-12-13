//
//  ShopBackgroundCollectionViewCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/6/22.
//

import UIKit

final class ShopBackgroundCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    let productImg: UIImageView = {
       let image = UIImageView()
        image.layer.cornerRadius = 8
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        return image
    }()
    
    let infoView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.autoresizingMask = .flexibleHeight
        return view
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
        label.font = CustomFonts.title3_M14()
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    let descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = CustomFonts.body3_R14()
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        [productImg, infoView].forEach {
            contentView.addSubview($0)
        }
        [priceButton, productNameLabel, descriptionLabel].forEach {
            infoView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        productImg.snp.makeConstraints {
            $0.leading.directionalVerticalEdges.equalTo(contentView)
            $0.width.equalTo(productImg.snp.height)
        }
        
        infoView.snp.makeConstraints {
            $0.leading.equalTo(productImg.snp.trailing).offset(12)
            $0.trailing.equalTo(contentView)
            $0.centerY.equalTo(productImg.snp.centerY)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.leading.top.equalTo(infoView)
        }
        
        priceButton.snp.makeConstraints {
            $0.trailing.top.equalTo(infoView)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(8)
            $0.leading.bottom.trailing.equalTo(infoView)
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
