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
    
    // [인앱상품]
    // 인앱 상품 ID 정의
    var productIdentifiers: Set<String> = ["com.memolease.sesac1.sprout1"]
    // 인앱 상품 정보
    var productArray = Array<SKProduct>()
    // 인앱 상품 조회. 선택하거나 한 거를 특정해야 할 때 사용
    var product: SKProduct?

    var selectedBG = 0
    var selectedFC = 0
    
    // MARK: - Lifecycle
    override func loadView()  {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkShopMyInfo()
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        self.title = "새싹샵"
        
        mainView.pageViewController.delegate = self
        
        setSegmentedControl()
        setDelegate()
        setPriceButtonAction()
    }
    
    func setSegmentedControl() {
        mainView.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        mainView.segmentedControl.selectedSegmentIndex = 0
        self.changeValue(control: mainView.segmentedControl)
    }
    
    func setDelegate() {
        mainView.tableView.delegate = self
        mainView.vc1.mainView.collectionView.delegate = self
        mainView.vc2.mainView.collectionView.delegate = self
    }

    @objc private func changeValue(control: UISegmentedControl) {
        mainView.currentPage = control.selectedSegmentIndex
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
        headerView.backgroundImage.image = UIImage(named: "sesac_background_\(selectedBG + 1)")
        headerView.sesacImage.image = UIImage(named: "sesac_face_\(selectedFC + 1)")
        
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

extension ShopViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0],
              let index = mainView.dataViewControllers.firstIndex(of: viewController)
        else { return }
        mainView.currentPage = index
        mainView.segmentedControl.selectedSegmentIndex = index
    }
}

// MARK: - 기타 함수
extension ShopViewController {
    
    // [저장하기] 버튼
    @objc func askAcceptbtnTapped(sender: HeaderSectionPassButton) {
        self.requestShopItem()
    }
    
    // price 버튼
    func setPriceButtonAction() {
        mainView.vc1.mainView.ssPriceButtonActionHandler = {
            print("ssPriceButtonActionHandler 클릭됨 || 인앱결제 실행 지점")
            // requestProductData() {
        }
        
        mainView.vc2.mainView.bgPriceButtonActionHandler = {
            print("bgPriceButtonActionHandler 클릭됨 || 인앱결제 실행 지점")
            // requestProductData() {
        }
    }
    
    //  2. productIdentifiers에 정의된 상품ID에 대한 정보 가져오기 및 사용자의 디바이스가 인앱결제가 가능한지 여부 확인
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            print("😎인앱 결제 가능😎")
            let request = SKProductsRequest(productIdentifiers: productIdentifiers) // productIdentifiers에 사용자가 클릭한 상품의 정보가 나오도록 해야하나
            request.delegate = self
            request.start()  //인앱 상품 조회
        } else {
            self.view.makeToast("해당 상품은 인앱 결제가 불가능합니다.", duration: 1.0, position: .center)
        }
    }
    
}

// MARK: - 인앱상품 조회
extension ShopViewController: SKProductsRequestDelegate {
    
    // 3. 인앱 상품 정보 조회 응답 메서드
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let products = response.products
        
        if products.count > 0 {
            for i in products {
                productArray.append(i)
                product = i //옵션. 테이블뷰 셀에서 구매하기 버튼 클릭 시, 버튼 클릭 시????
                
                print(i.localizedTitle, i.price, i.priceLocale, i.localizedDescription)
            }
        } else {
            self.view.makeToast("해당 상품 조회에 실패했습니다.", duration: 1.0, position: .center)
        }
    }
    
    // 영수증 검증 => 여기서 서버를 통해 검증해야함
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        // SandBox: “https://sandbox.itunes.apple.com/verifyReceipt”
        // iTunes Store : “https://buy.itunes.apple.com/verifyReceipt”
        
        //구매 영수증 정보
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(receiptString)
        
        //거래 내역(transaction)을 큐에서 제거
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

// MARK: - 인앱결제 구매 Observer
extension ShopViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased: //구매 승인 이후에 영수증 검증
                
                print("Transaction Approved. \(transaction.payment.productIdentifier)")
                
                // 영수증 검증! (우리는 여기서 서버를 통해 검증해야함)
                receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
                
            case .failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                
                
            default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("removedTransactions")
    }
    
    
}

// MARK: - vc1, vc2내 collectionview cell 클릭시 액션
extension ShopViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == mainView.vc1.mainView.collectionView {
            self.selectedFC = indexPath.row
        } else {
            self.selectedBG = indexPath.row
        }
        mainView.tableView.reloadData()
    }
}

// MARK: - checkShopMyInfo API
extension ShopViewController {
    
    func checkShopMyInfo() {
        let api = ShopAPIRouter.myinfo
        Network.share.requestShopMyInfo(router: api) {  [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status =  GeneralError(rawValue: statusCode) else { return }
            print("⭐️value : \(value), ⭐️statusCode: \(statusCode)")
            
            switch status {
            case .success:
                self?.setShopMyInfoData(value: value)
                return
                
            case .fbTokenError:
                self?.refreshIDTokenShopMyInfo()
                return
                
            default:
                self?.view.makeToast(status.errorDescription, duration: 1.0, position: .center)
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
                    self.view.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
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
                        self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
    
    func setShopMyInfoData(value: LoginResponse) {
        selectedBG = value.background
        selectedFC = value.sesac
        
        mainView.vc1.mainView.sesacCollection = value.sesacCollection
        mainView.vc2.mainView.backgroundCollection = value.backgroundCollection
        
        mainView.tableView.reloadData()
        mainView.vc1.mainView.collectionView.reloadData()
        mainView.vc2.mainView.collectionView.reloadData()
    }
}

// MARK: - shop item API
extension ShopViewController {
    
    func requestShopItem() {
        let api = ShopAPIRouter.shopitem(sesac: String(selectedFC), background: String(selectedBG))
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status = ShopItemError(rawValue: statusCode) else { return }
            print("⭐️value : \(value), ⭐️statusCode: \(statusCode)")
            
            switch status {
            case .fbTokenError:
                self?.refreshIDTokenShopItem()
                return
                
            default:
                self?.view.makeToast(status.shopItemErrorDescription, duration: 1.0, position: .center)
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
                    self.view.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
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
                        self?.view.makeToast(status.shopItemErrorDescription, duration: 1.0, position: .center)
                        return
                        
                    default :
                        self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
    
}
