//
//  InfoManageViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

final class InfoManageViewController: BaseViewController {
    
    // MARK: - property
    let mainView = InfoManageView()
    var isExpanded = false
    var updateData = UserInfoUpdateDTO(searchable: 0, ageMin: 0, ageMax: 0, gender: 0, study: "")
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func loadView()  {
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
        let result = ((view.frame.width - 32) * 0.597) + 58
        return section == 0 ? result : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.reuseIdentifier) as? CollapsibleTableViewHeader else { return UIView() }
        
        headerView.setData(bgNum: UserDefaultsManager.background,
                           fcNum: UserDefaultsManager.sesac,
                           name: UserDefaultsManager.nick)
        headerView.setCollapsed(isExpanded)
        headerView.section = section
        headerView.askAcceptbtn.isHidden = true

        headerView.namebtn.addTarget(self, action: #selector(headerNameTapped), for: .touchUpInside)
        headerView.namebtn.header = headerView
        headerView.namebtn.section = section

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
            
//            profileCell.title2.isHidden = true // my info에서는 안보이도록
//            profileCell.wantedStudy.isHidden = true // my info에서는 안보이도록
            profileCell.setData()
//            profileCell.setSesacData(data: pageboyPageIndex == 0 ? aroundSesacList : receivedSesacList, section: indexPath.section)
            
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
                let vc = PopUpViewController()
                vc.popupMode = .withdraw
                transition(vc, transitionStyle: .presentOverFullScreen)
            default : print("00000")
            }
        }
    }
    
}

// MARK: - 접었다폈다 로직
extension InfoManageViewController {
    
//    @objc func headerTapped(sender: UserCardNameTapGestureRecognizer) {
//        guard let header = sender.header else { return }
//        guard let section = sender.section else { return }
//
//        isExpanded.toggle()
//        header.setCollapsed(isExpanded)
//        header.setData(bgNum: UserDefaultsManager.background, fcNum: UserDefaultsManager.sesac, name: UserDefaultsManager.nick)
//
//        mainView.tableView.reloadData()
//    }
    
    @objc func headerNameTapped(sender: HeaderSectionPassButton) {
        guard let header = sender.header else { return }
        guard let section = sender.section else { return }
        
        print("\(section)번째 유저카드 클릭!!")
        
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
        print("내정보 관리 저장 클릭")
        
        let api = APIRouter.update(
            searchable: String(updateData.searchable),
            ageMin: String(updateData.ageMin),
            ageMax: String(updateData.ageMax),
            gender: String(updateData.gender),
            study: updateData.study
        )
        
        Network.share.requestForResponseString(router: api) { [weak self] response in
            switch response {
            case .success:
                print("수정한 사용자정보 업데이트 완료!")
                self?.mainView.makeToast("내정보 저장이 완료되었습니다.", duration: 0.5, position: .center)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = SignupError(rawValue: code) else { return }
                print("failure // code = \(code), errorCode = \(errorCode)")
                
                switch errorCode {
                case .fbTokenError:
                    self?.refreshIDToken()
                default :
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
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
                    self.mainView.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
                }
                return
            } else if let idToken = idToken {
                UserDefaultsManager.idtoken = idToken
                print("🦄갱신된 idToken 저장완료 |  UserDefaultsManager.idtoken = \(UserDefaultsManager.idtoken)")
                let api = APIRouter.update(
                    searchable: String(self.updateData.searchable),
                    ageMin: String(self.updateData.ageMin),
                    ageMax: String(self.updateData.ageMax),
                    gender: String(self.updateData.gender),
                    study: self.updateData.study
                )
                
                Network.share.requestForResponseString(router: api) { [weak self] response in
                    switch response {
                    case .success:
                        print("수정한 사용자정보 업데이트 완료!")
                        self?.mainView.makeToast("내정보 저장이 완료되었습니다.", duration: 0.5, position: .center)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = SignupError(rawValue: code) else { return }
                        print("failure // code = \(code), errorCode = \(errorCode)")
                        
                        switch errorCode {
                        default :
                            self?.showAlertMessage(title: "서버에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)")
                        }
                    }
                }
            }
        }
    }
    
}
