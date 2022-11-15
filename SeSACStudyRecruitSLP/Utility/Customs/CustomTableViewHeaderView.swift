//
//  CustomTableViewHeaderView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/15/22.
//

import UIKit
import SnapKit

final class CustomTableViewHeaderView: UITableViewHeaderFooterView {
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let sesacImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
            contentView.addSubview(backgroundImage)
            backgroundImage.addSubview(sesacImage)
    }
    
    func setConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(backgroundImage.snp.width).multipliedBy(0.58)
        }
        
        sesacImage.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).multipliedBy(1.3)
            make.width.equalTo(contentView).multipliedBy(0.4)
            make.height.equalTo(sesacImage.snp.width)
        }
    }
    
}

