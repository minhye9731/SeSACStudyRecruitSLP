//
//  VerifyNumberView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit

final class VerifyNumberView: BaseView {
    
    // MARK: - property
    let notiLabel: UILabel = {
        let label = UILabel()
        label.text = "인증번호가 문자로 전송되었어요"
        label.textColor = .black
        label.font = CustomFonts.display1_R20()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let verifyNumberTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "인증번호 입력", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.gray7])
        textfield.font = CustomFonts.title4_R14()
        textfield.tintColor = ColorPalette.gray7
        textfield.textAlignment = .left
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "05:00"
        label.textColor = ColorPalette.green
        label.font = CustomFonts.title3_M14()
        label.textAlignment = .right
        return label
    }()
    
    let grayline: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.gray3
        return view
    }()
    
    let resentButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.fillButton(title: "재전송")
        return button
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.disableButton(title: "인증하고 시작하기")
        return button
    }()
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()

        [notiLabel, verifyNumberTextField, grayline, resentButton, startButton].forEach {
            self.addSubview($0)
        }
        
        verifyNumberTextField.addSubview(timerLabel)
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        notiLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(verifyNumberTextField.snp.top).offset(-97)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(verifyNumberTextField.snp.centerY)
            make.trailing.equalTo(verifyNumberTextField.snp.trailing).offset(-12)
        }
        
        verifyNumberTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(resentButton.snp.leading).offset(-8)
            make.height.equalTo(48)
            make.bottom.equalTo(grayline.snp.top)
        }
        
        grayline.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(resentButton.snp.leading).offset(-8)
            make.height.equalTo(1)
            make.bottom.equalTo(startButton.snp.top).offset(-72)
        }
        
        resentButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(40)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(startButton.snp.top).offset(-74)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(1.0)
        }
    }
}
