//
//  ShopBackgroundViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/5/22.
//

import UIKit

final class ShopBackgroundViewController: BaseViewController {
    
    // MARK: - property
    let mainView = ShopBackgroundView()
    
    // MARK: - Lifecycle
    override func loadView()  {
        self.view = mainView
    }
    
}
