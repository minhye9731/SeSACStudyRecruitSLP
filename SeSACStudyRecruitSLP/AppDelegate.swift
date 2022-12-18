//
//  AppDelegate.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/7/22.
//

import UIKit

import FirebaseCore
import FirebaseMessaging
import FirebaseAuth
import IQKeyboardManagerSwift
import UserNotifications
//import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase 초기화 세팅
        FirebaseApp.configure()
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        // FCM 다시 사용 설정
        Messaging.messaging().isAccessibilityElement = true
        
        // 푸시 알림 권한 설정 및 푸시 알림에 앱 등록
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        application.registerForRemoteNotifications()
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "sesacBack")?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -12.0, bottom: 0.0, right: 0.0))
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "sesacBack")
        UINavigationBar.appearance().tintColor = .black
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        return true
    }
    
    /// 1. APN 토큰과 등록 토큰 매핑
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 2. foreground 상태에서도 알림 발송되도록 하는 함수
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 현위치 확인
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.navigationController?.topViewController else { return }
        print("👀현위치 확인 //// \(viewController)")
        
        if viewController is ChattingViewController {
            completionHandler([])
        } else {
            completionHandler([.badge, .sound, .banner, .list])
        }
    }
    
    
    /// 4.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
        
        let userInfo = response.notification.request.content.userInfo
        print("푸시알림 클릭함!! userInfo = \(userInfo)")
        
        let studyRequest = userInfo["studyRequest"] as? String ?? ""
        let studyAccepted = userInfo["studyAccepted"] as? String ?? ""
        
        let matched = userInfo["matched"] as? Int ?? 0
        let body = userInfo["body"] as? String ?? ""

        print("🧢 사용자가 '\(studyRequest)'푸시를 클릭했습니다.")
        print("🧢 사용자가 '\(studyAccepted)'푸시를 클릭했습니다.")
        print("🧢 사용자가 '\(matched)'푸시를 클릭했습니다.")
        
        // 현위치 확인
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.navigationController?.topViewController else { return }
        print("⛑ 현위치 확인 //// \(viewController)")
        
        
        if !studyRequest.isEmpty { // 스터디 요청 푸시
            
            if viewController is SearchResultViewController {
                print("받은 요청 탭으로 이동")
            } else if viewController is PopUpViewController {
                viewController.dismiss(animated: true) {
                    print("받은 요청 탭으로 이동")
                }
            } else { // 매칭상태로 추가구분 필요
                moveToHomeVC()
            }
  
        } else if !studyAccepted.isEmpty { // 스터디 수락 푸시
            
            if !(viewController is SearchResultViewController) { // 현화면이 [새싹찾기]가 아닐 경우,
                self.checkMyQueue()
            }

//        } else if !dodge.isEmpty { // 스터디 취소 푸시
            // 액션 없음
        } else if !body.isEmpty { // 채팅 푸시
            
            if matched == 1 {
                // 채팅화면으로 이동
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                guard let delegate = sceneDelegate else { return }
                        
                let vc = TabBarController()
                delegate.window?.rootViewController = vc
//                vc.pageboyParent = 1
                
            } else {
                // 홈화면으로 이동
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                guard let delegate = sceneDelegate else { return }
                delegate.window?.rootViewController = TabBarController()
            }
            
        }
        
    }
    
    func checkMyQueue() {
        let api = QueueAPIRouter.myQueueState
        Network.share.requestMyQueueState(router: api) { [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status = MyQueueStateError(rawValue: statusCode) else { return }
            print("⭐️value : \(value), ⭐️statusCode: \(statusCode)")
            
            switch status {
            case .success: // 매칭 대기중, 매칭됨 (0, 1)
                if value.matched == 1 {
                    // [채팅 화면]으로 이동
                } else {
                    self?.moveToHomeVC()
                }
                return
                
            case .normalStatus: // 일반상태 (nil)
                self?.moveToHomeVC()
                return
                
            case .fbTokenError:
                self?.refreshIDTokenQueue()
                return
                
            default:
                return // 상세처리
            }
        }
    }
    
    func moveToHomeVC() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else { return }
        delegate.window?.rootViewController = TabBarController()
    }
    
    func refreshIDTokenQueue() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default:
                    break // 상세처리
                }
                return
            } else if let idToken = idToken {
                UserDefaultsManager.idtoken = idToken
                
                let api = QueueAPIRouter.myQueueState
                Network.share.requestMyQueueState(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let value = value else { return }
                    guard let statusCode = statusCode else { return }
                    guard let status =  MyQueueStateError(rawValue: statusCode) else { return }

                    switch status {
                    case .success:
                        if value.matched == 1 {
                            // [채팅 화면]으로 이동
                        } else {
                            self?.moveToHomeVC()
                        }
                        return
                        
                    case .normalStatus:
                        self?.moveToHomeVC()
                        return
                        
                    default:
                        break // 상세처리
                    }
                }
            }
        }
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("🐥Firebase registration token: \(String(describing: fcmToken))")
        UserDefaultsManager.fcmTokenSU = fcmToken!
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
    
}




