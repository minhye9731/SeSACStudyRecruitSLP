//
//  ChattingViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/20/22.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire // 따로 빼서 관리 예정
import RxKeyboard
import RxSwift
import SnapKit
import RealmSwift
import FirebaseAuth

// scrollBottom
// pagenation + database

final class ChattingViewController: BaseViewController {
    
    // MARK: - property
    let mainView = ChattingView()
    let viewModel = ChattingViewModel()
    let disposeBag = DisposeBag()
    
    var chat: [Chat] = []
    var pastDateArr = [Date]()
    
    var otherSesacUID = ""
    var otherSesacNick = ""
    var menuTapped = false

    
    // MARK: - Lifecycle
    override func loadView()  {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        print("👄현재 대화중인 상대방 = \(otherSesacNick) | \(otherSesacUID)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.shared.closeConnection()
    }
    
    
    // MARK: - functions
    override func configure() {
        super.configure()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        setBarButtonItem()
        self.title = otherSesacNick
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.chatTextView.delegate = self

        IQKeyboardManager.shared.enable = false
        
        subscribe()
        bind()
        
        fetchChats()
        
        // on sesac 으로 받은 이벤트를 처리하기 위한 Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        
        mainView.moreMenuView.isHidden = menuTapped ? false : true
    }
    
    @objc func getMessage(notification: NSNotification) {
        
        let id = notification.userInfo!["id"] as! String
        let chat = notification.userInfo!["chat"] as! String
        let userID = notification.userInfo!["from"] as! String
//        let name = notification.userInfo!["name"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        
        let newChat = Chat(text: chat, userID: userID, name: "", username: "", id: id, createdAt: createdAt, updatedAt: "", v: 0, ID: "")
        
        self.chat.append(newChat)
        mainView.tableView.reloadData()
        mainView.tableView.scrollToRow(at: IndexPath(row: self.chat.count - 1, section: 0), at: .bottom, animated: false)
    }

}

// MARK: - tableview
extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let result = view.frame.width * 0.28
        return result
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChattingTableViewHeader.reuseIdentifier) as? ChattingTableViewHeader else { return UIView() }

        // 첫 매칭시점 일자 가져오기
        headerView.matchingSesacLabel.text = "\(otherSesacNick)님과 매칭되었습니다"
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = chat[indexPath.row] // 시간순 정렬?
        
        if data.userID == otherSesacUID {
            let yourCell = tableView.dequeueReusableCell(withIdentifier: "YourChatTableViewCell", for: indexPath) as! YourChatTableViewCell
            yourCell.yourChatLabel.text = data.text
            yourCell.yourTimeLabel.text = data.createdAt
            return yourCell
        } else {
            let myCell = tableView.dequeueReusableCell(withIdentifier: "MyChatTableViewCell", for: indexPath) as! MyChatTableViewCell
            myCell.myChatLabel.text = data.text
            myCell.myTimeLabel.text = data.createdAt
            return myCell
        }
    }
    
}

// MARK: - 채팅 소켓 통신
extension ChattingViewController {

