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
        let button = UIButton.generalButton(title: "전체", textcolor: .white, bgcolor: ColorPalette.green, font: CustomFonts.title3_M14())
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        return button
    }()
    let manbtn = UIButton.generalButton(title: "남자", textcolor: .black, bgcolor: .white, font: CustomFonts.title3_M14())
    let womanbtn: UIButton = {
        let button = UIButton.generalButton(title: "여자", textcolor: .black, bgcolor: .white, font: CustomFonts.title3_M14())
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
    
    let filterStackView: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillEqually
        
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        return view
    }()

    // MARK: - functions
    override func configureUI() {
        super.configureUI()
        [mapView, floatingButton, filterStackView, locationbtn].forEach { self.addSubview($0) }
        [allbtn, manbtn, womanbtn].forEach { filterStackView.addArrangedSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let spacing = 16
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        
        mapView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        filterStackView.snp.makeConstraints {
            $0.top.equalTo(self).offset(52)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
        }
        allbtn.snp.makeConstraints {
            $0.width.equalTo(width * 0.128)
            $0.height.equalTo(allbtn.snp.width)
        }
        manbtn.snp.makeConstraints {
            $0.width.equalTo(allbtn.snp.width)
            $0.height.equalTo(allbtn.snp.width)
        }
        womanbtn.snp.makeConstraints {
            $0.width.equalTo(allbtn.snp.width)
            $0.height.equalTo(allbtn.snp.width)
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
    
    func showProperStateImage(state: MatchingMode) {
        print("현재 매칭모드는 : \(state)")
        
        switch state {
        case .normal:
            floatingButton.setImage(UIImage(named: Constants.ImageName.defaultState.rawValue), for: .normal)
        case .standby:
            floatingButton.setImage(UIImage(named: Constants.ImageName.standby.rawValue), for: .normal)
        case .matched:
            floatingButton.setImage(UIImage(named: Constants.ImageName.matched.rawValue), for: .normal)
        }
    }
}
