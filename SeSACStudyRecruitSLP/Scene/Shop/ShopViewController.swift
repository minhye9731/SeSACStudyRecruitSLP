//
//  ShopViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class ShopViewController: BaseViewController {

    // MARK: - property
    let tableView: UITableView = {
       let view = UITableView()
        view.isScrollEnabled = false
        view.register(CollapsibleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: CollapsibleTableViewHeader.reuseIdentifier)
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
      let segmentedControl = UnderlineSegmentedControl(items: ["새싹", "배경"])
      return segmentedControl
    }()

    private let vc1: ShopSesacViewController = {
      let vc = ShopSesacViewController()
      return vc
    }()
    
    private let vc2: ShopBackgroundViewController = {
      let vc = ShopBackgroundViewController()
      return vc
    }()

    private lazy var pageViewController: UIPageViewController = {
      let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
      vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
      vc.delegate = self
      vc.dataSource = self
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
    override func configure() {
        super.configure()
        self.title = "새싹샵"
        
        tableView.delegate = self

        [tableView, segmentedControl, pageViewController.view].forEach {
            view.addSubview($0)
        }

        tableView.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(tableView.snp.width).multipliedBy(0.62)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(segmentedControl.snp.width).multipliedBy(0.117)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(5)
            $0.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(4)
        }
        
        setSegmentedControl()
    }

    func setSegmentedControl() {
    self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
    self.segmentedControl.setTitleTextAttributes(
      [
        NSAttributedString.Key.foregroundColor: UIColor.green,
        .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
      ],
      for: .selected
    )
    self.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
    self.segmentedControl.selectedSegmentIndex = 0
    self.changeValue(control: self.segmentedControl)
    }

    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }

}

// MARK: - pageview controller
extension ShopViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        return width * 0.51
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.reuseIdentifier) as? CollapsibleTableViewHeader else { return UIView() }
        
        // 별도 정리
        headerView.backgroundImage.image = UIImage(named: Constants.ImageName.bg1.rawValue)
        headerView.sesacImage.image = UIImage(named: Constants.ImageName.face1.rawValue)
        headerView.nameView.isHidden = true
        headerView.askAcceptbtn.setTitle("저장하기", for: .normal)
        
        headerView.askAcceptbtn.addTarget(self, action: #selector(askAcceptbtnTapped), for: .touchUpInside)
        headerView.askAcceptbtn.header = headerView
        headerView.askAcceptbtn.section = section
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseIdentifier) as? ProfileCell else { return UITableViewCell() }
        return profileCell
    }

}

// MARK: - pageview controller
extension ShopViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return dataViewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController), index + 1 < self.dataViewControllers.count else { return nil }
        return dataViewControllers[index + 1]
    }
}

extension ShopViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0],
              let index = self.dataViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }
}

// MARK: - 기타 함수
extension ShopViewController {
    
    @objc func askAcceptbtnTapped(sender: HeaderSectionPassButton) {
//        guard let section = sender.section else { return }
     
        print("저장하기! :)")
        
    }
    
}
