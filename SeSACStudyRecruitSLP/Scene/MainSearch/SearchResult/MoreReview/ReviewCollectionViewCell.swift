//
//  ReviewCollectionViewCell.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/27/22.
//

import UIKit

class ReviewCollectionViewCell: BaseCollectionViewCell {
    
    let reviewLabel: UILabel = {
       let label = UILabel()
        label.font = CustomFonts.title4_R14()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = ColorPalette.gray2
        return view
    }()
    
    var showSeparator = true {
        didSet {
            updateSeparator()
        }
    }
    
    override func configure() {
        super.configure()
        
        [reviewLabel, separatorView].forEach {
            contentView.addSubview($0)
        }
        contentView.backgroundColor = .white
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        reviewLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(16)
        }
        
        separatorView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contentView).inset(16)
            $0.height.equalTo(1)
            $0.bottom.equalTo(contentView)
        }
    }
    
    func updateSeparator() {
        separatorView.isHidden = !showSeparator
    }
    
}
