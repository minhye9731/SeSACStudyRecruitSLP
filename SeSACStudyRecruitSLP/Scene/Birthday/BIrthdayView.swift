//
//  BIrthdayView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit

final class BIrthdayView: BaseView {
    
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
    
    let dateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let yearTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "1990", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.gray7])
        textfield.font = CustomFonts.title4_R14()
        textfield.tintColor = .black
        textfield.textAlignment = .left
        return textfield
    }()
    let monthTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "1", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.gray7])
        textfield.font = CustomFonts.title4_R14()
        textfield.tintColor = .black
        textfield.textAlignment = .left
        return textfield
    }()
    let dayTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "1", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.gray7])
        textfield.font = CustomFonts.title4_R14()
        textfield.tintColor = .black
        textfield.textAlignment = .left
        return textfield
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "년"
        label.textColor = .black
        label.font = CustomFonts.display1_R20()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "인증번호가 문자로 전송되었어요"
        label.textColor = .black
        label.font = CustomFonts.display1_R20()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "인증번호가 문자로 전송되었어요"
        label.textColor = .black
        label.font = CustomFonts.display1_R20()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let graylineOne: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.gray3
        return view
    }()
    let graylineTwo: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.gray3
        return view
    }()
    let graylineThr: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.gray3
        return view
    }()
    
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.disableButton(title: "다음")
        return button
    }()
    
    
    override func configureUI() {
        super.configureUI()
        
        
        
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
    }
    
    
}
