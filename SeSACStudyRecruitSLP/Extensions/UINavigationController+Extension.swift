//
//  UINavigationController+Extension.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/30/22.
//

import UIKit

extension UINavigationController {
    
    func push(_ viewControllers: [UIViewController]) {
        setViewControllers(self.viewControllers + viewControllers, animated: true)
    }
    
    func popViewControllers(_ count: Int) {
        guard viewControllers.count > count else { return }
        popToViewController(viewControllers[viewControllers.count - count - 1], animated: true)
    }
    
    
}
