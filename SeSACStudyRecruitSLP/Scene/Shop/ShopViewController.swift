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
//    let inAppPurchaseHelper = IAPHelper()
    
    // [인앱상품]
    // 인앱 상품 ID 정의
    var productIdentifiers: Set<String> = []
    // 인앱 상품 정보
    var productArray = Array<SKProduct>()
    // 인앱 상품 조회. 선택하거나 한 거를 특정해야 할 때 사용
    var product: SKProduct?

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
        
        setSegmentedControl()
        setPriceButtonAction()
        
        // tableview header
        mainView.shopSaveButtonActionHandler = {
            self.requestShopItem()
        }
        
//        requestProductData()
    }
    
    func setSegmentedControl() {
        mainView.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        mainView.segmentedControl.selectedSegmentIndex = 0
        self.changeValue(control: mainView.segmentedControl)
    }
    
    @objc private func changeValue(control: UISegmentedControl) {
        mainView.currentPage = control.selectedSegmentIndex

        if mainView.currentPage == 0 {
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


// MARK: - 기타 함수
extension ShopViewController {
    
    // price 버튼
    func setPriceButtonAction() {
        mainView.vc1.mainView.ssPriceButtonActionHandler = {
            print("ssPriceButtonActionHandler 클릭됨 || 인앱결제 실행 지점")
            
            let payment = SKPayment(product: self.product!)
            SKPaymentQueue.default().add(payment)
            SKPaymentQueue.default().add(self)
            
        }
        
        mainView.vc2.mainView.bgPriceButtonActionHandler = {
            print("bgPriceButtonActionHandler 클릭됨 || 인앱결제 실행 지점")
            
            // productArray 에서 순서대로 꺼내야 하나
            let payment = SKPayment(product: self.product!)
            SKPaymentQueue.default().add(payment)
            SKPaymentQueue.default().add(self)
        }
    }
    
    //  2. productIdentifiers에 정의된 상품ID에 대한 정보 가져오기 및 사용자의 디바이스가 인앱결제가 가능한지 여부 확인
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            
            // productIdentifiers에 url들을 sprout, bg 구분해서 담기도록 해야하나 전체?
            print("😎인앱 결제 가능😎")
            let request = SKProductsRequest(productIdentifiers: productIdentifiers) // productIdentifiers에 사용자가 클릭한 상품의 정보가 나오도록 해야하나
            request.delegate = self
            request.start()  //인앱 상품 조회
        } else {
            self.view.makeToast("해당 상품은 인앱 결제가 불가능합니다.", duration: 1.0, position: .center)
        }
    }
    
    // 신규추가함
//    private func initIAP() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleIAPPurchase(_:)), name: NSNotification.Name("IAPHelperPurchaseNotification"), object: nil)
//
//        // IAP 불러오기
//        InAppProducts.store.requestProductData { [weak self] success, products in
//            guard let self = self, success else { return }
//
////            if mainView.currentPage == 0 {
////                InAppProducts.productArray = products!
////            }
//
////            InAppProducts.init(product: products)
//            // ...
//        }
//    }
    
    // 추가
    // 결제 후 Notification을 받아 처리 (수업시간에 한거는 observer. observer가 더 나은듯)
//    @objc func handleIAPPurchase(_ notification: Notification) {
//        guard let success = notification.object as? Bool else { return }
//
//        if success {
//            DispatchQueue.main.async {
//                let vc = UIAlertController(title: "알림", message: "구매성공", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "확인", style: .default) { _ in
//
//                    print("구매성공~ 아마 나는 info 서버 재호출해서 ui update 해야할듯")
//
//                }
//
//                vc.addAction(ok)
//                self.present(vc, animated: true, completion: nil)
//            }
//        } else {
//            DispatchQueue.main.async {
//                let vc = UIAlertController(title: "알림", message: "구매에 실패했습니다.", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
//                vc.addAction(ok)
//                self.present(vc, animated: true, completion: nil)
//            }
//        }
//    }
    
    
}

// MARK: - 인앱상품 조회
extension ShopViewController: SKProductsRequestDelegate {
    
    // 3. 인앱 상품 정보 조회 응답 메서드
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(#function)
        let products = response.products // 각 vc1, vc2가 viewWillAppear 할 때 상품조회를 매번 해야만, sprout와 background를 구분해서 받을 수 있을 것으로 보인다
        print("상품조회한 정보들 : \(products)")
        
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
        mainView.selectedBG = value.background
        mainView.selectedFC = value.sesac
        
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
        let api = ShopAPIRouter.shopitem(sesac: String(mainView.selectedFC), background: String(mainView.selectedBG))
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
                
                let api = ShopAPIRouter.shopitem(sesac: String(self.mainView.selectedFC), background: String(self.mainView.selectedBG))
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
