//
//  ageRangeCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit
//import MultiSlider

final class AgeRangeCell: BaseTableViewCell {
    
    // MARK: - property
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
        label.textColor = ColorPalette.green
        label.font = CustomFonts.title3_M14()
        label.textAlignment = .right
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

    // MARK: - functions
    override func configure() {
        super.configure()
        [titleLabel, rangeLabel, sliderview].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.top.equalTo(contentView).offset(20)
            make.bottom.equalTo(sliderview.snp.top).offset(-12)
            make.width.equalTo(contentView).multipliedBy(0.5)
        }
        
        rangeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-16)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(60)
        }
        
        sliderview.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.height.equalTo(48)
            make.bottom.equalTo(contentView).offset(-12)
        }
    }
    
}
