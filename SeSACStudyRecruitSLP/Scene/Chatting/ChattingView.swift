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
        let view = UITableView()
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        view.separatorStyle = .none
        view.allowsSelection = false
        
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.rowHeight = UITableView.automaticDimension
        
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.reuseIdentifier)
        view.register(YourChatTableViewCell.self, forCellReuseIdentifier: YourChatTableViewCell.reuseIdentifier)
        return view
    }()
    
    let matchingDateLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFonts.title5_M12()
        label.numberOfLines = 1
        label.textColor = .white
        label.text = "0월 00일 0요일" // test
        label.textAlignment = .center
        label.backgroundColor = ColorPalette.gray7
        label.layer.masksToBounds = true
        return label
    }()
    
    //stack
    let bellImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: Constants.ImageName.bell.rawValue)
        img.contentMode = .scaleAspectFit
        img.tintColor = ColorPalette.gray7
        return img
    }()
    let matchingSesacLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFonts.title3_M14()
        label.numberOfLines = 1
        label.textColor = ColorPalette.gray7
        label.text = "ㅇㅇㅇ님과 매칭되었습니다" // test
        return label
    }()
    let matchingSesacStackView: UIStackView = {
       let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.backgroundColor = .clear
        view.spacing = 8
        return view
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFonts.title4_R14()
        label.numberOfLines = 1
        label.textColor = ColorPalette.gray6
        label.text = "채팅을 통해 약속을 정해보세요 :)"
        return label
    }()
    
    // 입력창
    let inputTextView: UIView = {
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
        
        [matchingDateLabel, matchingSesacStackView, subLabel, tableView, inputTextView] .forEach {
            self.addSubview($0)
        }
        matchingDateLabel.layer.cornerRadius = width * 0.3 * 0.245 * 0.5

        [bellImage, matchingSesacLabel].forEach { matchingSesacStackView.addArrangedSubview($0)
        }

        [chatTextField, sendbtn].forEach {
            inputTextView.addSubview($0)
        }
    }
    
    
    override func setConstraints() {
        super.setConstraints()
        
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        
        matchingDateLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(width * 0.3)
            $0.height.equalTo(matchingDateLabel.snp.width).multipliedBy(0.245)
        }
        
        matchingSesacStackView.snp.makeConstraints {
            $0.top.equalTo(matchingDateLabel.snp.bottom).offset(12)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(matchingSesacStackView.snp.bottom).offset(2)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(inputTextView.snp.top).offset(-12)
        }

        inputTextView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(width * 0.14)
        }
        
        sendbtn.snp.makeConstraints {
            $0.trailing.equalTo(inputTextView.snp.trailing).offset(-12)
            $0.verticalEdges.equalTo(inputTextView).inset(14)
            $0.width.equalTo(sendbtn.snp.height)
        }
        
        chatTextField.snp.makeConstraints {
            $0.leading.equalTo(inputTextView.snp.leading).offset(12)
            $0.verticalEdges.equalTo(inputTextView).inset(14)
            $0.trailing.equalTo(sendbtn.snp.leading).offset(-10)
        }
    }
    
    
    
    
}
