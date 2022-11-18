//
//  InfoManageViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit
import RxSwift
import RxCocoa

final class InfoManageViewController: BaseViewController {
    
    // MARK: - property
    let mainView = InfoManageView()
    var isExpanded = false
    var updateData = UserInfoUpdateDTO(searchable: 0, ageMin: 0, ageMax: 0, gender: 0, study: "")
    let disposeBag = DisposeBag()

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
                genderCell.setData(data: updateData.gender)
                genderCell.manButton.addTarget(self, action: #selector(manButtonTapped), for: .touchUpInside)
                genderCell.womanButton.addTarget(self, action: #selector(womanButtonTapped), for: .touchUpInside)
                genderCell.selectionStyle = .none
                return genderCell
            case 1:
                oftenStudyCell.setData(data: updateData.study)
                oftenStudyCell.studyTextField.delegate = self
                oftenStudyCell.selectionStyle = .none
                return oftenStudyCell
            case 2:
                pnumPermitCell.setData(data: updateData.searchable)
                pnumPermitCell.switcher.addTarget(self, action: #selector(switcherTapped), for: .valueChanged)
                pnumPermitCell.selectionStyle = .none
                return pnumPermitCell
            case 3:
                ageRangeCell.setData(min: updateData.ageMin, max: updateData.ageMax)
                bindData(slider: ageRangeCell.multiSlider)
                ageRangeCell.selectionStyle = .none
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

// MARK: - 성별버튼 클릭
extension InfoManageViewController {
    
    @objc func womanButtonTapped() {
        updateData.gender = 0
        mainView.tableView.reloadData()
    }
    
    @objc func manButtonTapped() {
        updateData.gender = 1
        mainView.tableView.reloadData()
    }

}

// MARK: - 자주하는 스터디
extension InfoManageViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let result = textField.text else { return }
        print("입력하는 키워드 = \(result)")
        updateData.study = result
        if result.count > 15 { textField.deleteBackward() }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - 번호검색 허용
extension InfoManageViewController {
    @objc func switcherTapped() {
        updateData.searchable = updateData.searchable == 0 ? 1 : 0
        print(updateData)
        mainView.tableView.reloadData()
    }
}

// MARK: - 슬라이드 메서드
extension InfoManageViewController {
    
    func bindData(slider: CustomSlider) {
        slider.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .bind { (vc, _) in
                vc.updateData.ageMin = Int(slider.lower)
                vc.updateData.ageMax = Int(slider.upper)
                print(self.updateData)
            }
            .disposed(by: disposeBag)
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
