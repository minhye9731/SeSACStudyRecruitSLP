//
//  BaseView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/7/22.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
        self.backgroundColor = .white
    }
    
    func configureUI() { }
    
    func setConstraints() { }
    
    func giveColotString(label: UILabel, colorStr: String, color: UIColor) {
        
        let attributeLabelStr = NSMutableAttributedString(string: label.text!)
        attributeLabelStr.addAttribute(.foregroundColor, value: color, range: (label.text! as NSString).range(of: colorStr))
        label.attributedText = attributeLabelStr
    }
}
