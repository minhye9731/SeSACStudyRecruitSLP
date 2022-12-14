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
    //    var selectGender: MapGenderMode = .all
    
    let campusLocation = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
    
    var sesacList: [FromQueueDB] = []
    var sesacManList: [FromQueueDB] = []
    var sesacWomanList: [FromQueueDB] = []
    
    var matchedUID = ""
    var matchedName = ""
    
    var limitOvercallAPI = false
    
    // MARK: - Lifecycle
    override func loadView()  {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("idtoken \(UserDefaultsManager.idtoken)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        checkState()
        
        navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        searchSesac()
    }
    
    deinit {
        print("📡 홈화몆 화면 deinit")
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        print(#function)
        
        mainView.mapView.delegate = self
        mainView.mapView.showsUserLocation = false
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        goLocation(center: campusLocation)
        checkUserDeviceLocationServiceAuthorization()
        setBtnAction()
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
            goLocation(center: campusLocation)
            showRequestLocationServiceAlert() // 위치권한 허용팝업 생성 -> 설정화면 유도
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation() // 현재위치를 맵뷰 중심으로
        default:
            print("")
        }
    }
    
    // 위치권한 허용팝업
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        // 위치권한 거부시 영등포 캠퍼스를 맵뷰 중심
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
        print("didUpdateLocations!!!!.////////////////////////")
        if let coordinate = locations.last?.coordinate {
            searchSesac()
            goLocation(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    // 사용자의 위치를 못 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.mainView.makeToast("사용자의 위치정보 로드를 실패했습니다. 잠시 후 다시 시도해주세요.", duration: 1.0, position: .center)
    }
    
    // 사용자의 권한 상태가 바뀔 경우
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        searchSesac()
        checkUserDeviceLocationServiceAuthorization()
    }
}

// MARK: - 맵관련 커스텀 메서드
extension MainViewController {
    
    // 맵뷰 위치 설정
    func goLocation(center: CLLocationCoordinate2D) {
        let pRegion = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapView.setRegion(pRegion, animated: true)
        
//        let zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 100, maxCenterCoordinateDistance: 6000)
//        mainView.mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    // 커스텀 어노테이션
    func addCustomPin(faceImage: Int, lat: Double, long: Double) {
        let sesacLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let pin = CustomAnnotation(faceImage: faceImage, coordinate: sesacLocation)
        mainView.mapView.addAnnotation(pin)
    }
    
    // 선택한 성별에 따른 sesac들 어노테이션 표기하기
    func showSesacMap() {
        
        switch UserDefaultsManager.selectedGender {
        case "0":
            mainView.mapView.removeAnnotations(mainView.mapView.annotations)
            sesacWomanList.forEach { addCustomPin(faceImage: $0.sesac, lat: $0.lat, long: $0.long) }
        case "1":
            mainView.mapView.removeAnnotations(mainView.mapView.annotations)
            sesacManList.forEach { addCustomPin(faceImage: $0.sesac, lat: $0.lat, long: $0.long) }
        default:
            mainView.mapView.removeAnnotations(mainView.mapView.annotations)
            sesacList.forEach { addCustomPin(faceImage: $0.sesac, lat: $0.lat, long: $0.long) }
        }
        
        //        switch gender {
        //        case .all:
        //            mainView.mapView.removeAnnotations(mainView.mapView.annotations)
        //            sesacList.forEach { addCustomPin(faceImage: $0.sesac, lat: $0.lat, long: $0.long) }
        //        case .man:
        //            mainView.mapView.removeAnnotations(mainView.mapView.annotations)
        //            sesacManList.forEach { addCustomPin(faceImage: $0.sesac, lat: $0.lat, long: $0.long) }
        //        case .woman:
        //            mainView.mapView.removeAnnotations(mainView.mapView.annotations)
        //            sesacWomanList.forEach { addCustomPin(faceImage: $0.sesac, lat: $0.lat, long: $0.long) }
        //        }
    }
}

// MARK: - 서버통신
extension MainViewController {
    
