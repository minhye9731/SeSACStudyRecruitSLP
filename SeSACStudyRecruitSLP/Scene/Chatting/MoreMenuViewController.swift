//
//  MoreMenuViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/28/22.
//

import UIKit

final class MoreMenuViewController: BaseViewController {
    
    let moreMenuStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillEqually
        view.backgroundColor = .white
        return view
    }()
    let reportButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.moreMenuButton(title: "새싹 신고", image: Constants.ImageName.report.rawValue)
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.moreMenuButton(title: "스터디 취소", image: Constants.ImageName.cancelFace.rawValue)
        return button
    }()
    let reviewButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.moreMenuButton(title: "리뷰 등록", image: Constants.ImageName.reviewWrite.rawValue)
        return button
    }()
    
    
    override func configure() {
        super.configure()
        
        view.layer.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6).cgColor
        
        view.addSubview(moreMenuStackView)
        [reportButton, cancelButton, reviewButton].forEach {
            moreMenuStackView.addArrangedSubview($0)
        }
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        reviewButton.addTarget(self, action: #selector(reviewButtonTapped), for: .touchUpInside)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        
        moreMenuStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(width * 0.192)
        }
    }
    
}

// MARK: - 기타
extension MoreMenuViewController {
    
    @objc func cancelButtonTapped() {
        print("취소버튼 눌림")
    }
    
    @objc func reviewButtonTapped() {
        print("리뷰작성 눌림")
        let vc = WriteReviewViewController()
        transition(vc, transitionStyle: .presentOverFullScreen)
    }
    
    
}






