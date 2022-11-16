//
//  EmailView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit

final class EmailView: BaseView {
    
    // MARK: - property
    let notiLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일을 입력해 주세요"
        label.textColor = .black
        label.font = CustomFonts.display1_R20()
        label.textAlignment = .center
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        label.textColor = ColorPalette.gray7
        label.font = CustomFonts.title2_R16()
        label.textAlignment = .center
        return label
    }()
    
    let emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "SeSAC@email.com", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.gray7])
        textfield.font = CustomFonts.title4_R14()
        textfield.tintColor = .black
        textfield.textAlignment = .left
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
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.disableButton(title: "다음")
        return button
    }()
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        
        [notiLabel, subLabel, emailTextField, grayline, nextButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        notiLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(subLabel.snp.top).offset(-8)
        }
        
        subLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(emailTextField.snp.top).offset(-63)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(grayline.snp.top)
        }
        
        grayline.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(1)
            make.bottom.equalTo(nextButton.snp.top).offset(-72)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(1.0)
        }
        
    }
    
}
