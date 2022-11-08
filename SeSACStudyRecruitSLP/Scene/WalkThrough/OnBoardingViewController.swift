//
//  OnBoardingViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/8/22.
//

import UIKit

final class OnBoardingViewController: BaseViewController {
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var pageViewControllerList: [UIViewController] = []
    
    
    override func configure() {
        
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: Int(view.bounds.height - 140))
        
        view.addSubview(pageViewController.view)
        
        addChild(pageViewController)
        pageViewController.dataSource = self // 뷰 넘기는 메소드가 있어서 정의해야함
        pageViewController.delegate = self
        
        //
        createPageViewController()
        configurePageViewController()
    }
    
    override func setConstraints() {
        
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
    
    
}

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
