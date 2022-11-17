//
//  CollapsibleTableViewHeader.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/16/22.
//

import UIKit
import SnapKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    
    // MARK: - property
    var delegate: CollapsibleTableViewHeaderDelegate?
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
    let nameLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    let updownButton: UIButton = {
       let btn = UIButton()
        btn.tintColor = ColorPalette.gray7
        return btn
    }()
    
    
    // MARK: - init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:))))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - functions
    func configure() {
        [backgroundImage, nameView].forEach {
            contentView.addSubview($0)
        }
        backgroundImage.addSubview(sesacImage)
        [nameLabel, updownButton].forEach {
            nameView.addSubview($0)
        }
    }
    
    func setConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(backgroundImage.snp.width).multipliedBy(0.58)
        }
        sesacImage.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundImage.snp.centerX)
            make.centerY.equalTo(backgroundImage.snp.centerY).multipliedBy(1.3)
            make.width.equalTo(backgroundImage.snp.width).multipliedBy(0.4)
            make.height.equalTo(sesacImage.snp.width)
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
    }
    
    @objc func headerTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else { return }
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        updownButton.setImage(UIImage(systemName: collapsed ? "chevron.down" : "chevron.up" ), for: .normal)
    }
    
    func setData(bgNum: Int, fcNum: Int, name: String) {
        backgroundImage.image = UIImage(named: "sesac_background_\(bgNum + 1)")
        sesacImage.image = UIImage(named: "sesac_face_\(fcNum + 1)")
        nameLabel.text = name
    }
    
}
