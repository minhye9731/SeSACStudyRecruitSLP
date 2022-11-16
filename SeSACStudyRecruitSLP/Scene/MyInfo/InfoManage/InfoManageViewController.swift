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
    var isExpanded = false

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
        setBarButtonItem()
    }

}

// MARK: - tableview 설정 관련
extension InfoManageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpanded {
            return section == 0 ? 1 : 5
        } else {
            return section == 0 ? 0 : 5
        }
    }
    
    // header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let result = ((view.frame.width - 32) * 0.58) + 58
        return section == 0 ? result : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.reuseIdentifier) as? CollapsibleTableViewHeader else { return UIView() }

        headerView.backgroundImage.image = UIImage(named: Constants.ImageName.bg1.rawValue) //test
        headerView.sesacImage.image = UIImage(named: Constants.ImageName.face1.rawValue) //test
        headerView.nameLabel.text = "홍길동" // test
        headerView.setCollapsed(isExpanded) // test
        headerView.section = section
        headerView.delegate = self

        return section == 0 ? headerView : nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let profileCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseIdentifier) as? ProfileCell else { return UITableViewCell() }
        guard let genderCell = tableView.dequeueReusableCell(withIdentifier: GenderCell.reuseIdentifier) as? GenderCell else { return UITableViewCell() }
        guard let oftenStudyCell = tableView.dequeueReusableCell(withIdentifier: OftenStudyCell.reuseIdentifier) as? OftenStudyCell else { return UITableViewCell() }
        guard let pnumPermitCell = tableView.dequeueReusableCell(withIdentifier: PnumPermitCell.reuseIdentifier) as? PnumPermitCell else { return UITableViewCell() }
        guard let ageRangeCell = tableView.dequeueReusableCell(withIdentifier: AgeRangeCell.reuseIdentifier) as? AgeRangeCell else { return UITableViewCell() }
        guard let withdrawCell = tableView.dequeueReusableCell(withIdentifier: WithdrawCell.reuseIdentifier) as? WithdrawCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            return profileCell
        } else {
            switch indexPath.row {
            case 0: return genderCell
            case 1: return oftenStudyCell
            case 2: return pnumPermitCell
            case 3: return ageRangeCell
            case 4: return withdrawCell
            default : return withdrawCell
            }
        }
    }
    
}

// MARK: - 접었다폈다 로직
extension InfoManageViewController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
    
        isExpanded.toggle()
        header.setCollapsed(isExpanded)
        mainView.tableView.reloadData()
    }
}

// MARK: - 저장 버튼 메서드
extension InfoManageViewController {
    func setBarButtonItem() {
        let navibarAppearance = UINavigationBarAppearance()
        let barbuttonItemAppearance = UIBarButtonItemAppearance()
        barbuttonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black, .font: CustomFonts.title3_M14()]
        navibarAppearance.buttonAppearance = barbuttonItemAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(doneTapped))
    }
    
    @objc func doneTapped() {
        print("내정보 관리 저장 완료!! :)")
    }
}

