//
//  profileCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/15/22.
//

import UIKit

final class ProfileCell: BaseTableViewCell {
    
//    lazy var collectionView: UICollectionView = {
//
//        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
//        collectionview.backgroundColor = .lightGray
//        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        return collectionview
//    }()
    
//    private func createLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { [unowned self] section, layoutEnvironment in
//            var config = UICollectionLayoutListConfiguration(appearance: .plain)
//            config.headerMode = .firstItemInSection
//            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
//        }
//    }
    
    // MARK: - property
    let usercardView: UIView = {
       let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorPalette.gray2.cgColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let title1: UILabel = {
        let label = UILabel()
        label.text = "새싹 타이틀"
        label.textColor = UIColor.black
        label.font = CustomFonts.title6_R12()
        label.textAlignment = .left
        return label
    }()
    let titleButton1: UIButton = {
       let button = UIButton()
        button.configuration = UIButton.textButton(title: "좋은 매너")
        return button
    }()
    let titleButton2: UIButton = {
       let button = UIButton()
        button.configuration = UIButton.textButton(title: "정확한 시간 약속")
        return button
    }()
    let titleButton3: UIButton = {
       let button = UIButton()
        button.configuration = UIButton.textButton(title: "빠른 응답")
        return button
    }()
    let titleButton4: UIButton = {
       let button = UIButton()
        button.configuration = UIButton.textButton(title: "친절한 성격")
        return button
    }()
    let titleButton5: UIButton = {
       let button = UIButton()
        button.configuration = UIButton.textButton(title: "능숙한 실력")
        return button
    }()
    let titleButton6: UIButton = {
       let button = UIButton()
        button.configuration = UIButton.textButton(title: "유익한 시간")
        return button
    }()
    
//    let title2 : UILabel = {
//        let label = UILabel()
//        label.text = "하고 싶은 스터디"
//        label.textColor = UIColor.black
//        label.font = CustomFonts.title6_R12()
//        label.textAlignment = .left
//        return label
//    }()
//    let wantedStudy: UIButton = {
//       let button = UIButton()
//        button.configuration = UIButton.textButton(title: "test") // 변경필요
//        button.isEnabled = false
//        return button
//    }()
    
    let title3 : UILabel = {
        let label = UILabel()
        label.text = "새싹 리뷰"
        label.textColor = UIColor.black
        label.font = CustomFonts.title6_R12()
        label.textAlignment = .left
        return label
    }()
    let studyTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "첫 리뷰를 기다리는 중이에요!", attributes: [NSAttributedString.Key.foregroundColor : ColorPalette.gray6])
        textfield.font = CustomFonts.body3_R14()
        textfield.tintColor = .black
        textfield.textAlignment = .left
        textfield.keyboardType = .default
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        return textfield
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        contentView.addSubview(usercardView)
        [title1, titleButton1, titleButton2, titleButton3, titleButton4, titleButton5, titleButton6, title3, studyTextField].forEach {
            usercardView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let btnWidth = (contentView.frame.width - 72) / 2
        let spacing = 16
        
        usercardView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        title1.snp.makeConstraints { make in
            make.top.equalTo(usercardView).offset(spacing)
            make.leading.equalTo(usercardView).offset(spacing)
        }
        titleButton1.snp.makeConstraints { make in
            make.leading.equalTo(usercardView).offset(spacing)
            make.top.equalTo(title1.snp.bottom).offset(16)
            make.width.equalTo(btnWidth)
            make.height.equalTo(32)
        }
        titleButton2.snp.makeConstraints { make in
            make.leading.equalTo(titleButton1.snp.trailing).offset(8)
            make.centerY.equalTo(titleButton1.snp.centerY)
            make.width.equalTo(titleButton1.snp.width)
            make.trailing.equalTo(usercardView).offset(-spacing)
            make.height.equalTo(32)
        }
        titleButton3.snp.makeConstraints { make in
            make.leading.equalTo(usercardView).offset(spacing)
            make.top.equalTo(titleButton1.snp.bottom).offset(16)
            make.width.equalTo(btnWidth)
            make.height.equalTo(32)
        }
        titleButton4.snp.makeConstraints { make in
            make.leading.equalTo(titleButton3.snp.trailing).offset(8)
            make.centerY.equalTo(titleButton3.snp.centerY)
            make.width.equalTo(titleButton3.snp.width)
            make.trailing.equalTo(usercardView).offset(-spacing)
            make.height.equalTo(32)
        }
        titleButton5.snp.makeConstraints { make in
            make.leading.equalTo(usercardView).offset(spacing)
            make.top.equalTo(titleButton3.snp.bottom).offset(16)
            make.width.equalTo(btnWidth)
            make.height.equalTo(32)
        }
        titleButton6.snp.makeConstraints { make in
            make.leading.equalTo(titleButton5.snp.trailing).offset(8)
            make.centerY.equalTo(titleButton5.snp.centerY)
            make.width.equalTo(titleButton5.snp.width)
            make.trailing.equalTo(usercardView).offset(-spacing)
            make.height.equalTo(32)
        }
        
        title3.snp.makeConstraints { make in
            make.leading.equalTo(usercardView).offset(spacing)
            make.top.equalTo(titleButton5.snp.bottom).offset(24)
        }
        studyTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(usercardView).inset(spacing)
            make.top.equalTo(title3.snp.bottom).offset(16)
            make.bottom.equalTo(usercardView).offset(-16)
        }
        
    }
    
}

