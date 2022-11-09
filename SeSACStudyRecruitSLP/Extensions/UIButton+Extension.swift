//
//  UIButton+Extension.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit

extension UIButton {
    
    static func inactiveButton(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.background.strokeColor = ColorPalette.gray4
        config.background.strokeWidth = 1
        var title = AttributedString.init(title)
        title.font = CustomFonts.body3_R14()
        title.foregroundColor = .black
        config.attributedTitle = title
        return config
    }
    
    static func fillButton(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = ColorPalette.green
        config.background.cornerRadius = 8
        var title = AttributedString.init(title)
        title.font = CustomFonts.body3_R14()
        title.foregroundColor = .white
        config.attributedTitle = title
        return config
    }
    
    static func outlineButton(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.background.strokeColor = ColorPalette.green
        config.background.strokeWidth = 1
        var title = AttributedString.init(title)
        title.font = CustomFonts.body3_R14()
        title.foregroundColor = ColorPalette.green
        config.attributedTitle = title
        return config
    }
    
    static func cancelButton(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = ColorPalette.gray2
        var title = AttributedString.init(title)
        title.font = CustomFonts.body3_R14()
        title.foregroundColor = .black
        config.attributedTitle = title
        return config
    }
    
    static func disableButton(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = ColorPalette.gray6
        var title = AttributedString.init(title)
        title.font = CustomFonts.body3_R14()
        title.foregroundColor = ColorPalette.gray3
        config.attributedTitle = title
        return config
    }
}
