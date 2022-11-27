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

final class MainViewController: BaseViewController {
    
    // MARK: - property
    let mainView = MainView()
    let locationManager = CLLocationManager()
    var matchingMode: MatchingMode = .normal
    var selectGender: MapGenderMode = .all
    
    let campusLocation = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
    
    var sesacList: [FromQueueDB] = []
    var sesacManList: [FromQueueDB] = []
    var sesacWomanList: [FromQueueDB] = []
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //홈화면 보일 때마다
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserDeviceLocationServiceAuthorization()
        checkState() // myQueueState
        searchSesac(selectGender: selectGender) // search
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        mainView.mapView.delegate = self
        mainView.mapView.showsUserLocation = false
        
        // 사용자 현재 위치를 확인하고, 지도의 중심을 설정
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        goLocation(center: campusLocation)
        
        setBtnAction()
        
        print(UserDefaultsManager.idtoken)
    }
    
    func setBtnAction() {
        mainView.floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        mainView.locationbtn.addTarget(self, action: #selector(locationbtnTapped), for: .touchUpInside)
        mainView.allbtn.addTarget(self, action: #selector(allbtnTapped), for: .touchUpInside)
        mainView.manbtn.addTarget(self, action: #selector(manbtnTapped), for: .touchUpInside)
        mainView.womanbtn.addTarget(self, action: #selector(womanbtnTapped), for: .touchUpInside)
    }
}

// MARK: - 위치 관련된 User Defined 메서드
extension MainViewController {
    
    func checkUserDeviceLocationServiceAuthorization() {  // iOS 위치 서비스 활성화여부 확인
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
        self.checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
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
    
    // 위치권한 허용팝업 생성
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        // 위치권한 거부시 영등포 캠퍼스가 맵뷰의 중심이 되도록 설정
        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
            self?.goLocation(center: self!.campusLocation)
        }
        
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate 프로토콜 선언
extension MainViewController: CLLocationManagerDelegate {
    
    // 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let coordinate = locations.last?.coordinate {
            searchSesac(selectGender: selectGender)
            goLocation(center: coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
    // 사용자의 위치를 못 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.mainView.makeToast("사용자의 위치정보 로드를 실패했습니다. 잠시 후 다시 시도해주세요.", duration: 1.0, position: .center)
    }
    
    // 사용자의 권한 상태가 바뀔 경우
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
}

// MARK: - 맵관련 커스텀 메서드
extension MainViewController {
    
    // 맵뷰 위치 설정
    func goLocation(center: CLLocationCoordinate2D) {
        let pRegion = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapView.setRegion(pRegion, animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 100, maxCenterCoordinateDistance: 6000)
        mainView.mapView.setCameraZoomRange(zoomRange, animated: true)
    }
        
    // 커스텀 어노테이션
    func addCustomPin(faceImage: Int, lat: Double, long: Double) {
        let sesacLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let pin = CustomAnnotation(faceImage: faceImage, coordinate: sesacLocation)
        mainView.mapView.addAnnotation(pin)
    }
    
    // 선택한 성별에 따른 sesac들 어노테이션 표기하기
    func showSesacMap(gender: MapGenderMode) {
        switch gender {
        case .all:
            print("전체 보여주기")
            mainView.mapView.removeAnnotations(mainView.mapView.annotations)
            sesacList.forEach { addCustomPin(faceImage: $0.sesac, lat: $0.lat, long: $0.long) }
        case .man:
            print("남자만 보여주기")
            mainView.mapView.removeAnnotations(mainView.mapView.annotations)
            sesacManList.forEach { addCustomPin(faceImage: $0.sesac, lat: $0.lat, long: $0.long) }
        case .woman:
            print("여자만 보여주기")
            mainView.mapView.removeAnnotations(mainView.mapView.annotations)
            sesacWomanList.forEach { addCustomPin(faceImage: $0.sesac, lat: $0.lat, long: $0.long) }
        }
    }
}

// MARK: - 서버통신
extension MainViewController {
    
    // 상태확인
    func checkState() {
        print("⭐️내상태 확인 긔긔")
        let api = APIRouter.myQueueState
        print("⭐️ idtoken = \(UserDefaultsManager.idtoken)")
        Network.share.requestLogin(type: MyQueueStateResponse.self, router: api) { [weak self] response in
            
            switch response {
            case .success(let stateData):
                print("⭐️현재 matched 여부 : \(stateData.matched)")
                self?.matchingMode = stateData.matched == 0 ? .standby : .matched
                
                self?.mainView.showProperStateImage(state: self!.matchingMode)
                return
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = SignupError(rawValue: code) else { return }
                
                print("⭐️⭐️⭐️현재 매칭모드 실패 : errorCode = \(errorCode), error설명 = \(error.localizedDescription)")
                
                switch errorCode {
                case .existUser: // 201
                    self?.matchingMode = .normal
                    self?.mainView.showProperStateImage(state: self!.matchingMode)
                    return
                case .fbTokenError:
                    self?.refreshIDTokenQueue()
                    return
                default :
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                    return
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
                
                let api = APIRouter.myQueueState
                Network.share.requestLogin(type: MyQueueStateResponse.self, router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let stateData):
                        print("토큰재발급해서 재시도해서 얻은 결과 : \(stateData.matched)")
                        self?.matchingMode = stateData.matched == 0 ? .standby : .matched
                        self?.mainView.showProperStateImage(state: self!.matchingMode)
                        return
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = SignupError(rawValue: code) else { return }
                        switch errorCode {
                        case .existUser: // 201
                            self?.matchingMode = .normal
                            self?.mainView.showProperStateImage(state: self!.matchingMode)
                            return
                        default:
                            self?.showAlertMessage(title: "서버에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)")
                        }
                    }
                }
            }
        }
    }
    
    // 새싹찾기
    func searchSesac(selectGender: MapGenderMode) {
        print(#function)
        
        let api = APIRouter.search(
            lat: String(mainView.mapView.centerCoordinate.latitude),
            long: String(mainView.mapView.centerCoordinate.longitude))
        Network.share.requestSearch(type: SearchResponse.self, router: api) { [weak self] response in
            
            switch response {
            case .success(let result):
                print("===✅새싹찾기 통신 성공! ====")
                
                self?.sesacList.removeAll()
                self?.sesacManList.removeAll()
                self?.sesacWomanList.removeAll()
                
                self?.sesacList.append(contentsOf: result.fromQueueDB)
                self?.sesacManList = self!.sesacList.filter { $0.gender == 1 }
                self?.sesacWomanList = self!.sesacList.filter { $0.gender == 0 }
                
//                print("sesacList : \(self?.sesacList)")
//                print("sesacManList : \(self?.sesacManList)")
//                print("sesacWomanList : \(self?.sesacWomanList)")
                       
                self?.showSesacMap(gender: selectGender)
                
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = SignupError(rawValue: code) else { return }
                print("새싹찾기 통신 failure🔥 // code = \(code), errorCode = \(errorCode)")
                switch errorCode {
                case .fbTokenError:
                    self?.refreshIDTokenSearch(selectGender: selectGender)
                default:
                    self?.mainView.makeToast("친구찾기에 실패했습니다. 잠시 후 다시 시도해주세요.", duration: 0.5, position: .center)
                }
            }
        }
    }
    
    func refreshIDTokenSearch(selectGender: MapGenderMode) {
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [self] idToken, error in
            
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default:
                    self.mainView.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
                }
                return
            } else if let idToken = idToken {
                UserDefaultsManager.idtoken = idToken

                let api = APIRouter.search(
                    lat: String(mainView.mapView.centerCoordinate.latitude),
                    long: String(mainView.mapView.centerCoordinate.longitude))
                Network.share.requestSearch(type: SearchResponse.self, router: api) { [weak self] response in
                    switch response {
                    case .success(let result):
                        print("===✅새싹찾기 통신 성공!====")
                        
                        // 배열 다 비우기
                        self?.sesacList.removeAll()
                        self?.sesacManList.removeAll()
                        self?.sesacWomanList.removeAll()
                        
                        // 해당 위치에서 검색된 정보를 배열에 담기
                        self?.sesacList.append(contentsOf: result.fromQueueDB)
                        self?.sesacManList = self!.sesacList.filter { $0.gender == 1 }
                        self?.sesacManList = self!.sesacList.filter { $0.gender == 0 }
                               
                        // 새싹 지도 표기
                        self?.showSesacMap(gender: selectGender)
   
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

// MARK: - MapView 메서드
extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(#function)
        searchSesac(selectGender: selectGender)
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print(#function)
        mainView.mapView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.mainView.mapView.isUserInteractionEnabled = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? CustomAnnotation else { return nil }
        
        var annotationView = self.mainView.mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.reuseIdentifier)
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
        } else {
            annotationView?.annotation = annotation
        }
        
        var sesacImage: UIImage!
        
        switch annotation.faceImage {
        case 0: setImage(w: 85, h: 85, img: Constants.ImageName.face1.rawValue)
        case 1: setImage(w: 85, h: 85, img: Constants.ImageName.face2.rawValue)
        case 2: setImage(w: 85, h: 85, img: Constants.ImageName.face3.rawValue)
        case 3: setImage(w: 85, h: 85, img: Constants.ImageName.face4.rawValue)
        case 4: setImage(w: 85, h: 85, img: Constants.ImageName.face5.rawValue)
        default: setImage(w: 48, h: 48, img: Constants.ImageName.basicPin.rawValue)
        }

        func setImage(w: Double, h: Double, img: String) {
            let size = CGSize(width: w, height: h)
            UIGraphicsBeginImageContext(size)
            sesacImage = UIImage(named: img)
            sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }

        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
    }
}

// MARK: - 기타 버튼 클릭시 액션들
extension MainViewController {
    
    @objc func allbtnTapped() {
        selectGender = .all
        searchSesac(selectGender: selectGender)
        mainView.genderBtnClr(selectGender: selectGender)
    }
    
    @objc func manbtnTapped() {
        selectGender = .man
        searchSesac(selectGender: selectGender)
        mainView.genderBtnClr(selectGender: selectGender)
    }
    
    @objc func womanbtnTapped() {
        selectGender = .woman
        searchSesac(selectGender: selectGender)
        mainView.genderBtnClr(selectGender: selectGender)
    }
    
    // gps
    @objc func locationbtnTapped() {
        checkUserDeviceLocationServiceAuthorization()
        searchSesac(selectGender: selectGender)
    }
    
    // 플로팅
    @objc func floatingButtonTapped() {
        switch matchingMode {
        case .normal:
            checkUserDeviceLocationServiceAuthorization()
            
            let authorizationStatus = locationManager.authorizationStatus
            
            if authorizationStatus == .denied || authorizationStatus == .restricted {
                showRequestLocationServiceAlert()
            } else {
                let vc = SearchViewController()
                vc.searchCoordinate = UserLocationDTO(lat: mainView.mapView.centerCoordinate.latitude, long: mainView.mapView.centerCoordinate.longitude)
                transition(vc, transitionStyle: .push)
            }
            return
        case .standby:
            let vc = SearchResultViewController()
            transition(vc, transitionStyle: .push)
            
        case .matched:
            let vc = ChattingViewController()
            transition(vc, transitionStyle: .push)
        }
    }
    
}









