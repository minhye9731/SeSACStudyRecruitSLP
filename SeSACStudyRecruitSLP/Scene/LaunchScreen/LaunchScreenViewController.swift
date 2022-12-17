//
//  LaunchScreenViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/17/22.
//

import UIKit
import FirebaseAuth

final class LaunchScreenViewController: BaseViewController {
    
    // MARK: - property
    let mainView = LaunchScreenView()
    
    // MARK: - Lifecycle
    override func loadView()  {
        self.view = mainView
    }
    
    deinit {
        print("🎬🎬🎬LaunchScreenViewController deinit🎬🎬🎬")
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.startByState()
        }
    }

    func startByState() {
        
        typealias FirstLaunch = Bool
        let isFirstLaunched: FirstLaunch = UserDefaultsManager.firstRun
        let isEmptyToken: FirstLaunch = UserDefaultsManager.idtoken.isEmpty
        
        if isFirstLaunched { // 최초사용자일 경우
            print(UserDefaultsManager.firstRun)
            changeRootVC(vc: OnBoardingViewController())
            return
            
        } else if isEmptyToken { // 토큰 존재여부
            changeRootNavVC(vc: PhoneNumberViewController()) // 토큰 empty면 번호인증
            return
            
        } else { // 토큰 있으면 해당정보로 로그인 시도
            
            let api = APIRouter.login
            Network.share.requestUserLogin(router: api) { [weak self] (value, statusCode, error) in
                
                guard let value = value else { return }
                guard let statusCode = statusCode else { return }
                guard let status = LoginError(rawValue: statusCode) else { return }
                
                switch status {
                case .success:
                    // fcm 코드비교 및 업데이트
                    if value.fcMtoken == UserDefaultsManager.fcmTokenSU {
                        self?.changeRootVC(vc: TabBarController())
                        return
                    } else {
                        self?.requestFCMUpdate(fcm: UserDefaultsManager.fcmTokenSU)
                        return
                    }
                    
                case .fbTokenError:
                    self?.refreshIDToken()
                    return
                    
                case .unknownUser:
                    self?.changeRootNavVC(vc: NickNameViewController())
                    return
                    
                default:
                    let alert = UIAlertController(title: "네트워크 에러로 인해 앱을 종료합니다.", message: nil, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default) {_ in
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            exit(0)
                        }
                    }
                    alert.addAction(ok)
                    self?.present(alert, animated: true)
                    return
                }
            }
        }
    }
    
    func refreshIDToken() {
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
                UserDefaults.standard.set(idToken, forKey: "idtoken")

                let api = APIRouter.login
                Network.share.requestUserLogin(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let statusCode = statusCode else { return }
                    guard let status = LoginError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        self?.changeRootVC(vc: TabBarController())
                        return

                    case .unknownUser:
                        self?.changeRootNavVC(vc: NickNameViewController())
                        return
                        
                    default:
                        let alert = UIAlertController(title: "네트워크 에러로 인해 앱을 종료합니다.", message: nil, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "확인", style: .default) {_ in
                            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                exit(0)
                            }
                        }
                        alert.addAction(ok)
                        self?.present(alert, animated: true)
                        return
                    }
                }
            }
        }
    }
    
    func requestFCMUpdate(fcm: String) {
        let api = APIRouter.fcmUpdate(fcmToken: fcm)
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let statusCode = statusCode else { return }
            guard let status = GeneralError(rawValue: statusCode) else { return }
            
            switch status {
            case .success:
                self?.changeRootVC(vc: TabBarController())
                return
                
            case .fbTokenError:
                self?.refreshIDTokenFCMToken(fcmToken: fcm)
                return
                
            default:
                self?.view.makeToast(status.errorDescription, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenFCMToken(fcmToken: String) {
        
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
                UserDefaults.standard.set(idToken, forKey: "idtoken")
                
                let api = APIRouter.fcmUpdate(fcmToken: fcmToken)
                Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let statusCode = statusCode else { return }
                    guard let status = GeneralError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        self?.changeRootVC(vc: TabBarController())
                        return
                        
                    default:
                        self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }

}
