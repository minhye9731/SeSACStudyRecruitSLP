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

final class MainViewController: BaseViewController, MKMapViewDelegate {
    
    // MARK: - property
    let mainView = MainView()
    let locationManager = CLLocationManager()
    var matchingMode: MatchingMode = .normal
    
    // 위치권한 없을경우 대비용
    let campusLocation = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
    // 사용자 위치 업데이트용?
    var userLocation = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
        
    }
    
    //홈화면 보일 때마다
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1) (API) 사용자 현재 상태를 확인하고, 플로팅 버튼을 설정함
        print(#function)
        //        checkState() // 서버에러남..
        mainView.showProperStateImage(state: matchingMode) // test용
        
        // 2) 사용자 현재 위치를 확인하고, 지도의 중심을 설정함
        // 위치 권한이 거부된 상태라면, 영등포캠퍼스를 기준으로 설정
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        setCenterPinFixed() // 내위치 핀은 항상 지도 중앙에 고정
        //        showRequestLocationServiceAlert()
        locationManager.requestWhenInUseAuthorization() // 위치 권한요청 팝업
        locationManager.startUpdatingLocation() // 위치 업데이트
        mainView.mapView.showsUserLocation = false // 사용자 위치표기 막기(파란색 원)
        checkUserDeviceLocationServiceAuthorization() // 사용자 위치사용 권한여부 확인 및 처리
        
        // 3) (API) 사용자가 지도에서 설정한 위치를 보내고, 응답값으로 타새싹들 지도에 표기
        
        
        
        
        
        
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        mainView.mapView.delegate = self
        mainView.floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        mainView.locationbtn.addTarget(self, action: #selector(locationbtnTapped), for: .touchUpInside)
    }
    
    // 위치권한 허용팝업 생성
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate 프로토콜 선언
extension MainViewController: CLLocationManagerDelegate {
    
    // 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            print("업데이트된 사용자 현위치 = \(coordinate.latitude.description) / \(coordinate.latitude.description)")
            goLocation(center: coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
    // 사용자의 위치를 못 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function) // 처리 필요
        self.mainView.makeToast("사용자의 위치정보 로드를 실패했습니다. 잠시 후 다시 시도해주세요.", duration: 1.0, position: .center)
    }
    
    // 사용자의 권한 상태가 바뀔 경우
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
}

// MARK: - 위치 관련된 User Defined 메서드
extension MainViewController {
    
    // iOS 위치 서비스 활성화여부 확인 (먼저)
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkUserCurrentLocationAuthorization(authorizationStatus)
            } else {
                self.mainView.makeToast("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.", duration: 1.0, position: .center)
            }
        }
        
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 위치 권한요청 팝업
            
        case .restricted, .denied:
            print("DENIED, 청년취업사관학교 영등포 캠퍼스가 맵뷰의 중심이 되도록 설정합니다.")
            goLocation(center: campusLocation)
            showRequestLocationServiceAlert() // 위치권한 허용팝업 생성 -> 설정화면 유도
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            locationManager.startUpdatingLocation() // 현재위치를 맵뷰 중심으로
            
        default:
            print("DEFAULT")
            locationManager.startUpdatingLocation() // 현재위치를 맵뷰 중심으로
        }
    }
    
    
    
    
    
}


// MARK: - 맵관련 메서드
extension MainViewController {
    
    // 맵뷰 중심잡기 &
    func goLocation(center: CLLocationCoordinate2D) {
        let pLocation = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
        let spanValue = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        mainView.mapView.setRegion(pRegion, animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 100, maxCenterCoordinateDistance: 6000)
        mainView.mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    // (지도뷰 기준) 중앙에 핀 고정
    func setCenterPinFixed() {
        let fixedAnnotation = MKPointAnnotation()
        fixedAnnotation.coordinate = mainView.mapView.region.center
        mainView.mapView.addAnnotation(fixedAnnotation)
    }
    
    // 지도 움직일 때마다 중심 업데이트
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(#function)
        
        mainView.mapView.removeAnnotations(mainView.mapView.annotations) // 전체 핀 삭제
        setCenterPinFixed() // 중앙 고정핀 추가
        //        locationManager.startUpdatingLocation()
        
        
        
        
        
    }
    
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

// MARK: - 기타 버튼 클릭시 액션들
extension MainViewController {
    
    // 성별 필터링 버튼 액션
    
    // gps 버튼 액션
    @objc func locationbtnTapped() {
        checkUserDeviceLocationServiceAuthorization() // gps 버튼 클릭했을 때, 위치가 거부되어 있다면 -> '위치 서비스 사용 불가' 얼럿 & 아이폰 전체 설정 화면으로 이동
        
    }
    
    // 플로팅 버튼 액션
    @objc func floatingButtonTapped() {
        switch matchingMode {
        case .normal:
            checkUserDeviceLocationServiceAuthorization()
            
            let authorizationStatus = locationManager.authorizationStatus
            
            if authorizationStatus == .denied || authorizationStatus == .restricted {
                showRequestLocationServiceAlert()
            } else {
                let vc = SearchViewController()
                transition(vc, transitionStyle: .push)
            }
            
            
            
            
        case .standby:
            let vc = SearchResultViewController()
            transition(vc, transitionStyle: .push)
        case .matched:
            let vc = ChattingViewController()
            transition(vc, transitionStyle: .push)
        }
    }
    
    // MARK: - 상태확인 서버통신
    func checkState() {
        let api = APIRouter.state
        Network.share.requestMyState(type: MyQueueStateResponse.self, router: api) { [weak self] response in
            
            switch response {
            case .success(let stateData):
                print("⭐️현재 matched 여부 : \(stateData.matched)")
                self?.matchingMode = stateData.matched == 0 ? .standby : .matched
                self?.mainView.showProperStateImage(state: self!.matchingMode)
                
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = SignupError(rawValue: code) else { return }
                print("⭐️⭐️⭐️현재 매칭모드 실패 : errorCode = \(errorCode), error설명 = \(error.localizedDescription)")
                
                switch errorCode {
                case .fbTokenError:
                    self?.refreshIDTokenQueue()
                default :
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                }
            }
        }
    }
    
    func refreshIDTokenQueue() {
        
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
                        print("토큰재발급해서 재시도해서 얻은 결과 : \(stateData.matched)")
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
    
    // MARK: - 새싹찾기 서버통신
    func searchSesac(center: CLLocationCoordinate2D) {
        let api = APIRouter.search(lat: center.latitude.description, long: center.longitude.description)
        Network.share.requestLogin(type: SearchResponse.self, router: api) { [weak self] response in
            
            switch response {
            case .success(let result):
                print("===✅새싹찾기 통신 성공!====")
                
                
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = SignupError(rawValue: code) else { return }
                print("새싹찾기 통신 failure🔥 // code = \(code), errorCode = \(errorCode)")
                
                switch errorCode {
                case .fbTokenError:
                    self?.refreshIDTokenSearch(center: center)
                default:
                    self?.mainView.makeToast("친구찾기에 실패했습니다. 잠시 후 다시 시도해주세요.", duration: 0.5, position: .center)
                }
            }
        }
    }
    
    func refreshIDTokenSearch(center: CLLocationCoordinate2D) {
        
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
                
                let api = APIRouter.search(lat: center.latitude.description, long: center.longitude.description)
                Network.share.requestLogin(type: SearchResponse.self, router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let result):
                        print("===✅새싹찾기 통신 성공!====")
                        
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










