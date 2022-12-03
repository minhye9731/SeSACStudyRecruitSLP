//
//  ChattingViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/20/22.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire // 따로 빼서 관리 예정

// scrollBottom
// pagenation + database

final class ChattingViewController: BaseViewController {
    
    // MARK: - property
    let mainView = ChattingView()
    var chat: [Chat] = []
    var otherSesacUID = ""
    var otherSesacNick = ""
    
    
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
        
        IQKeyboardManager.shared.enable = false
//        keyboardObserver()
        
//        fetchChats()
        
        // on sesac 으로 받은 이벤트를 처리하기 위한 Notification Observer
//        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        
        // 발송용 test
        // 화면상 수동 발송 test
        mainView.sendbtn.addTarget(self, action: #selector(sendbtnTapped), for: .touchUpInside)
    }
    
    @objc func getMessage(notification: NSNotification) {
            
        let chat = notification.userInfo!["chat"] as! String
        let name = notification.userInfo!["name"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let userID = notification.userInfo!["userId"] as! String
        
        // 채팅 구조체로 만든다
        let value = Chat(text: chat, userID: userID, name: name, username: "", id: "", createdAt: createdAt, updatedAt: "", v: 0, ID: "")
        
        // test
//        chat = [
//            Chat(text: chat, userID: userID, name: name, username: "", id: "", createdAt: createdAt, updatedAt: "", v: 0, ID: "")
//        ]
        
        
        self.chat.append(value)
        mainView.tableView.reloadData()
        mainView.tableView.scrollToRow(at: IndexPath(row: self.chat.count - 1, section: 0), at: .bottom, animated: false)
    }
    
    // test용
    @objc func sendbtnTapped() {
        
        guard let text = mainView.chatTextField.text else { return }
        print("발송! : \(text)")
        
        postChat(text: text)
    }

//    func keyboardObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    @objc func keyboardWillShow(noti: Notification) {
//    }

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
            return yourCell
        } else {
            let myCell = tableView.dequeueReusableCell(withIdentifier: "MyChatTableViewCell", for: indexPath) as! MyChatTableViewCell
            myCell.myChatLabel.text = data.text
            return myCell
        }
    }
    
}

// MARK: - 채팅 소켓 통신
extension ChattingViewController {
    
    // test
//    private func dummyChat() {
//        dummy = ["안녕하세요", "반갑습니다", "별명이 왜 고래밥인가요?", "세상에서\n고래밥 과자가 젤\n맛있더라구요", "아..."]
//    }
    
    // 이전의 대화기록 가져오기
//    private func fetchChats() {
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
//    }
    
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
                
                chat.append(value.chat) // chat요소에 생성시간 or 발송시간 정보도 담는 튜플같은거로 만들까
                self?.mainView.tableView.reloadData()
                return
            case .normalStatus:
                print("상대방에게 채팅을 보낼 수 없는 '일반 상태'임")
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
        print("위에서 아래로 스르르 내려오는 애니메이션")
        let vc = MoreMenuViewController()
        transition(vc, transitionStyle: .present) // test
    }
    
}
