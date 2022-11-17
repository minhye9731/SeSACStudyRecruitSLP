//
//  MyInfoViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit
import SnapKit

struct MenuList: Hashable {
    let id = UUID().uuidString
    let title: String?
    let image: String
    let nextimage: String?
    
    static let menuContents = [
        // UserDefaults.standard.string(forKey: "nickName")
        MenuList(title: "홍길동", image: "AppIcon", nextimage: Constants.ImageName.more.rawValue),
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
            
            // test용
            UserDefaultsManager.background = 3
            UserDefaultsManager.sesac = 3
            UserDefaultsManager.nick = "에밀리"
            UserDefaultsManager.reputation = [1, 0, 4, 2, 0, 4, 0, 6]
//            UserDefaultsManager.gender = 0
//            UserDefaultsManager.study = "개미들아 힘내자"
//            UserDefaultsManager.searchable = 1
//            UserDefaultsManager.ageMin = 30
//            UserDefaultsManager.ageMax = 59
            
            let data = UserInfoUpdateDTO(
                searchable: UserDefaultsManager.searchable,
                ageMin: UserDefaultsManager.ageMin,
                ageMax: UserDefaultsManager.ageMax,
                gender: UserDefaultsManager.gender,
                study: UserDefaultsManager.study
            )
            
            // (수정방향)
            // 여기서 유저정보 통신을 다시함.
            // 통신한 데이터중, UserInfoUpdateDTO에 담을 수 있는건 담아서 다음 페이지의 updateData 변수에 담아넘김 (수정 or 수정최소 대비용)
            //UserInfoUpdateDTO에 해당하지 않지만, 정보관리 페이지에 필요한 항목은 userdefaults에 저장?????
            // 여기서 통신 성공을 해야 넘어가도록 할까?
            // 통신 소요시간 길어짐 대비해서 인디케이터 추가 필요할듯
            
            let vc = InfoManageViewController()
            vc.updateData = data
            transition(vc, transitionStyle: .push)
        }
    }
}
