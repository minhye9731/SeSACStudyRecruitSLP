//
//  UserCardNameTapGestureRecognizer.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/24/22.
//

import UIKit

class UserCardNameTapGestureRecognizer: UITapGestureRecognizer {
    var header: CollapsibleTableViewHeader?
    var section: Int?
    var isTouched: Bool? = false
    
    func setIsTouched() {
        self.isTouched?.toggle()
    }
}
