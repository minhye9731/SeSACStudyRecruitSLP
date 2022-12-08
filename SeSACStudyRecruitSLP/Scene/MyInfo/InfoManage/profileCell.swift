//
//  profileCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/15/22.
//

import UIKit

final class ProfileCell: BaseTableViewCell {
    
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
        button.isUserInteractionEnabled = false
        return button
    }()
    let titleButton2: UIButton = {
       let button = UIButton()
        button.configuration = UIButton.textButton(title: "정확한 시간 약속")
        button.isUserInteractionEnabled = false
        return button
    }()
    let titleButton3: UIButton = {
       let button = UIButton()
        button.configuration = UIButton.textButton(title: "빠른 응답")
        button.isUserInteractionEnabled = false
        return button
    }()
    let titleButton4: UIButton = {
       let button = UIButton()
        button.configuration = UIButton.textButton(title: "친절한 성격")
        button.isUserInteractionEnabled = false
        return button
    }()
    let titleButton5: UIButton = {
       let button = UIButton()
        button.configuration = UIButton.textButton(title: "능숙한 실력")
        button.isUserInteractionEnabled = false
        return button
    }()
    let titleButton6: UIButton = {
       let button = UIButton()
        button.configuration = UIButton.textButton(title: "유익한 시간")
        button.isUserInteractionEnabled = false
        return button
    }()
    
    // [새싹 찾기]용
    let title2 : UILabel = {
        let label = UILabel()
        label.text = "하고 싶은 스터디"
        label.textColor = UIColor.black
        label.font = CustomFonts.title6_R12()
        label.textAlignment = .left
        return label
    }()
    let wantedStudy: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.layer.borderColor = ColorPalette.gray3.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = CustomFonts.title4_R14()
        button.isUserInteractionEnabled = false
        button.sizeToFit()
        return button
    }()
    //
    
    let title3 : UILabel = {
        let label = UILabel()
        label.text = "새싹 리뷰"
        label.textColor = UIColor.black
        label.font = CustomFonts.title6_R12()
        label.textAlignment = .left
        return label
    }()

    let moreReview : moreReviewButton = {
        let btn = moreReviewButton()
        btn.setImage(UIImage(named: Constants.ImageName.moreArrow.rawValue), for: .normal)
        btn.tintColor = ColorPalette.gray7
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    
    let reviewTextField: UITextField = {
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
        [title1, titleButton1, titleButton2, titleButton3, titleButton4, titleButton5, titleButton6, title2, wantedStudy, title3, moreReview, reviewTextField].forEach {
            usercardView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
//        let wantedStudyWidth = wantedStudy.frame.size.width
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
        
        // [새싹 찾기]용
        title2.snp.makeConstraints {
            $0.top.equalTo(titleButton5.snp.bottom).offset(24)
            $0.leading.equalTo(usercardView).offset(spacing)
        }
        wantedStudy.snp.makeConstraints {
            $0.top.equalTo(title2.snp.bottom).offset(16)
            $0.leading.equalTo(usercardView).offset(spacing)
            $0.height.equalTo(32)
            $0.width.equalTo(100)
        }
        //
        
        title3.snp.makeConstraints { make in
            make.leading.equalTo(usercardView).offset(spacing)
            make.top.equalTo(wantedStudy.snp.bottom).offset(24)
        }
        
        moreReview.snp.makeConstraints {
            $0.trailing.equalTo(usercardView).offset(-16)
            $0.centerY.equalTo(title3.snp.centerY)
            $0.width.height.equalTo(usercardView.snp.width).multipliedBy(0.046)
        }
        
        reviewTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(usercardView).inset(spacing)
            make.top.equalTo(title3.snp.bottom).offset(16)
            make.bottom.equalTo(usercardView).offset(-16)
        }
        
    }
    
    // [my info] 정리 필요
    func setData() {
        title2.isHidden = true
        wantedStudy.isHidden = true
        
        var result = UserDefaultsManager.reputation
        var btnGroup = [titleButton1, titleButton2, titleButton3, titleButton4, titleButton5, titleButton6]
        
        for i in 0...5 {
            
            let bgClr: UIColor = result[i] == 0 ? .white : ColorPalette.green
            let brClr: UIColor = result[i] == 0 ? ColorPalette.gray4 : ColorPalette.green
            let txClr: UIColor = result[i] == 0 ? .black : .white
            
            btnGroup[i].configuration?.baseBackgroundColor = bgClr
            btnGroup[i].configuration?.background.strokeColor = brClr
            btnGroup[i].configuration?.attributedTitle?.foregroundColor = txClr
        }
        
        if UserDefaultsManager.comment.isEmpty {
            reviewTextField.placeholder = "첫 리뷰를 기다리는 중이에요!"
        } else {
            reviewTextField.text = UserDefaultsManager.comment[0] as? String
        }
    }
    
    // [새싹 찾기]
    func setSesacData(data: [FromQueueDB], section: Int) {
        print("화면에 보여줄 검색된 새싹정보 : \(data)")
        
        var reputationList = data[section].reputation
        var reviewList = data[section].reviews
        var btnGroup = [titleButton1, titleButton2, titleButton3, titleButton4, titleButton5, titleButton6]
        
        for i in 0...5 {
            if reputationList[i] != 0 {
                btnGroup[i].configuration?.baseBackgroundColor = ColorPalette.green
                btnGroup[i].configuration?.background.strokeColor = ColorPalette.green
                btnGroup[i].configuration?.attributedTitle?.foregroundColor = .white
            }
            btnGroup[i].configuration?.baseBackgroundColor = .white
            btnGroup[i].configuration?.background.strokeColor = ColorPalette.gray4
            btnGroup[i].configuration?.attributedTitle?.foregroundColor = .black
        }
        
        let study = data[section].studylist.isEmpty ? "아무거나" : data[section].studylist[0]
        wantedStudy.setTitle(study, for: .normal)
        
//        let wantedStudyWidth = wantedStudy.frame.size.width
//        wantedStudy.snp.makeConstraints {
//            $0.width.equalTo(wantedStudyWidth + 32)
//        }
        
        reviewList.isEmpty ? (reviewTextField.placeholder = "첫 리뷰를 기다리는 중이에요!") : (reviewTextField.text = reviewList[0])
        reviewList.isEmpty ? (moreReview.isHidden = true) : (moreReview.isHidden = false)
    }
    
    override func prepareForReuse() {
        
        titleButton1.setImage(nil, for: .normal)
        titleButton2.setImage(nil, for: .normal)
        titleButton3.setImage(nil, for: .normal)
        titleButton4.setImage(nil, for: .normal)
        titleButton5.setImage(nil, for: .normal)
        titleButton6.setImage(nil, for: .normal)
        
        wantedStudy.setTitle(nil, for: .normal)
        
        reviewTextField.text = nil
    }

}

