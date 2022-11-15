//
//  genderCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class GenderCell: BaseTableViewCell {
    
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
        button.configuration = UIButton.genderTextButton(title: "남자")
        return button
    }()

    let FemaleButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.genderTextButton(title: "여자")
        return button
    }()
    
    override func configure() {
        super.configure()
        [titleLabel, MaleButton, FemaleButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.5)
        }
        
        MaleButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.trailing.equalTo(FemaleButton.snp.leading).offset(-8)
        }
        
        FemaleButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        
    }
    
}
