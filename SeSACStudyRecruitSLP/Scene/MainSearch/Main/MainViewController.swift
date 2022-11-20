//
//  MainViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/11/22.
//

import UIKit
import MapKit
import CoreLocation

final class MainViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - property
    let userData: LoginResponse = LoginResponse(id: "", v: 0, uid: "", phoneNumber: "", email: "", fcMtoken: "", nick: "", birth: "", gender: 0, study: "", comment: [], reputation: [], sesac: 0, sesacCollection: [], background: 0, backgroundCollection: [], purchaseToken: [], transactionID: [], reviewedBefore: [], reportedNum: 0, reportedUser: [], dodgepenalty: 0, dodgeNum: 0, ageMin: 0, ageMax: 0, searchable: 0, createdAt: "")
    
    let mainView = MainView()
    var matchingMode: MatchingMode = .normal
    let campusLocation = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)

    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
        
        mainView.floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        mainView.mapView.delegate = self
        
        // 현재는 캠퍼스로 설정하지만, 실시간으로 내위치 업데이트가 필요함
        setCenterRegionAnnotation(center: campusLocation)
    }

 
}

// MARK: - 지도관련
extension MainViewController {
    
    // 재사용 할 수 있는 어노테이션 만들기
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var basicAnnotationView = self.mainView.mapView.dequeueReusableAnnotationView(withIdentifier: "CustomPin")
        
        if basicAnnotationView == nil {
            basicAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomPin")
            basicAnnotationView?.canShowCallout = true
            
        } else {
            basicAnnotationView?.annotation = annotation
        }
        
        basicAnnotationView?.image = UIImage(named: Constants.ImageName.basicPin.rawValue)
        return basicAnnotationView
    }
    
    
}

// MARK: - 맵관련 메서드
extension MainViewController {

    // 맵뷰 중심잡기 & 어노테이션 추가
    func setCenterRegionAnnotation(center: CLLocationCoordinate2D) {
        // 중심잡기
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapView.setRegion(region, animated: true)
        
        // pin 표기
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mainView.mapView.addAnnotation(annotation)
    }
    
    
}

// MARK: - 기타 버튼 클릭시 액션들
extension MainViewController {
    
    // 성별 필터링 버튼 액션
    
    // 현재위치 버튼 액션
    
    // 플로팅 버튼 액션
    @objc func floatingButtonTapped() {
        
        switch matchingMode {
        case .normal:
            let vc = SearchViewController()
            transition(vc, transitionStyle: .push)
        case .standby:
            let vc = SearchResultViewController()
            transition(vc, transitionStyle: .push)
        case .matching:
            let vc = ChattingViewController()
            transition(vc, transitionStyle: .push)
        }
    }
    
}
