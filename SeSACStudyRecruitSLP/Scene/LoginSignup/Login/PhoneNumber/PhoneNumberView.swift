//
//  LoginView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit

final class PhoneNumberView: BaseView {
    
    // MARK: - property
    let notiLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요"
        label.textColor = .black
        label.font = CustomFonts.display1_R20()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let phoneNumberTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "휴대폰 번호(-없이 숫자만 입력)", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.gray7])
        textfield.font = CustomFonts.title4_R14()
        textfield.tintColor = ColorPalette.gray7
        textfield.textAlignment = .left
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    let grayline: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.gray3
        return view
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.disableButton(title: "인증 문자 받기")
        return button
    }()
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        [notiLabel, phoneNumberTextField, grayline, startButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        notiLabel.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(64)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(phoneNumberTextField.snp.top).offset(-64)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(grayline.snp.top)
        }
        
        grayline.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(1)
            make.bottom.equalTo(startButton.snp.top).offset(-72)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(1.0)
        }
        
    }
    
    
}
