//
//  EmptyView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit

class EmptyView: BaseView {
    
    // MARK: - property
    let sesacImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Constants.ImageName.graySesac.rawValue)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let mainNotification: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = CustomFonts.display1_R20()
        label.textAlignment = .center
        return label
    }()
    let subNotification: UILabel = {
        let label = UILabel()
        label.text = "스터디를 변경하거나 조금만 더 기다려 주세요!"
        label.textColor = ColorPalette.gray7
        label.font = CustomFonts.title4_R14()
        label.textAlignment = .center
        return label
    }()
    
    let studyChangeBtn: UIButton = {
        let button = UIButton.generalButton(title: "스터디 변경하기", textcolor: .white, bgcolor: ColorPalette.green, font: CustomFonts.body3_R14())
        button.layer.cornerRadius = 8
        return button
    }()
    let refreshBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.ImageName.refresh.rawValue), for: .normal)
        button.tintColor = ColorPalette.green
        button.backgroundColor = .white
        button.layer.borderColor = ColorPalette.green.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        [sesacImage, mainNotification, subNotification, studyChangeBtn, refreshBtn].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        var bounds = UIScreen.main.bounds
        var widthWithoutSpace = bounds.size.width - 40
        
        sesacImage.snp.makeConstraints {
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
            $0.width.height.equalTo(64)
            $0.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.7)
        }
        
        mainNotification.snp.makeConstraints {
            $0.top.equalTo(sesacImage.snp.bottom).offset(32)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
        }
        subNotification.snp.makeConstraints {
            $0.top.equalTo(mainNotification.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(30)
        }
        
        refreshBtn.snp.makeConstraints {
            $0.trailing.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            $0.width.height.equalTo(widthWithoutSpace * 0.14)
        }
        
        studyChangeBtn.snp.makeConstraints {
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            $0.height.equalTo(refreshBtn.snp.height)
            $0.trailing.equalTo(refreshBtn.snp.leading).offset(-8)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
    }
    
}
