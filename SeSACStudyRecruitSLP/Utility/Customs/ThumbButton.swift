//
//  ThumbButton.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

class ThumbButton: RoundableButton {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = ColorPalette.green
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ColorPalette.green
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
