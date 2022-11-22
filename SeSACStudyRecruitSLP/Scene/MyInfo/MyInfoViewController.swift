//
//  MyInfoViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit
import SnapKit
import FirebaseAuth

struct MenuList: Hashable {
    let id = UUID().uuidString
    let title: String?
    let image: String
    let nextimage: String?
    
    static let menuContents = [
        MenuList(title: UserDefaultsManager.nick, image: "sesac_face_\(UserDefaultsManager.background + 1)", nextimage: Constants.ImageName.more.rawValue),
        MenuList(title: "공지사항", image: Constants.ImageName.notice.rawValue, nextimage: nil),
        MenuList(title: "자주 묻는 질문", image: Constants.ImageName.faq.rawValue, nextimage: nil),
        MenuList(title: "1:1 문의", image: Constants.ImageName.qna.rawValue, nextimage: nil),
        MenuList(title: "알림 설정", image: Constants.ImageName.alarm.rawValue, nextimage: nil),
        MenuList(title: "이용약관", image: Constants.ImageName.permit.rawValue, nextimage: nil)
    ]
}

final class MyInfoViewController: BaseViewController {

    // MARK: - property
    let mainView = MyInfoView()
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        self.title = "내정보"
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }

}

extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuList.menuContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell1 = tableView.dequeueReusableCell(withIdentifier: MyProfileInfoCell.reuseIdentifier) as? MyProfileInfoCell else { return  UITableViewCell() }
        guard let cell2 = tableView.dequeueReusableCell(withIdentifier: MyInfoCell.reuseIdentifier) as? MyInfoCell else { return UITableViewCell() }
        
        let contents = MenuList.menuContents[indexPath.row]
        
        if indexPath.row == 0 {
            tableView.rowHeight = 100
            cell1.selectionStyle = .none
            cell1.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell1.cellTitle.text = contents.title
            cell1.cellImage.image = UIImage(named: contents.image)
            cell1.moreViewImage.image = UIImage(named: contents.nextimage!)
            return cell1
        } else {
            cell2.selectionStyle = .none
            tableView.rowHeight = 80
            cell2.titleLabel.text = contents.title
            cell2.menuimage.image = UIImage(named: contents.image)
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            syncUserData()
        }
    }
    
    
}

// MARK: - 사용자 정보 동기화
extension MyInfoViewController {
    
    func syncUserData() {
        
        let api = APIRouter.login
        Network.share.requestLogin(type: LoginResponse.self, router: api) { [weak self] response in
            
            switch response {
            case .success(let loginData):
                UserDefaultsManager.background = loginData.background
                UserDefaultsManager.sesac = loginData.sesac
                UserDefaultsManager.nick = loginData.nick
                UserDefaultsManager.reputation = loginData.reputation
                UserDefaultsManager.comment = loginData.comment
                
                let syncData = UserInfoUpdateDTO(searchable: loginData.searchable, ageMin: loginData.ageMin, ageMax: loginData.ageMax, gender: loginData.gender, study: loginData.study)
                let vc = InfoManageViewController()
                vc.updateData = syncData
                self?.transition(vc, transitionStyle: .push)
                
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = LoginError(rawValue: code) else { return }
                print("failure // code = \(code), errorCode = \(errorCode)")
                
                switch errorCode {
                case .fbTokenError:
                    self?.refreshIDToken()
                default :
                    self?.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", duration: 1.0, position: .center)
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
                    self.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", duration: 1.0, position: .center)
                }
                return
            } else if let idToken = idToken {
                UserDefaultsManager.idtoken = idToken
                print("🦄갱신된 idToken 저장완료 |  UserDefaultsManager.idtoken = \(UserDefaultsManager.idtoken)")
                
                let api = APIRouter.login
                Network.share.requestLogin(type: LoginResponse.self, router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let loginData):
                        let syncData = UserInfoUpdateDTO(searchable: loginData.searchable, ageMin: loginData.ageMin, ageMax: loginData.ageMax, gender: loginData.gender, study: loginData.study)
                        
                        let vc = InfoManageViewController()
                        vc.updateData = syncData
                        self?.transition(vc, transitionStyle: .push)
                        
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = LoginError(rawValue: code) else { return }
                        switch errorCode {
                        default:
                            self?.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", duration: 1.0, position: .center)
                        }
                    }
                }
            }
        }
    }
    
}
