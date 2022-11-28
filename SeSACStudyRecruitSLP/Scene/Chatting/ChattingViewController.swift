//
//  ChattingViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/20/22.
//

import UIKit
import Alamofire // 따로 빼서 관리 예정

// scrollBottom
// pagenation + database

final class ChattingViewController: BaseViewController {
    
    // MARK: - property
    let mainView = ChattingView()
    var dummy: [String] = [] // test
    var chat: [Chat] = []
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        setBarButtonItem()
        self.title = "고래밥" // test
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        dummyChat() // test
        fetchChats()
        
        // on sesac 으로 받은 이벤트를 처리하기 위한 Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        
        // 발송용 test
        mainView.sendbtn.addTarget(self, action: #selector(sendbtnTapped), for: .touchUpInside)
        
    }
    
    @objc func getMessage(notification: NSNotification) {
            
        let chat = notification.userInfo!["chat"] as! String
        let name = notification.userInfo!["name"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let userID = notification.userInfo!["userId"] as! String
        
        // 채팅 구조체로 만든다
        let value = Chat(text: chat, userID: userID, name: name, username: "", id: "", createdAt: createdAt, updatedAt: "", v: 0, ID: "")
        
        self.chat.append(value)
        mainView.tableView.reloadData()
        mainView.tableView.scrollToRow(at: IndexPath(row: self.chat.count - 1, section: 0), at: .bottom, animated: false)
    }
    
    // test용
    @objc func sendbtnTapped() {
        dummy.append(mainView.chatTextField.text ?? "")
        mainView.tableView.reloadData()
        mainView.tableView.scrollToRow(at: IndexPath(row: dummy.count - 1, section: 0), at: .bottom, animated: false)
//        postChat(text: contentTextField.text ?? "")
    }
    

}

// MARK: - tableview
extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy.count // chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = dummy[indexPath.row] // chat[indexPath.row]
        
//        if data.userID == APIKey.userId {
        if indexPath.row.isMultiple(of: 2) { // test
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatTableViewCell", for: indexPath) as! MyChatTableViewCell
            cell.myChatLabel.text = data //data.text
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChatTableViewCell", for: indexPath) as! YourChatTableViewCell
            cell.yourChatLabel.text = data//data.text
            return cell
        }
    }
    
    
}

// MARK: - 채팅 소켓 통신
extension ChattingViewController {
    
    // test
    private func dummyChat() {
        dummy = ["안녕하세요", "반갑습니다", "별명이 왜 고래밥인가요?", "세상에서\n고래밥 과자가 젤\n맛있더라구요", "아..."]
    }
    
    private func fetchChats() {
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(APIKey.header)", // header 갱신 필요
            "Content-Type": "application/json"
        ]

        AF.request(APIKey.url, method: .get, headers: header).responseDecodable(of: [Chat].self) { [weak self] response in
            
            switch response.result {
            case .success(let value):
                self?.chat = value
                self?.mainView.tableView.reloadData()
                self?.mainView.tableView.scrollToRow(at: IndexPath(row: self!.chat.count - 1, section: 0), at: .bottom, animated: false)
                
                // 이전의 데이터를 다 받아서 갱신해준 후에, 소켓통신을 해주자
                SocketIOManager.shared.establishConnection()
                
            case .failure(let error):
                print("FAIL", error)
            }
        }
    }
    
//
//    private func postChat(text: String) {
//        let header: HTTPHeaders = [
//            "Authorization": "Bearer \(APIKey.header)",
//            "Content-Type": "application/json"
//        ]
//        AF.request(APIKey.url, method: .post, parameters: ["text": text], encoder: JSONParameterEncoder.default, headers: header).responseString { data in
//            print("POST CHAT SUCCEED", data)
//        }
//    }
    
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
        transition(vc, transitionStyle: .presentFull) // test
    }
    
}
