//
//  ShopView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/15/22.
//

import UIKit
import StoreKit
import FirebaseAuth

final class ShopView: BaseView {
    
    // MARK: - property
    var shopSaveButtonActionHandler: (() -> ())?
    var selectedBG = 0
    var selectedFC = 0
    
    var productIdentifiers: Set<String> = []
    var productArray = Array<SKProduct>()
    var product: SKProduct?
    
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
        setSegmentedControl()
        setDelegate()
        setPriceButtonBuyAction()
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
    
    func setDelegate() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        tableView.delegate = self
        vc1.mainView.collectionView.delegate = self
        vc2.mainView.collectionView.delegate = self
    }
}

// MARK: - pageViewController - DataSource
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

// MARK: - pageViewController - Delegate
extension ShopView: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0],
              let index = dataViewControllers.firstIndex(of: viewController)
        else { return }
        currentPage = index
        segmentedControl.selectedSegmentIndex = index
    }
}

// MARK: - setSegmentedControl
extension ShopView {

    func setSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        self.changeValue(control: segmentedControl)
    }

    @objc private func changeValue(control: UISegmentedControl) {
        currentPage = control.selectedSegmentIndex
        
        // 1. 탭에 따라 상품정보 할당
        if currentPage == 0 {
            productIdentifiers = [
                "com.memolease.sesac1.sprout1",
                "com.memolease.sesac1.sprout2",
                "com.memolease.sesac1.sprout3",
                "com.memolease.sesac1.sprout4"
            ]
        } else {
            productIdentifiers = [
                "com.memolease.sesac1.background1",
                "com.memolease.sesac1.background2",
                "com.memolease.sesac1.background3",
                "com.memolease.sesac1.background4",
                "com.memolease.sesac1.background5",
                "com.memolease.sesac1.background6",
                "com.memolease.sesac1.background7"
            ]
        }
        requestProductData()
    }
    
}

// MARK: - tableView
extension ShopView: UITableViewDelegate {
    
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

        headerView.setPreviewData(section: section, bg: selectedBG, sprout: selectedFC)
        headerView.askAcceptbtn.addTarget(self, action: #selector(askAcceptbtnTapped), for: .touchUpInside)
        return headerView
    }
    
    @objc func askAcceptbtnTapped() {
        shopSaveButtonActionHandler!()
    }
}

extension ShopView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseIdentifier) as? ProfileCell else { return UITableViewCell() }
        return profileCell
    }
}

// MARK: - vc1, vc2내 collectionview cell 클릭시 액션
extension ShopView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == vc1.mainView.collectionView {
            selectedFC = indexPath.row
        } else {
            selectedBG = indexPath.row
        }
        tableView.reloadData()
    }

    // 4. price 버튼 클릭
    func setPriceButtonBuyAction() {
        vc1.mainView.ssPriceButtonActionHandler = { row in
            
            if row == 0 {
                self.makeToast("기본값으로 보유하신 상품입니다", duration: 1.0, position: .center)
            } else {
                let buyProduct = self.productArray[row - 1]
                print("새싹을 클릭했다!!! \(buyProduct)")
                let payment = SKPayment(product: buyProduct)
                SKPaymentQueue.default().add(payment)
                 SKPaymentQueue.default().add(self)
            }
        }
        
        vc2.mainView.bgPriceButtonActionHandler = { row in

            if row == 0 {
                self.makeToast("기본값으로 보유하신 상품입니다", duration: 1.0, position: .center)
            } else {
                let buyProduct = self.productArray[row - 1]
                print("새싹을 클릭했다!!! \(buyProduct)")
                let payment = SKPayment(product: buyProduct)
                SKPaymentQueue.default().add(payment)
                 SKPaymentQueue.default().add(self)
            }
        }
    }
    
}

// MARK: - 인앱결제 | 가능여부 확인
extension ShopView {
    
    //  2. productIdentifiers에 정의된 상품ID에 대한 정보 가져오기 및 사용자의 디바이스가 인앱결제가 가능한지 여부 확인
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            
            print("😎인앱 결제 가능😎")
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            makeToast("해당 상품은 인앱 결제가 불가능합니다.", duration: 1.0, position: .center)
        }
    }
    
}

// MARK: - 인앱결제 | 인앱상품 조회
extension ShopView: SKProductsRequestDelegate {
    
    
    // 3. 인앱 상품 정보 조회 응답 메서드
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(#function)
        
        let products = response.products
        print("상품조회한 정보들 : \(products)")
        
        if products.count > 0 {
            productArray.removeAll()
            
            for i in products {
                productArray.append(i)
                
                product = i //옵션. 테이블뷰 셀에서 구매하기 버튼 클릭 시, 버튼 클릭 시???
                print(i.localizedTitle, i.price, i.priceLocale, i.localizedDescription)
            }
            
            print(productArray)
        } else {
            makeToast("해당 상품 조회에 실패했습니다.", duration: 1.0, position: .center)
        }
        
    }
    
    
    // 영수증 검증 => 여기서 서버를 통해 검증해야함
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        
        //구매 영수증 정보
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        guard let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) else { return }
        print("🎃 구매성공 | 영수증 = \(receiptString), 상품 = \(productIdentifier)")
        
        requestIos(receipt: receiptString, IAPBundle: productIdentifier)
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
}


