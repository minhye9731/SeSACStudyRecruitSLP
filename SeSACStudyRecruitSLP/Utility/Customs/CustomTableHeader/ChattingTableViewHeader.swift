//
//  ChattingTableViewHeader.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/2/22.
//

import UIKit
import SnapKit

class ChattingTableViewHeader: UITableViewHeaderFooterView {
    
    // MARK: - property
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
    
    // MARK: - init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - functions
    func configure() {
        
        self.backgroundColor = .blue
        
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        
        [matchingDateLabel, matchingSesacStackView, subLabel] .forEach {
            contentView.addSubview($0)
        }
        matchingDateLabel.layer.cornerRadius = width * 0.3 * 0.245 * 0.5

        [bellImage, matchingSesacLabel].forEach { matchingSesacStackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
            
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        
        matchingDateLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.centerX.equalTo(contentView)
            $0.width.equalTo(width * 0.3)
            $0.height.equalTo(matchingDateLabel.snp.width).multipliedBy(0.245)
        }
        
        matchingSesacStackView.snp.makeConstraints {
            $0.top.equalTo(matchingDateLabel.snp.bottom).offset(12)
            $0.centerX.equalTo(contentView)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(matchingSesacStackView.snp.bottom).offset(2)
            $0.centerX.equalTo(contentView)
        }
        
    }
        
    // 데이터 전달 함수 예정
    
}
