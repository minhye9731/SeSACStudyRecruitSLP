//
//  genderCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class GenderCell: BaseTableViewCell {
    
    // MARK: - property
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 성별"
        label.textColor = UIColor.black
        label.font = CustomFonts.title4_R14()
        label.textAlignment = .left
        return label
    }()
    
    let MaleButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.textButton(title: "남자")
        return button
    }()
  
    let FemaleButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.textButton(title: "여자")
        return button
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        [titleLabel, MaleButton, FemaleButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(MaleButton.snp.centerY)
            make.width.equalTo(contentView).multipliedBy(0.5)
        }
        
        MaleButton.snp.makeConstraints { make in
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.centerY.equalTo(FemaleButton.snp.centerY)
            make.trailing.equalTo(FemaleButton.snp.leading).offset(-8)
        }
        
        FemaleButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(12)
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.trailing.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-12)
        }
        
    }
    
}
