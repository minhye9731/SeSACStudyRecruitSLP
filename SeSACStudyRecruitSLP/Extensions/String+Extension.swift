//
//  String+Extension.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/21/22.
//

import Foundation

extension String {
    
    func autoAddHyphen() -> String {
        var phoneNum: String
        if self.count > 3 && self.count < 8 {
            phoneNum = self.replacingOccurrences(of: "(\\d{3})(\\d{1})", with: "$1-$2", options: .regularExpression)
            return phoneNum
        } else if self.count > 8  {
            phoneNum = self.replacingOccurrences(of: "(\\d{3})-(\\d{4})(\\d{1})", with: "$1-$2-$3", options: .regularExpression)
            return phoneNum
        }
        return self
    }
    
    func autoRemoveHyphen() -> String {
        let result = self.replacingOccurrences(of: "-", with: "").dropFirst()
        let addNationality = "+82\(result)"
        return addNationality
    }
    
    
}
