//
//  LaunchScreenViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/17/22.
//

import UIKit

final class LaunchScreenViewController: BaseViewController {
    
    // MARK: - property
    let iconImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Constants.ImageName.splashLogo.rawValue)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let logoLabelView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: Constants.ImageName.splashText.rawValue)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        [iconImageView, logoLabelView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        iconImageView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.view).inset(77)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.65)
            $0.height.equalTo(iconImageView.snp.width).multipliedBy(1.2)
        }
        logoLabelView.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(28)
            $0.horizontalEdges.equalTo(self.view).inset(42)
            $0.height.equalTo(logoLabelView.snp.width).multipliedBy(0.34)
        }
        
    }

    
}