// MARK: - 인앱결제 구매 Observer
extension ShopView: SKPaymentTransactionObserver {
    
    // 5. 구매버튼 클릭에 따른 결제 프로세스
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case .purchased:
                print("Transaction Approved. \(transaction.payment.productIdentifier)")
                
                receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
                
            case .restored:
                print("이미 보유하고 계신 상품입니다")
                makeToast("이미 보유하고 계신 상품입니다", duration: 1.0, position: .center) { didTap in
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
                return
                
            case .failed:
                makeToast("상품구매에 실패했습니다", duration: 1.0, position: .center) { didTap in
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
                return
                
            default:
                return
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("removedTransactions")
    }
}

// MARK: - My Info API
extension ShopView {
    
    func checkShopMyInfo() {
        let api = ShopAPIRouter.myinfo
        Network.share.requestShopMyInfo(router: api) {  [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status =  GeneralError(rawValue: statusCode) else { return }
            print("checkShopMyInfo///⭐️value : \(value), ⭐️statusCode: \(statusCode)")
            
            switch status {
            case .success:
                self?.setShopMyInfoData(value: value)
                return
                
            case .fbTokenError:
                self?.refreshIDTokenShopMyInfo()
                return
                
            default:
                self?.makeToast(status.errorDescription, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenShopMyInfo() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default:
                    self.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
                }
                return
                
            } else if let idToken = idToken {
                UserDefaultsManager.idtoken = idToken
                
                let api = ShopAPIRouter.myinfo
                Network.share.requestShopMyInfo(router: api) {  [weak self] (value, statusCode, error) in
                    
                    guard let value = value else { return }
                    guard let statusCode = statusCode else { return }
                    guard let status =  GeneralError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        self?.setShopMyInfoData(value: value)
                        return
                        
                    default :
                        self?.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
    
    // shop/myinfo API 통신결과 기반으로 화면 update
    func setShopMyInfoData(value: LoginResponse) {
        selectedBG = value.background
        selectedFC = value.sesac
        
        vc1.mainView.sesacCollection = value.sesacCollection
        vc2.mainView.backgroundCollection = value.backgroundCollection
        
        tableView.reloadData()
        vc1.mainView.collectionView.reloadData()
        vc2.mainView.collectionView.reloadData()
    }
}

// MARK: - shop item API
extension ShopView {
    
    func requestShopItem() {
        let api = ShopAPIRouter.shopitem(sesac: String(selectedFC), background: String(selectedBG))
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status = ShopItemError(rawValue: statusCode) else { return }
            print("requestShopItem///⭐️value : \(value), ⭐️statusCode: \(statusCode)")
            
            switch status {
            case .fbTokenError:
                self?.refreshIDTokenShopItem()
                return
                
            default:
                self?.makeToast(status.shopItemErrorDescription, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenShopItem() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default:
                    self.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
                }
                return
                
            } else if let idToken = idToken {
                UserDefaultsManager.idtoken = idToken
                
                let api = ShopAPIRouter.shopitem(sesac: String(self.selectedFC), background: String(self.selectedBG))
                Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let value = value else { return }
                    guard let statusCode = statusCode else { return }
                    guard let status =  ShopItemError(rawValue: statusCode) else { return }
                    print("⭐️value : \(value), ⭐️statusCode: \(statusCode)")
                    
                    switch status {
                    case .success:
                        self?.makeToast(status.shopItemErrorDescription, duration: 1.0, position: .center)
                        return
                        
                    default :
                        self?.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
    
    
}

// MARK: - ios API
extension ShopView {
    
    func requestIos(receipt: String, IAPBundle: String) {
        let api = ShopAPIRouter.ios(receipt: receipt, product: IAPBundle)
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let statusCode = statusCode else { return }
            guard let status = ShopIosError(rawValue: statusCode) else { return }
            print("requestIos///⭐️status : \(status), ⭐️statusCode: \(statusCode)")
            
            switch status {
            case .success:
                print("⭐️영수증 검증 성공⭐️")
                self?.checkShopMyInfo()
                return
                
            case .fbTokenError:
                self?.refreshIDTokenIos(receipt: receipt, product: IAPBundle)
                return
                
            default:
                self?.makeToast(status.errorDescription, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenIos(receipt: String, product: String) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default:
                    self.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
                }
                return
                
            } else if let idToken = idToken {
                UserDefaultsManager.idtoken = idToken
                
                let api = ShopAPIRouter.ios(receipt: receipt, product: product)
                Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let statusCode = statusCode else { return }
                    guard let status = ShopIosError(rawValue: statusCode) else { return }
                    print("requestIos///⭐️status : \(status), ⭐️statusCode: \(statusCode)")
                    
                    switch status {
                    case .success:
                        self?.checkShopMyInfo()
                        return
                        
                    default:
                        self?.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
    
}
