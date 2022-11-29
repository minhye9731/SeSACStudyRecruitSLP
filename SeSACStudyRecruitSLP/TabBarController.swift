//
//  TabBarController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupTabBarAppearance()
    }
    
    func configure() {
        let firstVC = MainViewController()
        firstVC.tabBarItem = UITabBarItem(title: "홈",
                                          image: UIImage(named: Constants.ImageName.homeAct.rawValue),
                                          selectedImage: UIImage(named: Constants.ImageName.homeInact.rawValue))
        let firstNav = UINavigationController(rootViewController: firstVC)
        
        let secondVC = ShopViewController()
        secondVC.tabBarItem = UITabBarItem(title: "새싹샵",
                                           image: UIImage(named: Constants.ImageName.shopAct.rawValue),
                                           selectedImage: UIImage(named: Constants.ImageName.shopInact.rawValue))
        let secondNav = UINavigationController(rootViewController: secondVC)
        
        let thirdVC = FriendViewController()
        thirdVC.tabBarItem = UITabBarItem(title: "새싹친구",
                                          image: UIImage(named: Constants.ImageName.friendsAct.rawValue),
                                          selectedImage: UIImage(named: Constants.ImageName.friendsInact.rawValue))
        let thirdNav = UINavigationController(rootViewController: thirdVC)
        
        let fourthVC = MyInfoViewController()
        fourthVC.tabBarItem = UITabBarItem(title: "내정보",
                                          image: UIImage(named: Constants.ImageName.myAct.rawValue),
                                          selectedImage: UIImage(named: Constants.ImageName.myInact.rawValue))
        let fourthNav = UINavigationController(rootViewController: fourthVC)
        
        setViewControllers([firstNav, secondNav, thirdNav, fourthNav], animated: true)
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.unselectedItemTintColor = ColorPalette.gray6
        tabBar.tintColor = ColorPalette.green
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        guard let theItems = self.tabBar.items, let index = theItems.firstIndex(of: item), let controllers = self.viewControllers else { return }
        
        if let nav = controllers[index] as? UINavigationController, let homeVC = nav.topViewController as? MainViewController {
            homeVC.searchSesac()
        }
    }
    
    
}
