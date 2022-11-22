//
//  GenderView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/10/22.
//

import UIKit

final class GenderView: BaseView {
    
    // MARK: - property
    let notiLabel: UILabel = {
        let label = UILabel()
        label.text = "성별을 선택해 주세요"
        label.textColor = .black
        label.font = CustomFonts.display1_R20()
        label.textAlignment = .center
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        label.textColor = ColorPalette.gray7
        label.font = CustomFonts.title2_R16()
        label.textAlignment = .center
        return label
    }()
    
    let manButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.titleAndImageButton(title: "남자", image: "man")
        return button
    }()

    let womanButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.titleAndImageButton(title: "여자", image: "woman")
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.disableButton(title: "다음")
        return button
    }()
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        
        [notiLabel, subLabel, manButton, womanButton, nextButton].forEach {
            self.addSubview($0)
        }
        
        self.manButton.setContentHuggingPriority(.init(rawValue: 999), for: .horizontal)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let btnWidth = (self.frame.width - 42) / 2
        
        notiLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(subLabel.snp.top).offset(-8)
        }
        
        subLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(manButton.snp.top).offset(-32)
        }
        
        manButton.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.width.equalTo(btnWidth)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.bottom.equalTo(nextButton.snp.top).offset(-32)
        }
        
        womanButton.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.width.equalTo(manButton.snp.width)
            make.leading.equalTo(manButton.snp.trailing).offset(12)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.bottom.equalTo(nextButton.snp.top).offset(-32)
        }

        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(1.0)
        }
    }
}
