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
    var updateData = UserInfoUpdateDTO(searchable: 0, ageMin: 0, ageMax: 0, gender: 0, study: "")

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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let result = ((view.frame.width - 32) * 0.58) + 58
        return section == 0 ? result : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.reuseIdentifier) as? CollapsibleTableViewHeader else { return UIView() }
        
        headerView.setData(bgNum: UserDefaultsManager.background,
                           fcNum: UserDefaultsManager.sesac,
                           name: UserDefaultsManager.nick)
        headerView.setCollapsed(isExpanded)
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
            profileCell.selectionStyle = .none
            profileCell.setData(data: UserDefaultsManager.reputation)
            return profileCell
        } else {
            switch indexPath.row {
            case 0:
                genderCell.setData(data: UserDefaultsManager.gender)
                genderCell.selectionStyle = .none
                return genderCell
            case 1:
                oftenStudyCell.setData(data: UserDefaultsManager.study)
                oftenStudyCell.selectionStyle = .none
                return oftenStudyCell
            case 2:
                pnumPermitCell.setData(data: UserDefaultsManager.searchable)
                pnumPermitCell.selectionStyle = .none
                return pnumPermitCell
            case 3:
                ageRangeCell.setData(min: UserDefaultsManager.ageMin, max: UserDefaultsManager.ageMax)
                ageRangeCell.selectionStyle = .none
                ageRangeCell.multiSlider.addTarget(self, action: #selector(sliderChangeValue), for: .valueChanged)
                
                return ageRangeCell
            case 4:
                withdrawCell.selectionStyle = .none
                return withdrawCell
            default : return withdrawCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
        } else {
            switch indexPath.row {
            case 4:
                let vc = WithdrawViewController()
                transition(vc, transitionStyle: .presentOverFullScreen)
            default : print("00000")
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

// MARK: - 슬라이드 메서드
extension InfoManageViewController {
    
    @objc func sliderChangeValue() {
        print("슬라이드 값 변경됨!! 이거는 rx input, output으로 해볼까 (Int(self.slider.lower)) ~ (Int(self.slider.upper))")
        // 실시간 연령대 표기는 rx로 해야할듯
    }
    
}

