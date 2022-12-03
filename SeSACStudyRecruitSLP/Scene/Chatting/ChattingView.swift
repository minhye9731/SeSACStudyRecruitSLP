//
//  ChattingView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/28/22.
//

import UIKit

final class ChattingView: BaseView {
    
    // MARK: - property
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        view.separatorStyle = .none
        view.allowsSelection = false
        
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.rowHeight = UITableView.automaticDimension
        
        view.register(ChattingTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ChattingTableViewHeader.reuseIdentifier)
        
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.reuseIdentifier)
        view.register(YourChatTableViewCell.self, forCellReuseIdentifier: YourChatTableViewCell.reuseIdentifier)
        return view
    }()
    
    let chatInputView: UIView = {
        let view = UIView()
        return view
    }()
    
    let grayTextView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.gray1
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    lazy var chatTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "메세지를 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.gray7])
        textfield.font = CustomFonts.body3_R14()
        textfield.tintColor = .black
        textfield.textAlignment = .left
        textfield.keyboardType = .default
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.backgroundColor = .clear
        return textfield
    }()
    let sendbtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.ImageName.sendInact.rawValue), for: .normal)
        button.tintColor = ColorPalette.gray6
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        
        [tableView, chatInputView] .forEach {
            self.addSubview($0)
        }
        [grayTextView, chatTextField, sendbtn].forEach {
            chatInputView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        var height = bounds.size.height

        tableView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(chatInputView.snp.top)
        }

        chatInputView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(height * 0.08)
        }
        
        grayTextView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(chatInputView).inset(16)
            $0.top.equalTo(chatInputView.snp.top).offset(4)
            $0.height.equalTo(width * 0.14)
        }
        
        sendbtn.snp.makeConstraints {
            $0.trailing.equalTo(grayTextView.snp.trailing).offset(-12)
            $0.verticalEdges.equalTo(grayTextView).inset(14)
            $0.width.equalTo(sendbtn.snp.height)
        }
        
        chatTextField.snp.makeConstraints {
            $0.leading.equalTo(grayTextView.snp.leading).offset(12)
            $0.verticalEdges.equalTo(grayTextView).inset(14)
            $0.trailing.equalTo(sendbtn.snp.leading).offset(-10)
        }
    }
    
}
