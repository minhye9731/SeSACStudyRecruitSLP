//
//  ListViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import Tabman

final class ListViewController: BaseViewController {
    
    // MARK: - property
    let mainView = ListView()
    var aroundOrAccepted: SearchMode = .aroundSesac
    
    //test용 더미데이터
    var searchCoordinate = UserLocationDTO(lat: 37.517819364682694, long: 126.88647317074734) // 화면 넘어올떄 받아주는 값
    var isExpandedList = [false, false, false, false, false, false, false, false, false, false] // teset
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("🔥\(pageboyPageIndex.self)")
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        configureEmptyView()
        
        // 분기처리 로직은 추후에. 일단 하드코딩으로 확인하자
        mainView.emptyView.isHidden = true
        mainView.tableView.isHidden = false
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
    }
    
    // empty view 요소
    func configureEmptyView() {
        mainView.emptyView.mainNotification.text = pageboyPageIndex == 0 ? "아쉽게도 주변에 새싹이 없어요ㅠ" : "아직 받은 요청이 없어요ㅠ"
        mainView.emptyView.refreshBtn.addTarget(self, action: #selector(refreshBtnTapped), for: .touchUpInside)
        mainView.emptyView.studyChangeBtn.addTarget(self, action: #selector(studyChangeBtnTapped), for: .touchUpInside)
    }

    
}
// MARK: - tableview
extension ListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10 // pageboyPageIndex == 0 ? 10 : 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isExpandedList[section] ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let result = ((view.frame.width - 32) * 0.6) + 58
        return result
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView,
              let visible = tableView.indexPathsForVisibleRows,
              let first = visible.first else {
            return
        }

        let headerHeight = tableView.rectForHeader(inSection: first.section).size.height
        let offset =  max(min(0, -tableView.contentOffset.y), -headerHeight)
        self.mainView.tableView.contentInset = UIEdgeInsets(top: offset, left: 0, bottom: -offset, right: 0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.reuseIdentifier) as? CollapsibleTableViewHeader else { return UIView() }
        
        headerView.setData(bgNum: 4, // Test
                           fcNum: 3, // Test
                           name: "양배추즙") // Test
        
        // headerview에 section, func 연결
        headerView.setCollapsed(isExpandedList[section])
        headerView.section = section
        
        // 버튼
        headerView.askAcceptbtn.addTarget(self, action: #selector(askAcceptbtnTapped), for: .touchUpInside)
        headerView.namebtn.addTarget(self, action: #selector(headerNameTapped), for: .touchUpInside)
        // 버튼에 header,section를 전달
        headerView.askAcceptbtn.header = headerView
        headerView.askAcceptbtn.section = section
        headerView.namebtn.header = headerView
        headerView.namebtn.section = section
        
        // 버튼 색상 구분
        headerView.setAskAcceptBtn(page: pageboyPageIndex!)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseIdentifier) as? ProfileCell else { return UITableViewCell() }
        
        profileCell.selectionStyle = .none
        profileCell.setData()
        return profileCell
    }
}

// MARK: - 기타 함수
extension ListViewController {
    
    @objc func askAcceptbtnTapped(sender: HeaderSectionPassButton) {
        guard let header = sender.header else { return }
        guard let section = sender.section else { return }
        print("\(section)번째 요청하기 or 수락하기 버튼 클릭")
        
        let vc = WithdrawViewController()
        // 누구껀지를 알아야 함
        transition(vc, transitionStyle: .presentOverFullScreen)
    }
    
    @objc func headerNameTapped(sender: HeaderSectionPassButton) {
        guard let header = sender.header else { return }
        guard let section = sender.section else { return }
        
        print("\(section)번째 유저카드 클릭!!")
        
        isExpandedList[section].toggle()
        header.setCollapsed(isExpandedList[section])
        mainView.tableView.reloadData()
    }
    
    
    @objc func studyChangeBtnTapped() {
        print("스터디 변경하기 버튼 눌림")
    }
    
    
    @objc func refreshBtnTapped() {
        print("새로고침 버튼 눌림")
        self.navigationController?.popViewController(animated: true)
    }
    
}
