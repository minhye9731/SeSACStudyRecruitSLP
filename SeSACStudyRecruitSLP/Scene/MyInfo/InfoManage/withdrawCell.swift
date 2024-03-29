//
//  withdrawCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

class WithdrawCell: BaseTableViewCell {
    
    // MARK: - property
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원탈퇴"
        label.textColor = UIColor.black
        label.font = CustomFonts.title4_R14()
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        contentView.addSubview(titleLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.width.equalTo(contentView).multipliedBy(0.5)
            make.bottom.equalTo(contentView).offset(-16)
        }
        
    }
    
}

