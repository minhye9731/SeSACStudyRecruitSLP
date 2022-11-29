//
//  SearchViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/19/22.
//

import UIKit
import RxSwift
import RxCocoa
import Toast
import FirebaseAuth

import Alamofire

final class SearchViewController: BaseViewController {
    
    // MARK: - property
    let mainView = SearchView()
//    var searchCoordinate = UserLocationDTO(lat: 0.0, long: 0.0)
    var aroundTagList: [String] = []
    var mywishTagList: [String] = []
    var rocommendNum = 0
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        print("선택한 성별 : \(UserDefaultsManager.selectedGender)")
        searchNetwork()
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        self.tabBarController?.tabBar.isHidden = true
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.searchBtn.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        mainView.accSearchBtn.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        setNav()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? aroundTagList.count : mywishTagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionTitleSupplementaryView.reuseIdentifier,
                for: indexPath
            ) as! SectionTitleSupplementaryView
            
            let header = indexPath.section == 0 ? "지금 주변에는" : "내가 하고 싶은"
            supplementaryView.prepare(title: header)
            
            return supplementaryView
        default: return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let aroundCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        guard let myWishCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTagCell.reuseIdentifier, for: indexPath) as? MyTagCell else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            aroundCell.setAroundData(data: aroundTagList, indexPath: indexPath, rcmNum: rocommendNum)
            return aroundCell
        case 1:
            myWishCell.setMyWishData(indexPath: indexPath)
            return myWishCell
        default: return myWishCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let selectStudy = aroundTagList[indexPath.row]
            
            if mywishTagList.count == 8 {
                mainView.makeToast("스터디를 더 이상 추가할 수 없습니다.", duration: 0.5, position: .center)
                return
            }
            
            if mywishTagList.contains(selectStudy) {
                mainView.makeToast("이미 등록된 스터디입니다.", duration: 0.5, position: .center)
            } else {
                mywishTagList.append(selectStudy)
                UserDefaultsManager.mywishTagList = mywishTagList
                mainView.collectionView.reloadData()
            }
            print(mywishTagList)
            
        case 1:
            let selectStudy = mywishTagList[indexPath.row]
            mywishTagList = mywishTagList.filter { $0 != selectStudy}
            UserDefaultsManager.mywishTagList = mywishTagList
            mainView.collectionView.reloadData()
            print(mywishTagList)
            
        default: print("test")
        }
    }
    
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    // 셀 크기설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label: UILabel = {
            let label = UILabel()
            label.font = CustomFonts.title4_R14()
            label.text = indexPath.section == 0 ? aroundTagList[indexPath.item] : mywishTagList[indexPath.item]
            label.sizeToFit()
            return label
        }()
        
        let size = label.frame.size
        
        return indexPath.section == 0 ? CGSize(width: size.width + 32, height: 32) : CGSize(width: size.width + 52, height: 32)
    }
}

// MARK: - textfield
extension SearchViewController: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if mywishTagList.count == 8 {
            mainView.makeToast("스터디를 더 이상 추가할 수 없습니다.", duration: 0.5, position: .center)
            return true
        }
        
        if (textField.text == "") || (textField.text == " ") {
            mainView.makeToast("스터디명은 최소 한 자 이상, 최대 8글자까지 작성 가능합니다.", duration: 0.5, position: .center)
            return true
        }
        
        guard let text = textField.text else { return true }
        var inputStudy = text.components(separatedBy: " ").filter { $0.count > 0 }
        let inputStudyLength = inputStudy.map { $0.count }.filter { $0 != 0 }
        
        print(inputStudy)
        print(inputStudyLength)

        if inputStudyLength.min()! < 1 || inputStudyLength.max()! > 8  {
            mainView.makeToast("스터디명은 최소 한 자 이상, 최대 8글자까지 작성 가능합니다.", duration: 0.5, position: .center)
            return true
        } else if (inputStudy.count + mywishTagList.count) > 8 {
            let to = 8 - mywishTagList.count
            let slicedArr = Array(inputStudy[0...(to - 1)])
            mywishTagList.append(contentsOf: slicedArr)
            
            UserDefaultsManager.mywishTagList = mywishTagList // userdefaults에 저장
            mainView.collectionView.reloadData() // 화면 갱신
            textField.resignFirstResponder() // 키보드 내리고
            inputStudy.removeAll() // 배열 비우고
            return true
            
        } else {
            mywishTagList.append(contentsOf: inputStudy) // [내가 하고 싶은] 스터디에 추가
            UserDefaultsManager.mywishTagList = mywishTagList // userdefaults에 저장
            mainView.collectionView.reloadData() // 화면 갱신
            textField.resignFirstResponder() // 키보드 내리고
            inputStudy.removeAll() // 배열 비우고
            return true
        }
    }
    
}

// MARK: - etc
extension SearchViewController {
    
    func setNav() {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 28, height: 0))
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.searchTextField.inputAccessoryView = self.mainView.accSearchBtn
        searchBar.searchTextField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    @objc func searchBtnTapped() {
        queueNetwork()
    }

}

