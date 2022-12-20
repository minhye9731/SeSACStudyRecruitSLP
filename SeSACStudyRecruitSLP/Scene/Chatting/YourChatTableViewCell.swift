//
//  YourChatTableViewCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/28/22.
//

import UIKit

final class YourChatTableViewCell: BaseTableViewCell {
    
    // MARK: - property
    lazy var yourProfileView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 8
        image.backgroundColor = .white
        image.layer.borderWidth = 1
        image.layer.borderColor = ColorPalette.gray4.cgColor
        return image
    }()
    
    let yourChatLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFonts.body3_R14()
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    let yourTimeLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFonts.title6_R12()
        label.numberOfLines = 1
        label.text = "13:55" //test
        label.textColor = ColorPalette.gray6
        return label
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        self.selectionStyle = .none
        [yourProfileView, yourChatLabel, yourTimeLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        yourProfileView.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(12)
            $0.leading.equalTo(contentView).offset(16)
            $0.trailing.lessThanOrEqualTo(contentView).offset(-95)
        }
        
        yourChatLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(yourProfileView).inset(10)
            $0.horizontalEdges.equalTo(yourProfileView).inset(16)
        }
        
        yourTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(yourProfileView.snp.trailing).offset(8)
            $0.bottom.equalTo(yourProfileView.snp.bottom)
        }
    }
    
    func setData(data: Chat) {
        yourChatLabel.text = data.text
        setTimeForm(time: data.createdAt)
    }
    
    func setTimeForm(time: String) {
        let value = time.toDate()
        let chattingDate = Calendar.current.dateComponents([.year, .month, .day], from: value)
        let todayDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        if (chattingDate.year == todayDate.year) && (chattingDate.year == todayDate.year) && (chattingDate.year == todayDate.year) {
            yourTimeLabel.text = time.todayChatForm().todayChatForm()
        } else {
            yourTimeLabel.text = time.notTodayChatForm().notTodayChatForm()
        }
    }
}

