//
//  InputDateView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/11/22.
//

import UIKit

class InputDateView: BaseView {
    
    // MARK: - property
    let dateTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = CustomFonts.title4_R14()
        textfield.tintColor = .black
        textfield.textAlignment = .left
        textfield.addLeftPadding()
        return textfield
    }()
    
    let termLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = CustomFonts.display1_R20()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let grayline: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.gray3
        return view
    }()
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        [dateTextField, termLabel, grayline].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        dateTextField.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(grayline.snp.top)
            make.trailing.equalTo(termLabel.snp.leading).offset(-4)
        }
        
        termLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(15)
        }
        
        grayline.snp.makeConstraints { make in
            make.leading.bottom.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(1)
            make.trailing.equalTo(termLabel.snp.leading).offset(-4)
        }
        
    }
    
    func setAddDateView(plchdr: String, term: String) {
        dateTextField.attributedPlaceholder = NSAttributedString(string: plchdr, attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.gray7])
        termLabel.text = term
    }
    
}

