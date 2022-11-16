//
//  MainView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/16/22.
//

import UIKit
import MapKit

final class MainView: BaseView {
    
    // MARK: - property
    let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    let allbtn: UIButton = {
        let button = UIButton.filterButton(title: "전체", textcolor: .white, bgcolor: ColorPalette.green)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        return button
    }()
    let manbtn = UIButton.filterButton(title: "남자", textcolor: .black, bgcolor: .white)
    let womanbtn: UIButton = {
        let button = UIButton.filterButton(title: "여자", textcolor: .black, bgcolor: .white)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        return button
    }()
    let locationbtn: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.iconButton(image: Constants.ImageName.place.rawValue, fgcolor: .black, bgcolor: .white)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 1.0
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 2
        return button
    }()
    
    let floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.ImageName.defaultState.rawValue), for: .normal)
        return button
    }()

    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        
        [mapView, floatingButton, allbtn, manbtn, womanbtn, locationbtn].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let spacing = 16
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        allbtn.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.width.height.equalTo(spacing * 3)
        }
        manbtn.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.top.equalTo(allbtn.snp.bottom)
            make.width.height.equalTo(spacing * 3)
        }
        womanbtn.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.top.equalTo(manbtn.snp.bottom)
            make.width.height.equalTo(spacing * 3)
        }
        
        locationbtn.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.top.equalTo(womanbtn.snp.bottom).offset(spacing)
            make.width.height.equalTo(spacing * 3)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.width.height.equalTo(spacing * 4)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
        }
    }
    
}
