//
//  SplashView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/9/22.
//

import UIKit

class SplashView: BaseView {
    
    // MARK: - property
    let notiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let introImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        backgroundColor = .red
        
        [notiLabel, introImage].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        introImage.snp.makeConstraints {
            $0.centerY.equalTo(safeAreaLayoutGuide).multipliedBy(1.2)
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(introImage.snp.width)
        }
        
        notiLabel.snp.makeConstraints {
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(74)
            $0.centerY.equalTo(safeAreaLayoutGuide).multipliedBy(0.4)
        }
    }
    
    func setData(text: String, image: String) {
        notiLabel.text = text
        introImage.image = UIImage(named: image)
    }
}
