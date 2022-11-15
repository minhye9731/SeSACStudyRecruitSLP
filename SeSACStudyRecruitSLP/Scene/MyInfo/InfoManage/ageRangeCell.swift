//
//  ageRangeCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit
//import MultiSlider

final class ageRangeCell: BaseTableViewCell {
    
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
    

    
    override func configure() {
        super.configure()
        [titleLabel, rangeLabel ].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide)
            make.centerY.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.5)
        }
        

    }
    
}
