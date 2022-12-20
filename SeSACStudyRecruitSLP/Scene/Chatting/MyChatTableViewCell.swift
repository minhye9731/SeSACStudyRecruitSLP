//
//  MyChatTableViewCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/28/22.
//

import UIKit

final class MyChatTableViewCell: BaseTableViewCell {
    
    // MARK: - property
    lazy var myProfileView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 8
        image.backgroundColor = ColorPalette.whitegreen
        return image
    }()
    
    let myChatLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFonts.body3_R14()
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    let myTimeLabel: UILabel = {
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
        [myProfileView, myChatLabel, myTimeLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        myProfileView.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(12)
            $0.trailing.equalTo(contentView).offset(-16)
            $0.leading.greaterThanOrEqualTo(contentView).offset(95)
        }
        
        myChatLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(myProfileView).inset(10)
            $0.horizontalEdges.equalTo(myProfileView).inset(16)
        }
        
        myTimeLabel.snp.makeConstraints {
            $0.trailing.equalTo(myProfileView.snp.leading).offset(-8)
            $0.bottom.equalTo(myProfileView.snp.bottom)
        }
    }
    
    func setData(data: Chat) {
        myChatLabel.text = data.text
        myTimeLabel.text = data.createdAt
    }
    
}
