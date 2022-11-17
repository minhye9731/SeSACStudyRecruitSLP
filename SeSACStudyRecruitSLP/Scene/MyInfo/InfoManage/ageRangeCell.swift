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
    
    let multiSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.minValue = 18
        slider.maxValue = 65
        slider.lower = 18
        slider.upper = 65
        return slider
    }()
    
    let sliderview: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    // MARK: - functions
    override func configure() {
        super.configure()
        [titleLabel, rangeLabel, sliderview].forEach {
            contentView.addSubview($0)
        }
        sliderview.addSubview(multiSlider)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(16)
            $0.top.equalTo(contentView).offset(20)
            $0.bottom.equalTo(sliderview.snp.top).offset(-12)
            $0.width.equalTo(contentView).multipliedBy(0.5)
        }
        
        rangeLabel.snp.makeConstraints {
            $0.trailing.equalTo(contentView).offset(-16)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.width.equalTo(60)
        }
        
        sliderview.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contentView).inset(12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.height.equalTo(48)
            $0.bottom.equalTo(contentView).offset(-12)
        }
        
        multiSlider.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.horizontalEdges.equalTo(sliderview).inset(13)
            $0.centerY.equalTo(sliderview.snp.centerY)
        }
    }
    
    func setData(min: Int, max: Int) {
        rangeLabel.text = "\(min) - \(max)"
        
        multiSlider.lower = Double(min)
        multiSlider.upper = Double(max)
        
//        (Int(self.slider.lower)) ~ (Int(self.slider.upper))")
    }
    
}
