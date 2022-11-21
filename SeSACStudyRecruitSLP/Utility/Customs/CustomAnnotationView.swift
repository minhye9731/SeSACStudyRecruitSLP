//
//  CustomAnnotationView.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/22/22.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        backgroundColor = .clear
    }
    
}


class CustomAnnotation: NSObject, MKAnnotation {
    let faceImage: Int?
    let coordinate: CLLocationCoordinate2D
    
    init(faceImage: Int?, coordinate: CLLocationCoordinate2D) {
        self.faceImage = faceImage
        self.coordinate = coordinate
        
        super.init()
    }
    
}











