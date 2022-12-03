//
//  SearchResultViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit
import Tabman
import Pageboy
import FirebaseAuth

final class SearchResultViewController: TabmanViewController {
    
    // MARK: - property
    var viewControllers: Array<UIViewController> = []
    let listVC = ListViewController()
    var timer: Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "새싹 찾기"
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setBarButtonItem()
        setVC()
    }
    
    // myQueueState 5초마다 확인 타이머
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { Timer in
            self.myQueueState()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    // MARK: - functions
    func setVC() {
        viewControllers.append(listVC)
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        settingTabBar(ctBar: bar)
        addBar(bar, dataSource: self, at: .top)
    }
    
    func settingTabBar (ctBar : TMBar.ButtonBar) {
        ctBar.backgroundView.style = .clear
        ctBar.backgroundColor = .white

        ctBar.layout.transitionStyle = .snap
        ctBar.layout.alignment = .centerDistributed
        ctBar.layout.contentMode = .fit
        ctBar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

        ctBar.buttons.customize { (button) in
            button.tintColor = ColorPalette.gray6
            button.selectedTintColor = ColorPalette.green
            button.font = CustomFonts.title4_R14()
            button.selectedFont = CustomFonts.title3_M14()
        }

        ctBar.indicator.weight = .custom(value: 2)
        ctBar.indicator.tintColor = ColorPalette.green
        ctBar.indicator.overscrollBehavior = .compress
    }
}

extension SearchResultViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0: return TMBarItem(title: "주변 새싹")
        case 1: return TMBarItem(title: "받은 요청")
        default: return TMBarItem(title: " ")
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return 2
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return ListViewController()
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .first
    }
}

// MARK: - 기타
extension SearchResultViewController {
    
    func setBarButtonItem() {
        let navibarAppearance = UINavigationBarAppearance()
        let barbuttonItemAppearance = UIBarButtonItemAppearance()
        barbuttonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black, .font: CustomFonts.title3_M14()]
        navibarAppearance.buttonAppearance = barbuttonItemAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.ImageName.back.rawValue), style: .plain, target: self, action: #selector(backtwice))
    }
    
    @objc func backtwice() {
        backTwoPop()
    }
}

// MARK: - delete queue (API)
extension SearchResultViewController {
    
    // [찾기중단]
    @objc func stopTapped() {
        let api = QueueAPIRouter.delete
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status = QueueDeleteError(rawValue: statusCode) else { return }
            
            switch status {
            case .success:
                print("👽찾기중단 성공@@")
                self?.backTwoPop()
                return
            case .alreayMatched:
                self?.view.makeToast("누군가와 스터디를 함께하기로 약속하셨어요!", duration: 1.0, position: .center) { didTap in
                    self?.myQueueState()
                }
                return
            case .fbTokenError:
                self?.refreshIDTokenDelete()
                return
            default:
                self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenDelete() {
        
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
                
                let api = QueueAPIRouter.delete
                Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let value = value else { return }
                    guard let statusCode = statusCode else { return }
                    guard let status = QueueDeleteError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        print("👽찾기중단 성공@@")
                        self?.backTwoPop()
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

// MARK: - myQueueState (API)
extension SearchResultViewController {
    
    func myQueueState() {
        let api = QueueAPIRouter.myQueueState
        Network.share.requestMyQueueState(router: api) { [weak self] (value, statusCode, error) in

            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status =  MyQueueStateError(rawValue: statusCode) else { return }

            print("⭐️value : \(value), ⭐️statusCode: \(statusCode)")
            
            switch status {
            case .success:
                
                if value.matched  == 1 {
                    self?.view.makeToast("\(value.matchedNick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다.", duration: 1.0, position: .center) { didTap in
                        let vc = ChattingViewController()
                        vc.otherSesacUID = value.matchedUid
                        vc.otherSesacNick = value.matchedNick
                        self?.transition(vc, transitionStyle: .push)
                    }
                }
                return
                     
            case .fbTokenError:
                self?.refreshIDTokenQueue()
                return
            default :
                self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenQueue() {
        
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
                
                let api = QueueAPIRouter.myQueueState
                Network.share.requestMyQueueState(router: api) { [weak self] (value, statusCode, error) in

                    guard let value = value else { return }
                    guard let statusCode = statusCode else { return }
                    guard let status =  MyQueueStateError(rawValue: statusCode) else { return }

                    print("⭐️value : \(value), ⭐️statusCode: \(statusCode)")
                    
                    switch status {
                    case .success:
                        
                        if value.matched  == 1 {
                            self?.view.makeToast("\(value.matchedNick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다.", duration: 1.0, position: .center) { didTap in
                                let vc = ChattingViewController()
                                vc.otherSesacUID = value.matchedUid
                                vc.otherSesacNick = value.matchedNick
                                self?.transition(vc, transitionStyle: .push)
                            }
                        }
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

// MARK: - 기타
extension SearchResultViewController {
    
    func backTwoPop() {
        self.navigationController?.popViewControllers(2)
    }
    
}





