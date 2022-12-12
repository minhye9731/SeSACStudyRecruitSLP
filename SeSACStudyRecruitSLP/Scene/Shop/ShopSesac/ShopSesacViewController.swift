//
//  ShopSesacViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/5/22.
//

import UIKit

final class ShopSesacViewController: BaseViewController {
    
    // MARK: - property
    let mainView = ShopSesacView()
    
    // MARK: - Lifecycle
    override func loadView()  {
        self.view = mainView
    }
}
