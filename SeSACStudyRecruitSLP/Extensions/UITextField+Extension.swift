//
//  UITextField+Extension.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/11/22.
//

import UIKit

extension UITextField {
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