    // 상태확인
    func checkState() {
        let api = QueueAPIRouter.myQueueState
        Network.share.requestMyQueueState(router: api) { [weak self] (value, statusCode, error) in
            
            guard let statusCode = statusCode else { return }
            guard let status =  MyQueueStateError(rawValue: statusCode) else { return }
            print("⭐️value : \(value), ⭐️statusCode: \(statusCode)")
            
            switch status {
            case .success:
                print("⭐️현재 matched 여부 : \(value?.matched)")
                self?.matchingMode = value?.matched == 1 ? .matched : .standby
                self?.mainView.showProperStateImage(state: self!.matchingMode)
                self?.matchedUID = value?.matchedUid ?? ""
                self?.matchedName = value?.matchedNick ?? ""
                return
                
            case .normalStatus:
                print("⭐️현재 matched 여부 : \(value?.matched)")
                self?.matchingMode = .normal
                self?.mainView.showProperStateImage(state: self!.matchingMode)
                return
                
            case .fbTokenError:
                self?.refreshIDTokenQueue()
                return
                
            default :
                self?.mainView.makeToast(status.errorDescription, duration: 1.0, position: .center)
                return
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
                
                let api = QueueAPIRouter.myQueueState
                Network.share.requestMyQueueState(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let statusCode = statusCode else { return }
                    guard let status =  MyQueueStateError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        print("⭐️현재 matched 여부 : \(value?.matched)")
                        self?.matchingMode = value?.matched == 1 ? .matched : .standby
                        self?.mainView.showProperStateImage(state: self!.matchingMode)
                        return
                        
                    case .normalStatus:
                        print("⭐️현재 matched 여부 : \(value?.matched)")
                        self?.matchingMode = .normal
                        self?.mainView.showProperStateImage(state: self!.matchingMode)
                        return
                        
                    default :
                        self?.mainView.makeToast("서버에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
    
    // 과호출 제한 - timeout 방안으로 추가 조사 필요
    func limitOvercall() {
        limitOvercallAPI = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.limitOvercallAPI = false
        }
    }
    
    // 새싹찾기
    func searchSesac() {
        print(#function)
        
        let api = QueueAPIRouter.search(
            lat: String(mainView.mapView.centerCoordinate.latitude),
            long: String(mainView.mapView.centerCoordinate.longitude))
        
        if !limitOvercallAPI {
            
            Network.share.requestSearch(router: api) { [weak self] (value, statusCode, error) in
                
                guard let value = value else { return }
                guard let statusCode = statusCode else { return }
                guard let status =  SignupError(rawValue: statusCode) else { return }
                
                switch status {
                case .success:
                    print("🦄search 통신 성공!!")
                    self?.limitOvercall()
                    
                    self?.sesacList.removeAll()
                    self?.sesacManList.removeAll()
                    self?.sesacWomanList.removeAll()
                    
                    self?.sesacList.append(contentsOf: value.fromQueueDB)
                    self?.sesacManList = self!.sesacList.filter { $0.gender == 1 }
                    self?.sesacWomanList = self!.sesacList.filter { $0.gender == 0 }
                    
                    //                print("sesacList : \(self?.sesacList)")
                    //                print("sesacManList : \(self?.sesacManList)")
                    //                print("sesacWomanList : \(self?.sesacWomanList)")
                    
                    self?.showSesacMap()
                    return
                    
                case .fbTokenError:
                    print("401 에러당") // 통일 처리필요
                    return
                    //                self?.refreshIDTokenSearch()
                default:
                    self?.mainView.makeToast("친구찾기에 실패했습니다. 잠시 후 다시 시도해주세요.", duration: 0.5, position: .center)
                    return
                }
            }
        } else {
            return
        }
    }
    
    // 통일 처리필요
    func refreshIDTokenSearch() {
        
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
                print("401 에러 해결")
                
                
                
                
                
                
                
                
            }
        }
    }
    
}

// MARK: - MapView 메서드
extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(#function)
        searchSesac()
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
        UserDefaultsManager.selectedGender = "2"
        searchSesac()
        mainView.genderBtnClr()
    }
    
    @objc func manbtnTapped() {
        UserDefaultsManager.selectedGender = "1"
        searchSesac()
        mainView.genderBtnClr()
    }
    
    @objc func womanbtnTapped() {
        UserDefaultsManager.selectedGender = "0"
        searchSesac()
        mainView.genderBtnClr()
    }
    
    // gps
    @objc func locationbtnTapped() {
        checkUserDeviceLocationServiceAuthorization()
        searchSesac()
    }
    
    // 플로팅
    @objc func floatingButtonTapped() {
        print("floatingButtonTapped 눌림~@@")
        // 버튼 클릭시 myqueuestate 한번 더 확ㅇ니하는 코드 추가해야 할 듯
        UserDefaultsManager.searchLAT = String(mainView.mapView.centerCoordinate.latitude)
        UserDefaultsManager.searchLONG = String(mainView.mapView.centerCoordinate.longitude)
        
        switch matchingMode {
               case .normal:
                   let authorizationStatus = locationManager.authorizationStatus
                   
                   if authorizationStatus == .denied || authorizationStatus == .restricted {
                       showRequestLocationServiceAlert()
                   } else {
                       let vc = SearchViewController()
                       transition(vc, transitionStyle: .push)
                   }
                   return
                   
               case .standby:
                   let firstVC = SearchViewController()
                   let targetVC = SearchResultViewController()
                   let vcs = [firstVC, targetVC]
                   self.navigationController?.push(vcs)
                   
               case .matched:
                   let vc = ChattingViewController()
            vc.otherSesacUID = self.matchedUID
            vc.otherSesacNick = self.matchedName
                   transition(vc, transitionStyle: .push)
               }
        
//        let api = QueueAPIRouter.myQueueState
//        Network.share.requestMyQueueState(router: api) { [weak self] (value, statusCode, error) in
//
//            print(value)
//
//            guard let value = value else { return }
//            guard let statusCode = statusCode else { return }
//            guard let status =  MyQueueStateError(rawValue: statusCode) else { return }
//            print("⭐️value : \(value), ⭐️statusCode: \(statusCode)")
//
//            switch status {
//            case .success:
//                print("⭐️현재 matched 여부 : \(value.matched)")
//
//                if value.matched == 1 {
//                    let vc = ChattingViewController()
//                    vc.otherSesacUID = value.matchedUid
//                    vc.otherSesacNick = value.matchedNick
//                    self?.transition(vc, transitionStyle: .push)
//                } else {
//                    let firstVC = SearchViewController()
//                    let targetVC = SearchResultViewController()
//                    let vcs = [firstVC, targetVC]
//                    self?.navigationController?.push(vcs)
//                }
//                return
//
//            case .normalStatus:
//                print("⭐️현재 matched 여부 : \(value.matched)")
//                let authorizationStatus = self?.locationManager.authorizationStatus
//
//                if authorizationStatus == .denied || authorizationStatus == .restricted {
//                    self?.showRequestLocationServiceAlert()
//                } else {
//                    let vc = SearchViewController()
//                    self?.transition(vc, transitionStyle: .push)
//                }
//                return
//
//            case .fbTokenError:
//                return print("401 에러당~~~~") // 401에러 통일작업 필요
//
//            default :
//                self?.mainView.makeToast(status.errorDescription, duration: 1.0, position: .center)
//                return
//            }
//        }
        
    }
}









