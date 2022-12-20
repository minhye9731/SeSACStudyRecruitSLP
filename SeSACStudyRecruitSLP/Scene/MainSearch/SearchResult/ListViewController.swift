//
//  ListViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit
import FirebaseAuth
import Tabman

final class ListViewController: BaseViewController {
    
    // MARK: - property
    let mainView = ListView()
    var aroundOrAccepted: SearchMode = .aroundSesac
    var limitOvercallAPI = false
    
    var isExpandedList: [Bool] = []
    var aroundSesacList: [FromQueueDB] = []
    var receivedSesacList: [FromQueueDB] = []
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchSesac()
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        configureEmptyView()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    func configureEmptyView() {
        mainView.emptyView.mainNotification.text = pageboyPageIndex == 0 ? "아쉽게도 주변에 새싹이 없어요ㅠ" : "아직 받은 요청이 없어요ㅠ"
        mainView.emptyView.refreshBtn.addTarget(self, action: #selector(refreshBtnTapped), for: .touchUpInside)
        mainView.emptyView.studyChangeBtn.addTarget(self, action: #selector(studyChangeBtnTapped), for: .touchUpInside)
    }
}
// MARK: - tableview
extension ListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pageboyPageIndex == 0 ? aroundSesacList.count : receivedSesacList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isExpandedList[section] ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let result = ((view.frame.width - 32) * 0.6) + 58
        return result
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.reuseIdentifier) as? CollapsibleTableViewHeader else { return UIView() }
        
        // 코드정리
        headerView.setCollapsed(isExpandedList[section])
        headerView.section = section
        
        headerView.askAcceptbtn.addTarget(self, action: #selector(askAcceptbtnTapped), for: .touchUpInside)
        headerView.askAcceptbtn.header = headerView
        headerView.askAcceptbtn.section = section
        
        headerView.namebtn.addTarget(self, action: #selector(headerNameTapped), for: .touchUpInside)
        headerView.namebtn.header = headerView
        headerView.namebtn.section = section
        
        headerView.setSesacData(data: pageboyPageIndex == 0 ? aroundSesacList : receivedSesacList, section: section)
        
        headerView.setAskAcceptBtn(page: pageboyPageIndex!)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseIdentifier) as? ProfileCell else { return UITableViewCell() }
        
        // 코드정리
        profileCell.selectionStyle = .none
        profileCell.setSesacData(data: pageboyPageIndex == 0 ? aroundSesacList : receivedSesacList, section: indexPath.section)
        
        profileCell.moreReview.addTarget(self, action: #selector(moreReviewTapped), for: .touchUpInside)
        profileCell.moreReview.data =  pageboyPageIndex == 0 ? aroundSesacList : receivedSesacList
        profileCell.moreReview.section = indexPath.section
        profileCell.isStudyHidden(type: .otherSesac)
        
        return profileCell
    }
}

// MARK: - 기타 함수
extension ListViewController {
    
    @objc func askAcceptbtnTapped(sender: HeaderSectionPassButton) {
        guard let section = sender.section else { return }
        
        let vc = PopUpViewController()
        vc.popupMode = pageboyPageIndex == 0 ? .askStudy : .acceptStudy
        vc.otheruid = pageboyPageIndex == 0 ? aroundSesacList[section].uid : receivedSesacList[section].uid
        
        vc.matchingMode = .standby
        print("🥶내가 요청을 보내거나/받은 새싹 = \(vc.otheruid)")
        transition(vc, transitionStyle: .presentOverFullScreen)
    }
    
    @objc func headerNameTapped(sender: HeaderSectionPassButton) {
        guard let header = sender.header else { return }
        guard let section = sender.section else { return }
        
        isExpandedList[section].toggle()
        header.setCollapsed(isExpandedList[section])
        
        mainView.tableView.reloadData()// 접었다펼쳤다 할 때 tableview 갱신 때문에 화면이 버벅거림
        
        //        if isExpandedList[section] { // 펼친 카드를 받을 경우??
        //            searchSesac() // **호출시점 4-2
        //            // 여기 떄문에, 클릭 하자마자 user card 접혔다가 바로 펼쳐짐
        //        }
    }
    
    @objc func moreReviewTapped(sender: moreReviewButton) {
        guard let info = sender.data else { return }
        guard let row = sender.section else { return }
        
        let vc = MoreReviewViewController()
        vc.reviewList = info[row].reviews
        transition(vc, transitionStyle: .push)
    }
    
    // [스터디 변경하기] 버튼
    @objc func studyChangeBtnTapped() {
        stopSearchSesac()
    }
    
    // [새로고침 버튼]
    @objc func refreshBtnTapped() {
        searchSesac()
    }
    
}

// MARK: - search API
extension ListViewController {
    
    // 과호출 제한 - timeout 방안으로 추가 조사 필요
    func limitOvercall() {
        limitOvercallAPI = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.limitOvercallAPI = false
        }
    }
    
