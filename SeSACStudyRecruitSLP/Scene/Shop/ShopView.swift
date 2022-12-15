//
//  ShopView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/15/22.
//

import UIKit

final class ShopView: BaseView {
    
    // MARK: - property
    let tableView: UITableView = {
       let view = UITableView()
        view.isScrollEnabled = false
        view.register(CollapsibleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: CollapsibleTableViewHeader.reuseIdentifier)
        return view
    }()
    
    let segmentedControl: UISegmentedControl = {
      let segmentedControl = UnderlineSegmentedControl(items: ["새싹", "배경"])
      return segmentedControl
    }()

    let vc1: ShopSesacViewController = {
      let vc = ShopSesacViewController()
      return vc
    }()
    
    let vc2: ShopBackgroundViewController = {
      let vc = ShopBackgroundViewController()
      return vc
    }()

    lazy var pageViewController: UIPageViewController = {
      let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
      vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
      return vc
    }()
    
    var dataViewControllers: [UIViewController] {
      [self.vc1, self.vc2]
    }

    var currentPage: Int = 0 {
      didSet {
        print(oldValue, self.currentPage)
        let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
        self.pageViewController.setViewControllers(
          [dataViewControllers[self.currentPage]],
          direction: direction,
          animated: true,
          completion: nil
        )
      }
    }

    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        
        [tableView, segmentedControl, pageViewController.view].forEach {
            self.addSubview($0)
        }
        
        setSegmentedUI()
        pageViewController.dataSource = self
    }
    
    
    override func setConstraints() {
        super.setConstraints()
        
        tableView.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(tableView.snp.width).multipliedBy(0.62)
        }
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(segmentedControl.snp.width).multipliedBy(0.117)
        }
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(5)
            $0.directionalHorizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
    }
    
    func setSegmentedUI() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.green,
                .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
            ],
            for: .selected)
    }
    
    
}


extension ShopView: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return dataViewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController), index + 1 < dataViewControllers.count else { return nil }
        return dataViewControllers[index + 1]
    }
    
}
