//
//  pnumPermitCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit

final class PnumPermitCell: BaseTableViewCell {
    
    // MARK: - property
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 번호 검색 허용"
        label.textColor = UIColor.black
        label.font = CustomFonts.title4_R14()
        label.textAlignment = .left
        return label
    }()
    
    let switcher: UISwitch = {
       let switcher = UISwitch()
        switcher.onTintColor = ColorPalette.green
        
        return switcher
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        [titleLabel, switcher].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.centerY.equalTo(switcher.snp.centerY)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.5)
        }
        
        switcher.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.height.equalTo(28)
            make.width.equalTo(52)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(contentView).offset(-16)
        }
    }
    
    func setData(data: Int) {
        switcher.isOn = data == 0 ? false : true
    }
    
}
