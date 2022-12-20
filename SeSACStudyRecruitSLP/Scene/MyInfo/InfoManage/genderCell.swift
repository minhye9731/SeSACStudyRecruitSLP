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
    
    let manButton: UIButton = {
        let button = UIButton.genderBtn(title: "남자")
        return button
    }()
  
    let womanButton: UIButton = {
        let button = UIButton.genderBtn(title: "여자")
        return button
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        [titleLabel, manButton, womanButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(manButton.snp.centerY)
            make.width.equalTo(contentView).multipliedBy(0.5)
        }
        
        manButton.snp.makeConstraints { make in
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.centerY.equalTo(womanButton.snp.centerY)
            make.trailing.equalTo(womanButton.snp.leading).offset(-8)
        }
        
        womanButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(12)
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.trailing.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-12)
        }
    }
    
    func setData(data: Int) {
        let selectBtn = data == 0 ? womanButton : manButton
        let unselectBtn = data == 0 ? manButton : womanButton
        
        selectBtn.backgroundColor = ColorPalette.green
        selectBtn.layer.borderColor = ColorPalette.green.cgColor
        selectBtn.setTitleColor(.white, for: .normal)
        unselectBtn.backgroundColor = .white
        unselectBtn.layer.borderColor = ColorPalette.gray3.cgColor
        unselectBtn.setTitleColor(.black, for: .normal)
    }
    
   
}