    // search
    func searchSesac() {
        print(#function)
        
        let api = QueueAPIRouter.search(
            lat: UserDefaultsManager.searchLAT,
            long: UserDefaultsManager.searchLONG)
        
        print("🤑UserDefaultsManager.searchLAT = \(UserDefaultsManager.searchLAT)")
        print("🤑UserDefaultsManager.searchLONG = \(UserDefaultsManager.searchLONG)")
        
        if !limitOvercallAPI {
            Network.share.requestSearch(router: api) { [weak self] (value, statusCode, error) in
                
                guard let value = value else { return }
                guard let statusCode = statusCode else { return }
                guard let status = StudyRequestError(rawValue: statusCode) else { return }
                
                switch status {
                case .success:
                    print("🦄search 통신 성공!!")
                    self?.limitOvercall()
                    
                    if self?.pageboyPageIndex == 0 {
                        self?.aroundSesacList =
                        value.fromQueueDB
                        
                        if self!.aroundSesacList.isEmpty {
                            self?.mainView.emptyView.isHidden = false
                            self?.mainView.tableView.isHidden = true
                        } else {
                            self?.mainView.emptyView.isHidden = true
                            self?.mainView.tableView.isHidden = false
                            
                            self?.isExpandedList = Array(repeating: false, count: self!.aroundSesacList.count)
                            self?.mainView.tableView.reloadData()
                        }
                    } else {
                        self?.receivedSesacList = value.fromQueueDBRequested
                        
                        if self!.receivedSesacList.isEmpty {
                            self?.mainView.emptyView.isHidden = false
                            self?.mainView.tableView.isHidden = true
                        } else {
                            self?.mainView.emptyView.isHidden = true
                            self?.mainView.tableView.isHidden = false
                            
                            self?.isExpandedList = Array(repeating: false, count: self!.receivedSesacList.count)
                            self?.mainView.tableView.reloadData()
                        }
                    }
                    return
                    
                case .fbTokenError:
                    self?.refreshIDTokenSearchSesac()
                    return
                default:
                    self?.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", duration: 1.0, position: .center)
                    return
                }
            }
        } else {
            return
        }
    }
    
    func refreshIDTokenSearchSesac() {
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default:
                    self.mainView.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
                }
                return
            } else if let idToken = idToken {
                UserDefaultsManager.idtoken = idToken
                print("🦄갱신된 idToken 저장완료 |  UserDefaultsManager.idtoken = \(UserDefaultsManager.idtoken)")
                
                let api = QueueAPIRouter.search(
                    lat: UserDefaultsManager.searchLAT,
                    long: UserDefaultsManager.searchLONG)
                
                Network.share.requestSearch(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let value = value else { return }
                    guard let statusCode = statusCode else { return }
                    guard let status = StudyRequestError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        
                        if self?.pageboyPageIndex == 0 {
                            self?.aroundSesacList =
                            value.fromQueueDB
                            
                            if self!.aroundSesacList.isEmpty {
                                self?.mainView.emptyView.isHidden = false
                                self?.mainView.tableView.isHidden = true
                            } else {
                                self?.mainView.emptyView.isHidden = true
                                self?.mainView.tableView.isHidden = false
                                
                                self?.isExpandedList = Array(repeating: false, count: self!.aroundSesacList.count)
                                self?.mainView.tableView.reloadData()
                            }
                        } else {
                            self?.receivedSesacList = value.fromQueueDBRequested
                            
                            if self!.receivedSesacList.isEmpty {
                                self?.mainView.emptyView.isHidden = false
                                self?.mainView.tableView.isHidden = true
                            } else {
                                self?.mainView.emptyView.isHidden = true
                                self?.mainView.tableView.isHidden = false
                                
                                self?.isExpandedList = Array(repeating: false, count: self!.receivedSesacList.count)
                                self?.mainView.tableView.reloadData()
                            }
                        }
                        return
                    default:
                        self?.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
}

// MARK: - delete queue API
extension ListViewController {
    
    func stopSearchSesac() {
        let api = QueueAPIRouter.delete
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status = QueueDeleteError(rawValue: statusCode) else { return }
            
            switch status {
            case .success:
                self?.navigationController?.popViewController(animated: true)
                return
            
            case .alreayMatched:
                self?.view.makeToast(status.errorDescription, duration: 1.0, position: .center) { didTap in
                    let vc = ChattingViewController()
                    self?.transition(vc, transitionStyle: .push)
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
                        self?.navigationController?.popViewController(animated: true)
                        return
                    
                    case .alreayMatched:
                        self?.view.makeToast(status.errorDescription, duration: 1.0, position: .center) { didTap in
                            let vc = ChattingViewController()
                            self?.transition(vc, transitionStyle: .push)
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
        }
    }
}


