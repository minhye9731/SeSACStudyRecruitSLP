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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "새싹 찾기"
        view.backgroundColor = .white
        setBarButtonItem()
        setVC()
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


// MARK: - 찾기 중단 메서드
extension SearchResultViewController {
    func setBarButtonItem() {
        let navibarAppearance = UINavigationBarAppearance()
        let barbuttonItemAppearance = UIBarButtonItemAppearance()
        barbuttonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black, .font: CustomFonts.title3_M14()]
        navibarAppearance.buttonAppearance = barbuttonItemAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopTapped))
    }
    
    @objc func stopTapped() {
        print("찾기 중단 클릭됨!! :)")
        
        let api = APIRouter.delete
        
        Network.share.requestForResponseString(router: api) { [weak self] response in
            switch response {
            case .success(let _):
                let viewControllers: [UIViewController] = self?.navigationController!.viewControllers as [UIViewController]
                // 사용자의 현재상태는 '일반 상태'로 설정 (user defaults??)
                // 타이머 등 새싹 찾기 화면에서 진행중인 로직을 정리
                self?.navigationController?.popToViewController(viewControllers[viewControllers.count - 2], animated: true) // 홈화면으로 돌아가기
                return
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = SignupError(rawValue: code) else { return }
                switch errorCode {
                case .existUser:
                    self?.view.makeToast("누군가와 스터디를 함께하기로 약속하셨어요!", duration: 1.0, position: .center)
                    self?.myQueueState()
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
                
                let api = APIRouter.delete
                Network.share.requestForResponseString(router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let stateData):
                        let viewControllers: [UIViewController] = self?.navigationController!.viewControllers as [UIViewController]
                        // 사용자의 현재상태는 '일반 상태'로 설정 (user defaults??)
                        // 타이머 등 새싹 찾기 화면에서 진행중인 로직을 정리
                        self?.navigationController?.popToViewController(viewControllers[viewControllers.count - 2], animated: true) // 홈화면으로 돌아가기
                        return
                        
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = LoginError(rawValue: code) else { return }
                        switch errorCode {
                        default:
                            self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        }
                    }
                }
            }
        }
        
        
        
        
    }
    
}

// MARK: - myQueueState
extension SearchResultViewController {
    
    func myQueueState() {
        let api = APIRouter.myQueueState
        Network.share.requestMyState(type: MyQueueStateResponse.self, router: api) { [weak self] response in
            
            switch response {
            case .success(let stateData):
                if stateData.matched == 1 {
                    // 사용자 현재 상태를 매칭 상태로 변경
                    
                    self?.view.makeToast("\(stateData.matchedNick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다.", duration: 1.0, position: .center) { didTap in
                        let vc = ChattingViewController()
                        self?.transition(vc, transitionStyle: .push)
                    }
                } else if stateData.matched == 0 {
                    // 사용자 현재 상태는 매칭 대기중 상태
                }
                
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = SignupError(rawValue: code) else { return }
                print("⭐️⭐️⭐️현재 매칭모드 실패 : errorCode = \(errorCode), error설명 = \(error.localizedDescription)")
                
                switch errorCode {
                case .fbTokenError:
                    self?.refreshIDTokenQueue()
                default :
                    self?.view.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                }
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
                
                let api = APIRouter.myQueueState
                Network.share.requestMyState(type: MyQueueStateResponse.self, router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let stateData):
                        if stateData.matched == 1 {
                            // 사용자 현재 상태를 매칭 상태로 변경
                            
                            self?.view.makeToast("\(stateData.matchedNick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다.", duration: 1.0, position: .center) { didTap in
                                let vc = ChattingViewController()
                                self?.transition(vc, transitionStyle: .push)
                            }
                        } else if stateData.matched == 0 {
                            // 사용자 현재 상태는 매칭 대기중 상태
                        }
                        
                        
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = LoginError(rawValue: code) else { return }
                        switch errorCode {
                        default:
                            self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        }
                    }
                }
            }
        }
    }
 
}
