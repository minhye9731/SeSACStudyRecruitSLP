//
//  ShopViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit
import FirebaseAuth
import StoreKit

final class ShopViewController: BaseViewController {

    // MARK: - property
    let mainView = ShopView()

    // MARK: - Lifecycle
    override func loadView()  {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.checkShopMyInfo()
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        self.title = "새싹샵"

        mainView.shopSaveButtonActionHandler = {
            self.mainView.requestShopItem()
        }
    }

}
