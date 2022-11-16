//
//  oftenStudyCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class OftenStudyCell: BaseTableViewCell {
    
    // MARK: - property
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "자주 하는 스터디"
        label.textColor = UIColor.black
        label.font = CustomFonts.title4_R14()
        label.textAlignment = .left
        return label
    }()
    
    let studyTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "스터디를 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.gray7])
        textfield.font = CustomFonts.title4_R14()
        textfield.tintColor = .black
        textfield.textAlignment = .center
        textfield.keyboardType = .default
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        return textfield
    }()

    let grayline: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.gray3
        return view
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        [titleLabel, studyTextField, grayline].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(studyTextField.snp.centerY)
            make.width.equalTo(contentView).multipliedBy(0.5)
        }
        
        studyTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(13)
            make.width.equalTo(136)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-32)
            make.bottom.equalTo(contentView).offset(-13)
        }
        
        grayline.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-13)
            make.height.equalTo(1)
            make.width.equalTo(164)
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
}

