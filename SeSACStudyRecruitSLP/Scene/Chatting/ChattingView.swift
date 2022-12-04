//
//  ChattingView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/28/22.
//

import UIKit
import SnapKit

final class ChattingView: BaseView {
    
    var chatTextViewHeightConstraint: Constraint?
    
    // MARK: - property
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        view.separatorStyle = .none
        view.allowsSelection = false
        view.rowHeight = UITableView.automaticDimension
        view.backgroundColor = .white
        
        view.register(ChattingTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ChattingTableViewHeader.reuseIdentifier)
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.reuseIdentifier)
        view.register(YourChatTableViewCell.self, forCellReuseIdentifier: YourChatTableViewCell.reuseIdentifier)
        return view
    }()
    
    // text input
    let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.gray1
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    let chatTextView: UITextView = {
        let view = UITextView()
        view.font = CustomFonts.body3_R14()
        view.tintColor = .black
        view.backgroundColor = .clear
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.keyboardType = .default
        view.isScrollEnabled = false
        return view
    }()
    let sendbtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.ImageName.sendInact.rawValue), for: .normal)
        button.tintColor = ColorPalette.gray6
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    // more menu view
    let moreMenuView: UIView = {
       let view = UIView()
        view.layer.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6).cgColor
        return view
    }()
    
    let menuButtonBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let reportButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.moreMenuButton(title: "새싹 신고", image: Constants.ImageName.report.rawValue)

        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.moreMenuButton(title: "스터디 취소", image: Constants.ImageName.cancelFace.rawValue)
        return button
    }()
    let reviewButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.moreMenuButton(title: "리뷰 등록", image: Constants.ImageName.reviewWrite.rawValue)
        return button
    }()
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        
        [tableView, grayView, moreMenuView].forEach {
            self.addSubview($0)
        }
        [chatTextView, sendbtn].forEach {
            grayView.addSubview($0)
        }
        
        moreMenuView.addSubview(menuButtonBackView)
        [reportButton, cancelButton, reviewButton].forEach {
            menuButtonBackView.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        var height = bounds.size.height

        tableView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(grayView.snp.top).offset(-16)
        }
        
        grayView.snp.makeConstraints {
            $0.directionalHorizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.lessThanOrEqualTo(88)
            chatTextViewHeightConstraint = $0.height.greaterThanOrEqualTo(self.chatTextView.contentSize.height + 52).constraint
        }
        sendbtn.snp.makeConstraints {
            $0.centerY.equalTo(grayView.snp.centerY)
            $0.trailing.equalTo(grayView.snp.trailing).offset(-12)
            $0.width.height.equalTo(grayView.snp.width).multipliedBy(0.06)
        }
        chatTextView.snp.makeConstraints {
            $0.leading.equalTo(grayView.snp.leading).offset(12)
            $0.verticalEdges.equalTo(grayView).inset(14)
            $0.trailing.equalTo(sendbtn.snp.leading).offset(-10)
        }
        
        // more menu view
        moreMenuView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(self)
        }
        menuButtonBackView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(width * 0.192)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(menuButtonBackView.snp.top)
            $0.centerX.equalTo(menuButtonBackView.snp.centerX)
            $0.width.equalTo(menuButtonBackView.snp.width).dividedBy(3)
            $0.height.equalTo(menuButtonBackView.snp.height)
        }
        reportButton.snp.makeConstraints {
            $0.top.equalTo(menuButtonBackView.snp.top)
            $0.leading.equalTo(menuButtonBackView.snp.leading)
            $0.trailing.equalTo(cancelButton.snp.leading)
            $0.height.equalTo(menuButtonBackView.snp.height)
        }
        reviewButton.snp.makeConstraints {
            $0.top.equalTo(menuButtonBackView.snp.top)
            $0.trailing.equalTo(menuButtonBackView.snp.trailing)
            $0.leading.equalTo(cancelButton.snp.trailing)
            $0.height.equalTo(menuButtonBackView.snp.height)
        }
        
    }
    
}
