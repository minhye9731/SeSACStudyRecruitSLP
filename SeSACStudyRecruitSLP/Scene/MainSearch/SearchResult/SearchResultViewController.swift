//
//  SearchResultViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit
import Tabman
import Pageboy

final class SearchResultViewController: TabmanViewController {
    
    var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "새싹 찾기"
        view.backgroundColor = .white
        setBarButtonItem()
        setVC()
    }
    
    
    
    func setVC() {
        let vc = ListViewController()
        viewControllers.append(vc)
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        settingTabBar(ctBar: bar)
        addBar(bar, dataSource: self, at: .top)
    }
    
    func settingTabBar (ctBar : TMBar.ButtonBar) {
        ctBar.backgroundView.style = .clear
        ctBar.backgroundColor = .white

        ctBar.layout.transitionStyle = .snap
        ctBar.layout.alignment = .centerDistributed
        ctBar.layout.contentMode = .fit
        ctBar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

        ctBar.buttons.customize { (button) in
            button.tintColor = ColorPalette.gray6
            button.selectedTintColor = ColorPalette.green
            button.font = CustomFonts.title4_R14()
            button.selectedFont = CustomFonts.title3_M14()
        }

        ctBar.indicator.weight = .custom(value: 2)
        ctBar.indicator.tintColor = ColorPalette.green
        ctBar.indicator.overscrollBehavior = .compress
    }
    
}
extension SearchResultViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0: return TMBarItem(title: "주변 새싹")
        case 1: return TMBarItem(title: "받은 요청")
        default: return TMBarItem(title: " ")
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return 2
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return ListViewController()
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil // 명세서 재확인 필요
    }
}










// MARK: - 찾기 중단 메서드
extension SearchResultViewController {
    func setBarButtonItem() {
        let navibarAppearance = UINavigationBarAppearance()
        let barbuttonItemAppearance = UIBarButtonItemAppearance()
        barbuttonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black, .font: CustomFonts.title3_M14()]
        navibarAppearance.buttonAppearance = barbuttonItemAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopTapped))
    }
    
    @objc func stopTapped() {
        print("찾기 중단 클릭됨!! :)")
    }
}