// MARK: - search 통신
extension SearchViewController {

//    func searchNetwork(location: UserLocationDTO) {
    func searchNetwork() {
//        let api = APIRouter.search(lat: String(location.lat), long: String(location.long))
        let api = APIRouter.search(lat: UserDefaultsManager.searchLAT, long: UserDefaultsManager.searchLONG)
        Network.share.requestLogin(type: SearchResponse.self, router: api) { [weak self] response in
            
            switch response {
            case .success(let searchResult):
                print("🦄search 통신 성공!! searchResult = \(searchResult)")
                self?.aroundTagList.removeAll()
                
                self?.aroundTagList.append(contentsOf: searchResult.fromRecommend)
                self?.rocommendNum = searchResult.fromRecommend.count
                
                searchResult.fromQueueDB.forEach { self?.aroundTagList.append(contentsOf: $0.studylist) }
                searchResult.fromQueueDBRequested.forEach { self?.aroundTagList.append(contentsOf: $0.studylist) }
                
                self?.aroundTagList = Array(Set(self!.aroundTagList))
                self?.mainView.collectionView.reloadData()
                
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = LoginError(rawValue: code) else { return }
                print("failure // code = \(code), errorCode = \(errorCode)")
                
                switch errorCode {
                case .fbTokenError:
//                    self?.refreshIDTokenSearch(location: location)
                    self?.refreshIDTokenSearch()
                default :
                    self?.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", duration: 1.0, position: .center)
                }
            }
        }
    }
    
    func refreshIDTokenSearch() {
//        func refreshIDTokenSearch(location: UserLocationDTO) {
        
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
                print("🦄갱신된 idToken 저장완료 |  UserDefaultsManager.idtoken = \(UserDefaultsManager.idtoken)")
                
//                let api = APIRouter.search(lat: String(location.lat), long: String(location.long))
                let api = APIRouter.search(lat: UserDefaultsManager.searchLAT, long: UserDefaultsManager.searchLONG)
                Network.share.requestLogin(type: SearchResponse.self, router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let searchResult):
                        print("🦄searchResult = \(searchResult)")
                        self?.aroundTagList.removeAll()
                        
                        self?.aroundTagList.append(contentsOf: searchResult.fromRecommend)
                        self?.rocommendNum = searchResult.fromRecommend.count
                        
                        searchResult.fromQueueDB.forEach { self?.aroundTagList.append(contentsOf: $0.studylist) }
                        searchResult.fromQueueDBRequested.forEach { self?.aroundTagList.append(contentsOf: $0.studylist) }
                        
                        self?.aroundTagList = Array(Set(self!.aroundTagList))
                        self?.mainView.collectionView.reloadData()
                        
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = LoginError(rawValue: code) else { return }
                        print("failure // code = \(code), errorCode = \(errorCode)")
                        
                        switch errorCode {
                        default :
                            self?.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", duration: 1.0, position: .center)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - queue 통신
extension SearchViewController {
    
    func queueNetwork() {
        
        let studylist = mywishTagList.isEmpty ? ["anything"] : mywishTagList

//        Network.share.requestQueue(long: String(searchCoordinate.long), lat: String(searchCoordinate.lat), studyList: studylist) { [weak self] response in
        Network.share.requestQueue(long: UserDefaultsManager.searchLONG, lat: UserDefaultsManager.searchLAT, studyList: studylist) { [weak self] response in
            
            switch response {
            case .success( _):
                print("👻 queue 통신 성공!! studylist = \(studylist)")
                let vc = SearchResultViewController()
                // 화면 넘어가는 거는 그릇이 되는 SearchResultViewController인데,
                // 넘어간 화면에서 사용자의 위치를 사용할때는 ListViewController에서 데이터를 써야 한다 흠.....어떻게 전달하징..우선UserDefaultsManager 쓴다
                
//                UserDefaultsManager.searchLAT = String(self!.searchCoordinate.lat)
//                UserDefaultsManager.searchLONG = String(self!.searchCoordinate.long)
                
                self?.transition(vc, transitionStyle: .push)
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = SignupError(rawValue: code) else { return }
                print("failure // code = \(code), errorCode = \(errorCode)")
                
                switch errorCode {
                case .existUser: // 201
                    self?.mainView.makeToast("신고가 누적되어 이용하실 수 없습니다", duration: 1.0, position: .center)
                case .cancelPenalty1:
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                    // 1분간 찾기 불가 적용!!
                case .cancelPenalty2:
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                    // 1분간 찾기 불가 적용!!
                case .cancelPenalty3:
                    self?.mainView.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                    // 1분간 찾기 불가 적용!!
                case .fbTokenError:
                    self?.refreshIDTokenQueue()
                default:
                    self?.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
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
                print("🦄갱신된 idToken 저장완료 |  UserDefaultsManager.idtoken = \(UserDefaultsManager.idtoken)")
                
                let studylist = self.mywishTagList.isEmpty ? ["anything"] : self.mywishTagList

//                Network.share.requestQueue(long: String(self.searchCoordinate.long), lat: String(self.searchCoordinate.lat), studyList: studylist) { [weak self] response in
                Network.share.requestQueue(long: UserDefaultsManager.searchLONG, lat: UserDefaultsManager.searchLAT, studyList: studylist) { [weak self] response in
                    
                    switch response {
                    case .success( _):
                        print("👻 idkoten 재발급 후, queue 통신 성공!! studylist = \(studylist)")
                        let vc = SearchResultViewController()
//                        UserDefaultsManager.searchLAT = String(self!.searchCoordinate.lat)
//                        UserDefaultsManager.searchLONG = String(self!.searchCoordinate.long)
                        self?.transition(vc, transitionStyle: .push)
                        
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = SignupError(rawValue: code) else { return }
                        print("failure // code = \(code), errorCode = \(errorCode)")
                        switch errorCode {
                        default:
                            self?.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        }
                    }
                }
            }
        }
    }
}











