//
//  OnBoardingViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/8/22.
//

import UIKit
import SnapKit

final class OnBoardingViewController: BaseViewController {
    
    // MARK: - property
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var pageViewControllerList: [UIViewController] = []
    private var pageControl: UIPageControl = {
        let pc = UIPageControl(frame: .zero)
        pc.pageIndicatorTintColor = ColorPalette.gray5
        pc.currentPageIndicatorTintColor = .black
        return pc
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.fillButton(title: "시작하기")
        return button
    }()
    
    deinit {
        print("🎬🎬🎬OnBoardingViewController deinit🎬🎬🎬")
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        [pageViewController.view, startButton].forEach {
            view.addSubview($0)
        }
        setPageVC()
        setPageControl()
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        UserDefaults.standard.set("", forKey: "authVerificationID") // test
    }

    
    override func setConstraints() {
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
        }
    }
    
    func setPageVC() {
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: Int(view.bounds.height - 140))
        addChild(pageViewController)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        createPageViewController()
        configurePageViewController()
    }
    
    func createPageViewController() {
        let vc1 = FirstViewController()
        let vc2 = SecondViewController()
        let vc3 = ThirdViewController()
        pageViewControllerList = [vc1, vc2, vc3]
    }
    
    func configurePageViewController() {
        guard let first = pageViewControllerList.first else { return }
        pageViewController.setViewControllers([first], direction: .forward, animated: true)
    }
    
    func setPageControl() {
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        pageControl.pageIndicatorTintColor = ColorPalette.gray5
        pageControl.currentPageIndicatorTintColor = .black
    }
    
    @objc func startButtonTapped() {
        UserDefaultsManager.firstRun = false
        print(UserDefaultsManager.firstRun)
        changeRootNavVC(vc: PhoneNumberViewController())
    }
}

// MARK: - PageView 구성
extension OnBoardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = pageViewController.viewControllers?.first, let index = pageViewControllerList.firstIndex(of: first) else { return 0 }
        return index
    }
}