    private func fetchChats() {
        
        // 1) DB에 저장된 채팅 내역을 갖고온다
            //- 상대방 uid에 대항하는 채팅 내용을 필터해서 가져옴
        ChatRepository.standard.filteredByUID(uid: otherSesacUID)
        self.pastDateArr = ChatRepository.standard.localRealm.objects(ChatRealmModel.self).map { $0.createdAt.toDate() }.sorted()
        print("📆pastDateArr = \(pastDateArr)")
        
        // 2) 가장 마지막 날짜에 전송된 채팅 날짜를 서버에 요청한다
        //(만약 채팅 내역이 없어 가져올 날짜가 없다면 "2000-01-01T00:00:00.000Z"를 사용
        let defaultDate = "2000-01-01T00:00:00.000Z"
        let latestDate = pastDateArr.isEmpty ? defaultDate : pastDateArr[0].toBirthDateForm()
        print("📆latestDate = \(latestDate)")
        
        // 3) lastdate API를 호출해, 채팅 화면에 들어갔을 때 마지막에 받은 채팅 이후의 채팅 내역을 불러옴
        let api = ChatAPIRouter.takeList(lastchatDate: latestDate, uid: otherSesacUID)
        Network.share.requestLastChat(router: api) { [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status =  LastChatError(rawValue: statusCode) else { return }
            print("👁요청시점 이후 새로 들어온 chat 데이터ㅣ statusCode : \(statusCode)")
            print("👁요청시점 이후 새로 들어온 chat 데이터ㅣ value : \(value)")
            
            switch status {
            case .success:
               
                // 새로운 데이터가 있다면 DB에 저장
                if !value.payload.isEmpty {
                    value.payload.forEach { data in
                        let chat = data.chat
                        let userID = data.from
                        let id = data.id
                        let createdAt = data.createdAt
                        
                        let value = Chat(text: chat, userID: userID, name: "", username: "", id: id, createdAt: createdAt, updatedAt: Date().toBirthDateForm(), v: 0, ID: "")
                        print("👄신규데이터 = \(value)")
                        self?.chat.append(value)
                    }
                }
                
                // 4) 테이블뷰 갱신함
                self?.mainView.tableView.reloadData()
                self?.mainView.tableView.scrollToRow(at: IndexPath(row: self!.chat.count - 1, section: 0), at: .bottom, animated: false)
                
                // 5) 소켓을 연결
                SocketIOManager.shared.establishConnection()
                
                return
                
            case .fbTokenError:
                print("토큰에러")
                return
            default :
                print("에러당~~~~")
                return
            }
        }
        
    }
    
    private func postChat(text: String) {

        let api = ChatAPIRouter.send(chat: text, uid: otherSesacUID)
        Network.share.requestPostChat(router: api) { [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status =  SendChatError(rawValue: statusCode) else { return }
            print("👁채팅전송 statusCode : \(statusCode)")
            
            switch status {
            case .success:
                print("👁채팅전송 성공:::\(value.chat) || \(value.to)")
                
                let chat = value.chat
                let userID = value.from
                let id = value.id
                let createdAt = value.createdAt
                
                let value = Chat(text: chat, userID: userID, name: "", username: "", id: id, createdAt: createdAt, updatedAt: Date().toBirthDateForm(), v: 0, ID: "")
                let valueForRealm = ChatRealmModel(text: chat, userID: userID, name: "", username: "", id: id, createdAt: createdAt, updatedAt: Date().toBirthDateForm(), v: 0, ID: "")
                print("👄내가보낸 채팅 신규데이터 = \(value)")
                
                self?.chat.append(value) // 화면표기용 (chat에 추가)
                ChatRepository.standard.plusChat(item: valueForRealm) // DB에 저장
                
                self?.mainView.tableView.reloadData()
                self?.mainView.tableView.scrollToRow(at: IndexPath(row: self!.chat.count - 1, section: 0), at: .bottom, animated: false)
                return
                
            case .normalStatus:
                self?.mainView.makeToast(status.errorDescription, duration: 1.0, position: .center)
                return
                
            case .fbTokenError:
                print("토큰에러")
                return
            default : return print("에러당~~~~")
            }
        }
    }
    
    
}

// MARK: - 기타
extension ChattingViewController {
    
    func setBarButtonItem() {
        let navibarAppearance = UINavigationBarAppearance()
        let barbuttonItemAppearance = UIBarButtonItemAppearance()
        barbuttonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black, .font: CustomFonts.title3_M14()]
        navibarAppearance.buttonAppearance = barbuttonItemAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.ImageName.moreDot.rawValue), style: .plain, target: self, action: #selector(chattingMoreMenuTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.ImageName.back.rawValue), style: .plain, target: self, action: #selector(backToHome))
    }
    
    @objc func chattingMoreMenuTapped() {
        menuTapped.toggle()
        mainView.moreMenuView.isHidden = menuTapped ? false : true
        
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        
        UIView.animate(withDuration: 0.5, animations: {
            self.mainView.menuButtonBackView.frame = CGRect(x: 0, y: width * 0.192, width: width, height: width * 0.192)
        }, completion: { (_) in
            self.mainView.menuButtonBackView.frame = CGRect(x: 0, y: 0, width: width, height: width * 0.192)
        })
    }
    
