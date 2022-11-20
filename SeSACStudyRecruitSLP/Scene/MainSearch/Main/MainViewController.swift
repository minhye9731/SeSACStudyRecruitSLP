//
//  MainViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/11/22.
//

import UIKit
import FirebaseAuth
import Toast
import MapKit
import CoreLocation

final class MainViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - property
//    let userData: LoginResponse = LoginResponse(id: "", v: 0, uid: "", phoneNumber: "", email: "", fcMtoken: "", nick: "", birth: "", gender: 0, study: "", comment: [], reputation: [], sesac: 0, sesacCollection: [], background: 0, backgroundCollection: [], purchaseToken: [], transactionID: [], reviewedBefore: [], reportedNum: 0, reportedUser: [], dodgepenalty: 0, dodgeNum: 0, ageMin: 0, ageMax: 0, searchable: 0, createdAt: "")
    
    let mainView = MainView()
    let locationManager = CLLocationManager()
    var matchingMode: MatchingMode = .standby
    
    
    // 위치권한 없을경우 대비용
    let campusLocation = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)

    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1) (API) 사용자 현재 상태를 확인하고, 플로팅 버튼을 설정함
        checkState()
        
        // 2) 사용자 현재 위치를 확인하고, 지도의 중심을 설정함
        // 위치 권한이 거부된 상태라면, 영등포캠퍼스를 기준으로 설정
        
        // 3) (API) 사용자가 지도에서 설정한 위치를 보내고, 응답값으로 타새싹들 지도에 표기
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        mainView.mapView.delegate = self
        
        setCenterRegion(center: campusLocation) // 현재는 캠퍼스로 설정하지만, 실시간으로 내위치 업데이트가 필요함
        setCenterPinFixed() // 내위치 핀은 항상 지도 중앙에 고정
        
        mainView.floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
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
    func setCenterRegion(center: CLLocationCoordinate2D) {
        // 중심잡기
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapView.setRegion(region, animated: true)
    }
    
    func setCenterPinFixed() {
        let coordinate = mainView.mapView.centerCoordinate
        let fixedCenter = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)

        let annotation = MKPointAnnotation()
        annotation.coordinate = campusLocation // fixedCenter
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
        case .matched:
            let vc = ChattingViewController()
            transition(vc, transitionStyle: .push)
        }
    }
    
    // 상태확인 서버통신
    func checkState() {
        let api = APIRouter.state
        Network.share.requestMyState(type: MyQueueStateResponse.self, router: api) { [weak self] response in
            
            switch response {
            case .success(let stateData):
                self?.matchingMode = stateData.matched == 0 ? .standby : .matched
                self?.mainView.showProperStateImage(state: self?.matchingMode ?? .normal)
                
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = LoginError(rawValue: code) else { return }
                print("failure // code = \(code), errorCode = \(errorCode)")
                
                switch errorCode {
                case .fbTokenError:
                    self?.refreshIDToken()
                default :
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                }
            }
        }
    }
    
    
    func refreshIDToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default:
                    self.mainView.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
                }
                return
            } else if let idToken = idToken {
                UserDefaultsManager.idtoken = idToken
                
                let api = APIRouter.state
                Network.share.requestMyState(type: MyQueueStateResponse.self, router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let stateData):
                        self?.matchingMode = stateData.matched == 0 ? .standby : .matched
                        self?.mainView.showProperStateImage(state: self?.matchingMode ?? .normal)
                        
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = LoginError(rawValue: code) else { return }
                        switch errorCode {
                        default:
                            self?.showAlertMessage(title: "서버에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)")
                        }
                    }
                }
            }
        }
    }
    
    
    
}
