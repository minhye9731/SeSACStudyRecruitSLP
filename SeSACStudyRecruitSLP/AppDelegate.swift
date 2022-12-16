//
//  AppDelegate.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/7/22.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import IQKeyboardManagerSwift

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
    
    /// APN 토큰과 등록 토큰 매핑
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
    
    // foreground 상태에서도 알림 발송되도록 하는 함수
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 현위치 확인
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.navigationController?.topViewController else { return }
        
        if viewController is ChattingViewController {
            completionHandler([])
        } else {
            completionHandler([.badge, .sound, .banner, .list])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("사용자가 푸시를 클릭했습니다.")
        print(response.notification.request.content.body)
        
        let userInfo = response.notification.request.content.userInfo
        let application = UIApplication.shared
        print(userInfo)
        
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            print("사용자가 시스템 푸시를 탭했습니다~!")
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




