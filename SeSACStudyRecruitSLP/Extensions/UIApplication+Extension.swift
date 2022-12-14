//
//  UIApplication+Extension.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/14/22.
//

import UIKit

extension UIApplication {
    
    class func getTopVC() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .filter { $0.isKeyWindow }.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
    
}
