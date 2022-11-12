//
//  Date+Extension.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/12/22.
//

import UIKit

extension Date {
    
    func toBirthDateForm() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DDTHH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
