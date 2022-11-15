//
//  InfoManageViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class InfoManageViewController: BaseViewController {
    
    // MARK: - property
    let mainView = InfoManageView()

    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        self.title = "정보 관리"
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        // 네비바 우측버튼
    }

}

// MARK: - tableview 설정 관련
extension InfoManageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 5
    }
    
    // header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  section == 0 ? self.view.frame.width * 0.56 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeaderView.reuseIdentifier) as? CustomTableViewHeaderView else { return UIView() }
       
        headerView.backgroundImage.image = UIImage(named: Constants.ImageName.bg1.rawValue) //test
        headerView.sesacImage.image = UIImage(named: Constants.ImageName.face1.rawValue) //test
        
        return headerView
    }

    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let profileCell = tableView.dequeueReusableCell(withIdentifier: profileCell.reuseIdentifier) as? profileCell else { return UITableViewCell() }
        guard let genderCell = tableView.dequeueReusableCell(withIdentifier: genderCell.reuseIdentifier) as? genderCell else { return UITableViewCell() }
        guard let oftenStudyCell = tableView.dequeueReusableCell(withIdentifier: oftenStudyCell.reuseIdentifier) as? oftenStudyCell else { return UITableViewCell() }
        guard let pnumPermitCell = tableView.dequeueReusableCell(withIdentifier: pnumPermitCell.reuseIdentifier) as? pnumPermitCell else { return UITableViewCell() }
        guard let ageRangeCell = tableView.dequeueReusableCell(withIdentifier: ageRangeCell.reuseIdentifier) as? ageRangeCell else { return UITableViewCell() }
        guard let withdrawCell = tableView.dequeueReusableCell(withIdentifier: withdrawCell.reuseIdentifier) as? withdrawCell else { return UITableViewCell() }

        if indexPath.section == 0 {


            return profileCell
        } else {
            switch indexPath.row {
            case 0:

                return genderCell
            case 1:
                return oftenStudyCell
            case 2:
                return pnumPermitCell
            case 3:
                return ageRangeCell
            case 4:
                return withdrawCell
            default:
                return genderCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 310
        } else {
            return indexPath.row == 3 ? 80 : 48
        }
        
    }
    
}




