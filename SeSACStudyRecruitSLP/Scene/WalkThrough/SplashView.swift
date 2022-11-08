//
//  SplashView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/9/22.
//

import UIKit

class SplashView: BaseView {
    
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
    
    override func configureUI() {
        super.configureUI()
        
        [notiLabel, introImage].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        introImage.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-50)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.height.width.equalTo(360)
        }
        
        notiLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(74)
            make.bottom.equalTo(self.introImage.snp.top).offset(-56)
        }
    }
    
    func setData(text: String, image: String) {
        notiLabel.text = text
        introImage.image = UIImage(named: image)
    }
    
    
    
}
