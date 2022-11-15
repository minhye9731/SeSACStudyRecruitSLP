//
//  ageRangeCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit
//import MultiSlider

final class AgeRangeCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "상대방 연령대"
        label.textColor = UIColor.black
        label.font = CustomFonts.title4_R14()
        label.textAlignment = .left
        return label
    }()
    
    let rangeLabel: UILabel = {
        let label = UILabel()
        label.text = "00 - 00" // test
        label.textColor = UIColor.black
        label.font = CustomFonts.title3_M14()
        label.textAlignment = .left
        return label
    }()
    
//    let slider: MultiSlider = {
//        let slider = MultiSlider()
//        slider.orientation = .horizontal
//        slider.minimumValue = 0.0
//        slider.maximumValue = 1.0
//
//        return slider
//    }()
    
    let sliderview: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    
    override func configure() {
        super.configure()
        [titleLabel, rangeLabel, sliderview].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.5)
        }
        
        rangeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(60)
        }
        
//        slider.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
//
//        }
        
        sliderview.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.height.equalTo(48)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-12)
        }
        
        

    }
    
}
