//
//  CustomFonts.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/8/22.
//

import UIKit

enum CustomFonts: String {
case Regular = "NotoSansCJKkr-Regular"
case Medium = "NotoSansCJKkr-Medium"
    
    // lineheight 추가설정 필요
    func of(size: CGFloat ) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
    
    static func display1_R20() -> UIFont { return CustomFonts.Regular.of(size: 20) }
    
    static func title1_M16() -> UIFont { return CustomFonts.Medium.of(size: 16) }
    static func title2_R16() -> UIFont { return CustomFonts.Regular.of(size: 16) }
    static func title3_M14() -> UIFont { return CustomFonts.Medium.of(size: 14) }
    static func title4_R14() -> UIFont { return CustomFonts.Regular.of(size: 14) }
    static func title5_M12() -> UIFont { return CustomFonts.Medium.of(size: 12) }
    static func title6_R12() -> UIFont { return CustomFonts.Regular.of(size: 12) }
    
    static func body1_M16() -> UIFont { return CustomFonts.Medium.of(size: 16) }
    static func body2_R16() -> UIFont { return CustomFonts.Regular.of(size: 16) }
    static func body3_R14() -> UIFont { return CustomFonts.Regular.of(size: 14) }
    static func body4_R12() -> UIFont { return CustomFonts.Regular.of(size: 12) }
    
    static func caption_R10() -> UIFont { return CustomFonts.Regular.of(size: 10) }
}
