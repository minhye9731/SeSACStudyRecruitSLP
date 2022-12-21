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
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let localeID = Locale.preferredLanguages.first
        let deviceLocale = Locale(identifier: localeID ?? "ko_kr").languageCode
        dateFormatter.locale = Locale(identifier: deviceLocale ?? "ko_kr")
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.date(from: self) ?? dateFormatter.date(from: "2000-01-01T00:00:00.000Z")!
    }
    
}
