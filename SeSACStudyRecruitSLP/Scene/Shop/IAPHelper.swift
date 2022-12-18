//
//  IAPHelper.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/15/22.
//

//import Foundation
//import StoreKit
//
//public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void
//
//class IAPHelper: NSObject {
//
//    private let productIdentifiers: Set<String> //[String]
//    private var productsRequest: SKProductsRequest?
//    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
//
//    public init(productIds: Set<String>) { //}[String]) {
//        productIdentifiers = productIds
//        super.init()
//        SKPaymentQueue.default().add(self) // App Store와 지불정보를 동기화하기 위한 Observer
//    }
//
//    // App Store Connect에서 등록한 인앱결제 상품들을 가져올 때
//    // 함수 requestProducts
//    public func requestProductData(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
//        productsRequest?.cancel()
//        productsRequestCompletionHandler = completionHandler
//
//        if SKPaymentQueue.canMakePayments() {
//            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
//            request.delegate = self
//            request.start()
//        } else {
//            print("해당 상품은 인앱 결제가 불가능합니다.")
//        }
//    }
//
//    // 인앱결제 상품을 구입할 때
//    public func buyProduct(_ product: SKProduct) {
//        let payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
//    }
//
//    // 구입 내역을 복원할 때
//    public func restorePurchases() {
//        SKPaymentQueue.default().restoreCompletedTransactions()
//    }
//}
//
//extension IAPHelper: SKProductsRequestDelegate {
//
//    // 인앱결제 상품 리스트를 가져온다
//    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        let products = response.products
//        productsRequestCompletionHandler?(true, products)
//        clearRequestAndHandler()
//    }
//
//    // 상품 리스트 가져오기 실패할 경우
//    public func request(_ request: SKRequest, didFailWithError error: Error) {
//        productsRequestCompletionHandler?(false, nil)
//        clearRequestAndHandler()
//    }
//
//    private func clearRequestAndHandler() {
//        productsRequest = nil
//        productsRequestCompletionHandler = nil
//    }
//}
//
//extension IAPHelper: SKPaymentTransactionObserver {
//
//    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            switch (transaction.transactionState) {
//            case .purchased:
//                complete(transaction: transaction)
//                break
//            case .failed:
//                fail(transaction: transaction)
//                break
//            case .restored:
//                restore(transaction: transaction)
//                break
//            case .deferred, .purchasing:
//                break
//            @unknown default:
//                fatalError()
//            }
//        }
//    }
//
//    // 구입 성공
//    private func complete(transaction: SKPaymentTransaction) {
////        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
//        SKPaymentQueue.default().finishTransaction(transaction)
//    }
//
//    // 복원 성공
//    private func restore(transaction: SKPaymentTransaction) {
//        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
////        deliverPurchaseNotificationFor(identifier: productIdentifier)
//        SKPaymentQueue.default().finishTransaction(transaction)
//    }
//
//    // 구매 실패
//    private func fail(transaction: SKPaymentTransaction) {
//        if let transactionError = transaction.error as NSError?,
//           let localizedDescription = transaction.error?.localizedDescription,
//           transactionError.code != SKError.paymentCancelled.rawValue {
//            print("Transaction Error: \(localizedDescription)")
//        }
//        SKPaymentQueue.default().finishTransaction(transaction)
//    }
//
//    // 구매한 인앱 상품 키를 UserDefaults로 로컬에 저장 => 여기서는 저장하지 말고, 서버로 보내서 업데이트? 해야할듯 (아니면 영수증을 보내던가)
//    //    private func deliverPurchaseNotificationFor(identifier: String?) {
//    //        guard let identifier = identifier else { return }
//    //
//    //        let dict: ProductInfo = [IAPProductKey.purchased: true,
//    //                                 IAPProductKey.validated: false]
//    //        UserDefaults.standard.setValue(dict, forKey: identifier)
//    //
//    //        requestValidation(productId: identifier)
//    //    }
//
//}
//
//// 영수증 처리
//extension IAPHelper {
//
//    // 구매이력 영수증 가져오기 - 검증용
//    // but!!! 우리는 자체 서버가 있으니까, 여기서 자체 서버로 암호화된 영수증 string을 보내서 검증하자!!
//    public func getReceiptData() -> String? {
//        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
//           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
//            do {
//                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
//                let receiptString = receiptData.base64EncodedString(options: [])
//                return receiptString
//            }
//            catch {
//                print("Couldn't read receipt data with error: " + error.localizedDescription)
//                return nil
//            }
//        }
//    }
//}

