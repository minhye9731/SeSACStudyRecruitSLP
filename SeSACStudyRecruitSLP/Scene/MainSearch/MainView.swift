//
//  MainView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/16/22.
//

import UIKit
import MapKit

final class MainView: BaseView {
    
    let mapView: MKMapView = {
        let map = MKMapView()
        
        return map
    }()
    
    
    
    override func configureUI() {
        super.configureUI()
        
        self.addSubview(mapView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    
}
