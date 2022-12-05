//
//  ShopViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {
    // MARK: - property
    
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clearBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.clearBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - functions
    private func clearBackgroundAndDivider() {
        let img = UIImage()
        self.setBackgroundImage(img, for: .normal, barMetrics: .default)
        self.setBackgroundImage(img, for: .selected, barMetrics: .default)
        self.setBackgroundImage(img, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(img, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
}

final class ShopViewController: BaseViewController {
    
    // MARK: - property
    
    let preView: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
//    private let segmentedControl: UISegmentedControl = {
//
//    }()
    
//    lazy var navigatinView: UIView = {
//       let view = UIView()
//        view.backgroundColor = .systemMint
//        return view
//    }()

    private let vc1: UIViewController = {
        let vc = ShopSesacViewController()
        return vc
    }()

    private let vc2: UIViewController = {
        let vc = ShopBackgroundViewController()
        return vc
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.dataSource = self
        vc.delegate = self
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
                completion: nil)
        }
    }
    
    // MARK: - Lifecycle
    override func loadView()  {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()

        
    }
    
    // MARK: - functions
    private func setupDelegate() {
        
    }
    
    override func configure() {
        super.configure()
        self.title = "새싹샵"
        view.backgroundColor = .orange
        
//        view.addSubview(navigatinView)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        preView.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(150)
        }
        
//        navigatinView.snp.makeConstraints {
//            $0.width.equalToSuperview()
//            $0.top.equalTo(preView.snp.bottom)
//            $0.height.equalTo(72)
//        }
        
        pageViewController.view.snp.makeConstraints {
//            $0.top.equalTo(navigatinView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        pageViewController.didMove(toParent: self)
    }
    
    
    
    

}

extension ShopViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        return dataViewControllers[nextIndex]
    }
}
