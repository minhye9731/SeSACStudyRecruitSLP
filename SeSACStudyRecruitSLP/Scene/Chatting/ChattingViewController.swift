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


// scrollBottom
// pagenation + database

final class ChattingViewController: BaseViewController {
    
    // MARK: - property
    let mainView = ChattingView()
//    var chat: [Chat] = []
    var chatList: [GeneralChat] = []
    var otherSesacUID = ""
    var otherSesacNick = ""
    let disposeBag = DisposeBag()
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
        
        setBarButtonItem()
        self.title = otherSesacNick
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.chatTextView.delegate = self

        IQKeyboardManager.shared.enable = false
        
        subscribe()
        
//        fetchChats()
        
        // on sesac 으로 받은 이벤트를 처리하기 위한 Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        
        // 발송용 test

        mainView.moreMenuView.isHidden = menuTapped ? false : true
    }
    
    @objc func getMessage(notification: NSNotification) {
//        let chat = notification.userInfo!["chat"] as! String
//        let name = notification.userInfo!["name"] as! String
//        let createdAt = notification.userInfo!["createdAt"] as! String
//        let userID = notification.userInfo!["userId"] as! String
        
        // 채팅 구조체로 만든다
//        let value = Chat(text: chat, userID: userID, name: name, username: "", id: "", createdAt: createdAt, updatedAt: "", v: 0, ID: "")
        
        // test
//        chat = [
//            Chat(text: chat, userID: userID, name: name, username: "", id: "", createdAt: createdAt, updatedAt: "", v: 0, ID: "")
//        ]
        
        
//        self.chat.append(value)
//        mainView.tableView.reloadData()
//        mainView.tableView.scrollToRow(at: IndexPath(row: self.chat.count - 1, section: 0), at: .bottom, animated: false)
    }

}

// MARK: - tableview
extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
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
        
        let data = chatList[indexPath.row] // 시간순 정렬?
        
        if data.id == otherSesacUID {
            let yourCell = tableView.dequeueReusableCell(withIdentifier: "YourChatTableViewCell", for: indexPath) as! YourChatTableViewCell
            yourCell.yourChatLabel.text = data.chat
            return yourCell
        } else {
            let myCell = tableView.dequeueReusableCell(withIdentifier: "MyChatTableViewCell", for: indexPath) as! MyChatTableViewCell
            myCell.myChatLabel.text = data.chat
            return myCell
        }
    }
    
}

// MARK: - 채팅 소켓 통신
extension ChattingViewController {

    private func fetchChats() {
        
        // 1) DB에 저장된 채팅 내역을 갖고온다
            //- 상대방 uid에 대항하는 채팅 내용을 필터해서 가져옴
        
        // 2) 가장 마지막 날짜에 전송된 채팅 날짜를 서버에 요청한다
        //(만약 채팅 내역이 없어 가져올 날짜가 없다면 "2000-01-01T00:00:00.000Z"를 사용
        
        // 3) lastdate API를 호출해, 채팅 화면에 들어갔을 때 마지막에 받은 채팅 이후의 채팅 내역을 불러옴
            // 새로운 데이터가 있다면 DB에 저장
        
        // 4) 테이블뷰 갱신함
        
        
        // 5) 소켓을 연결
        
        
//        let latestChatTime = "" // userdefaults에서 가져오자. 해당 시간은 마지막으로 send된 시간
//
//        let api = ChatAPIRouter.takeList(lastchatDate: latestChatTime)
//        Network.share.requestSendChat(type: [Chat].self, router: api) { [weak self] response in
//
//            switch response.result {
//            case .success(let value):
//                self?.chat = value
//                self?.mainView.tableView.reloadData()
//                self?.mainView.tableView.scrollToRow(at: IndexPath(row: self!.chat.count - 1, section: 0), at: .bottom, animated: false)
//
//                // 이전의 데이터를 다 받아서 갱신해준 후에, 소켓통신을 해주자
//                SocketIOManager.shared.establishConnection()
//            case .failure(let error):
//                print("FAIL", error)
//            }
//        }
//
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
                
                let id = value.id
                let to = value.to
                let from = value.from
                let chat = value.chat
                let createdAt = value.createdAt
                
                let mychat = GeneralChat(id: id, to: to, from: from, chat: chat, createdAt: createdAt)
                
                // 응답값인 mychat을 DB에 저장함
                
                self?.mainView.tableView.reloadData()
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
    
    func subscribe() {
        
        // 전송 버튼
        mainView.sendbtn.rx.tap
            .bind {
                guard let text = self.mainView.chatTextView.text else { return }
                print("발송! : \(text)")
                
                self.postChat(text: text)
            }
            .disposed(by: disposeBag)
        
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
                self.mainView.moreMenuView.isHidden = true
                let vc = PopUpViewController()
                vc.popupMode = .cancelStudy
                self.transition(vc, transitionStyle: .presentOverFullScreen)
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




















