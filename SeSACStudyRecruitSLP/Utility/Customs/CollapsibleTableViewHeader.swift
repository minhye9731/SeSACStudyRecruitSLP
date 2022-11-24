//
//  CollapsibleTableViewHeader.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/16/22.
//

import UIKit
import SnapKit

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    
    // MARK: - property
    var section: Int = 0
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    let sesacImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let nameView: UIView = {
       let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorPalette.gray2.cgColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let namebtn: HeaderSectionPassButton = {
       let btn = HeaderSectionPassButton()
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        return btn
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    let updownButton: UIButton = {
       let btn = UIButton()
        btn.tintColor = ColorPalette.gray7
        return btn
    }()
    
    let askAcceptbtn: HeaderSectionPassButton = {
        let btn = HeaderSectionPassButton()
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("요청하기", for: .normal)
        btn.titleLabel?.font = CustomFonts.title3_M14()
        btn.backgroundColor = ColorPalette.error
        btn.layer.cornerRadius = 8
        return btn
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
        [backgroundImage, nameView, namebtn, askAcceptbtn].forEach {
            contentView.addSubview($0)
        }
        
        [sesacImage].forEach {
            backgroundImage.addSubview($0)
        }
        
        [nameLabel, updownButton].forEach {
            nameView.addSubview($0)
        }
    }
    
    func setConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(backgroundImage.snp.width).multipliedBy(0.6)
        }
        sesacImage.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundImage.snp.centerX)
            make.centerY.equalTo(backgroundImage.snp.centerY).multipliedBy(1.3)
            make.width.equalTo(backgroundImage.snp.width).multipliedBy(0.4)
            make.height.equalTo(sesacImage.snp.width)
        }
        askAcceptbtn.snp.makeConstraints {
            $0.top.equalTo(backgroundImage.snp.top).offset(12)
            $0.trailing.equalTo(backgroundImage.snp.trailing).offset(-12)
            $0.width.equalTo(backgroundImage.snp.width).multipliedBy(0.23)
            $0.height.equalTo(askAcceptbtn.snp.width).multipliedBy(0.5)
        }
        
        nameView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImage.snp.bottom)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(58)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameView.snp.centerY)
            make.leading.equalTo(nameView.snp.leading).offset(16)
            make.trailing.equalTo(updownButton.snp.leading).offset(-8)
        }
        updownButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameView.snp.centerY)
            make.trailing.equalTo(nameView.snp.trailing).offset(-16)
            make.width.height.equalTo(16)
        }
        namebtn.snp.makeConstraints { make in
            make.edges.equalTo(nameView)
        }
    }
    
    func setCollapsed(_ collapsed: Bool) {
        updownButton.setImage(UIImage(systemName: collapsed ? "chevron.down" : "chevron.up" ), for: .normal)
    }
    
    func setData(bgNum: Int, fcNum: Int, name: String) {
        backgroundImage.image = UIImage(named: "sesac_background_\(bgNum + 1)")
        sesacImage.image = UIImage(named: "sesac_face_\(fcNum + 1)")
        nameLabel.text = name
    }
    
    // 화면종류별 요청하기&수락하기 문구와 색상 구분
    func setAskAcceptBtn(page: Int) {
        askAcceptbtn.setTitle(page == 0 ? "요청하기" : "수락하기", for: .normal)
        askAcceptbtn.backgroundColor = page == 0 ? ColorPalette.error : ColorPalette.success
    }
    
    
    
    
}