    @objc func backToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}

// MARK: - textview
extension ChattingViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        mainView.chatTextViewHeightConstraint?.update(offset: self.mainView.chatTextView.contentSize.height + 28)
        mainView.layoutIfNeeded()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let changedSize = textView.sizeThatFits(size)
        let maxHeight = changedSize.height >= 60
        
        guard maxHeight != textView.isScrollEnabled else { return }
        textView.isScrollEnabled = maxHeight
        textView.reloadInputViews()
        mainView.setNeedsUpdateConstraints()
  
        print(mainView.chatTextView.frame.height)
    }

}

// MARK: - rx 액션들
extension ChattingViewController {
    
    func bind() {
        let input = ChattingViewModel.Input(
            chatText: mainView.chatTextView.rx.text,
            tap: mainView.sendbtn.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.validStatus
            .withUnretained(self)
            .bind { (vc, value) in
                let borderColor: UIColor = value ? ColorPalette.gray6 : ColorPalette.green
                let backgroundColor: UIColor = value ? .clear : ColorPalette.green
                vc.mainView.sendbtn.layer.borderColor = borderColor.cgColor
                vc.mainView.sendbtn.backgroundColor = backgroundColor
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .bind { _ in
                guard let text = self.mainView.chatTextView.text else { return }
                
                if self.mainView.chatTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.mainView.makeToast("채팅은 1자 이상부터 발송 가능합니다.", duration: 1.0, position: .center)
                } else {
                    print("발송! : \(text)")
                    self.postChat(text: text)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    
    // 정리해서 input/output으로 옮기자
    func subscribe() {
        
        // 전송 버튼
//        mainView.sendbtn.rx.tap
//            .bind {
//                guard let text = self.mainView.chatTextView.text else { return }
//                print("발송! : \(text)")
//
//                self.postChat(text: text)
//            }
//            .disposed(by: disposeBag)
        
        // textview 입력시 높이조절
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardHeight in
                let height = keyboardHeight > 0 ? -keyboardHeight + mainView.safeAreaInsets.bottom : 0
                
                mainView.grayView.snp.updateConstraints {
                    $0.bottom.equalTo(mainView.safeAreaLayoutGuide).offset(height)
                }
                mainView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        // 취소버튼
        mainView.cancelButton.rx.tap
            .bind {
                self.myQueueState() // 취소시 상대방의 취소여부에 따라 나의 상태도 달라짐.
            }
            .disposed(by: disposeBag)
        
        // 리뷰 등록
        mainView.reviewButton.rx.tap
            .bind {
                self.mainView.moreMenuView.isHidden = true
                let vc = WriteReviewViewController()
                self.transition(vc, transitionStyle: .presentOverFullScreen)
            }
            .disposed(by: disposeBag)
        
    }
}

extension ChattingViewController {
    
    func myQueueState() {
        let api = QueueAPIRouter.myQueueState
        Network.share.requestMyQueueState(router: api) { [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status =  MyQueueStateError(rawValue: statusCode) else { return }
            print("⭐️value : \(value), ⭐️statusCode: \(statusCode)")
            
            switch status {
            case .success:
                self?.mainView.moreMenuView.isHidden = true
                let vc = PopUpViewController()
                vc.popupMode = .cancelStudy
                vc.matchingMode = value.matched == 1 ? .matched : .normal
                self?.transition(vc, transitionStyle: .presentOverFullScreen)
                return
                
            case .fbTokenError:
                self?.refreshIDTokenQueue()
                return
                
            default :
                self?.mainView.makeToast(status.errorDescription, duration: 1.0, position: .center)
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
                    self.mainView.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
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
                        self?.mainView.moreMenuView.isHidden = true
                        let vc = PopUpViewController()
                        vc.popupMode = .cancelStudy
                        vc.matchingMode = value.matched == 1 ? .matched : .normal
                        self?.transition(vc, transitionStyle: .presentOverFullScreen)
                        return
                        
                    default :
                        self?.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
    
}




