//class IAPHelper: NSObject {
//
//    private let productIdentifiers: Set<String> //[String]
//    private var productsRequest: SKProductsRequest?
//    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
//
//    public init(productIds: Set<String>) { //}[String]) {
//        productIdentifiers = productIds
//        super.init()
//        SKPaymentQueue.default().add(self) // App Store와 지불정보를 동기화하기 위한 Observer
//    }
//
//    // App Store Connect에서 등록한 인앱결제 상품들을 가져올 때
//    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
//        productsRequest?.cancel()
//        productsRequestCompletionHandler = completionHandler
//        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
//        productsRequest!.delegate = self // 추후 delegate 추가
//        productsRequest!.start()
//    }
//
//    // 인앱결제 상품을 구입할 때
//    public func buyProduct(_ product: SKProduct) {
//        let payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
//    }
//
//    // 구입 내역을 복원할 때
//    public func restorePurchases() {
//        SKPaymentQueue.default().restoreCompletedTransactions()
//    }
//}
//
//extension IAPHelper: SKProductsRequestDelegate {
//
//    // 인앱결제 상품 리스트를 가져온다
//    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        let products = response.products
//        productsRequestCompletionHandler?(true, products)
//        clearRequestAndHandler()
//    }
//
//    // 상품 리스트 가져오기 실패할 경우
//    public func request(_ request: SKRequest, didFailWithError error: Error) {
//        productsRequestCompletionHandler?(false, nil)
//        clearRequestAndHandler()
//    }
//
//    private func clearRequestAndHandler() {
//        productsRequest = nil
//        productsRequestCompletionHandler = nil
//    }
//}
//
//extension IAPHelper: SKPaymentTransactionObserver {
//
//    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            switch (transaction.transactionState) {
//            case .purchased:
//                complete(transaction: transaction)
//                break
//            case .failed:
//                fail(transaction: transaction)
//                break
//            case .restored:
//                restore(transaction: transaction)
//                break
//            case .deferred, .purchasing:
//                break
//            @unknown default:
//                fatalError()
//            }
//        }
//    }
//
//    // 구입 성공
//    private func complete(transaction: SKPaymentTransaction) {
//        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
//        SKPaymentQueue.default().finishTransaction(transaction)
//    }
//
//    // 복원 성공
//    private func restore(transaction: SKPaymentTransaction) {
//        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
//        deliverPurchaseNotificationFor(identifier: productIdentifier)
//        SKPaymentQueue.default().finishTransaction(transaction)
//    }
//
//    // 구매 실패
//    private func fail(transaction: SKPaymentTransaction) {
//        if let transactionError = transaction.error as NSError?,
//           let localizedDescription = transaction.error?.localizedDescription,
//           transactionError.code != SKError.paymentCancelled.rawValue {
//            print("Transaction Error: \(localizedDescription)")
//        }
//        SKPaymentQueue.default().finishTransaction(transaction)
//    }
//
//    // 구매한 인앱 상품 키를 UserDefaults로 로컬에 저장 => 여기서는 저장하지 말고, 서버로 보내서 업데이트? 해야할듯 (아니면 영수증을 보내던가)
////    private func deliverPurchaseNotificationFor(identifier: String?) {
////        guard let identifier = identifier else { return }
////
////        let dict: ProductInfo = [IAPProductKey.purchased: true,
////                                 IAPProductKey.validated: false]
////        UserDefaults.standard.setValue(dict, forKey: identifier)
////
////        requestValidation(productId: identifier)
////    }
//
//}
//
//// 영수증 처리
//extension IAPHelper {
//
//    // 구매이력 영수증 가져오기 - 검증용
//    // but!!! 우리는 자체 서버가 있으니까, 여기서 자체 서버로 암호화된 영수증 string을 보내서 검증하자!!
//    public func getReceiptData() -> String? {
//        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
//           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
//            do {
//                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
//                let receiptString = receiptData.base64EncodedString(options: [])
//                return receiptString
//            }
//            catch {
//                print("Couldn't read receipt data with error: " + error.localizedDescription)
//                return nil
//            }
//        }
//    }
//}



