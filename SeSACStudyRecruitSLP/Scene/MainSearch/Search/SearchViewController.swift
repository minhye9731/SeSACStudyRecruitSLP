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

final class SearchViewController: BaseViewController {
    
    // MARK: - property
    let mainView = SearchView()
    var searchCoordinate = UserLocationDTO(lat: 37.517819364682694, long: 126.88647317074734) // 화면 넘어올떄 받아주는 값
    //test
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
        searchNetwork(location: searchCoordinate) // 검색하고자 하는 위치 근방의 새싹들의 스터디 목록 표현하기 서버통신
        
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 리턴키가 아닌,, [새싹찾기] 액세서리 버튼 클릭시 실행됨...
        
    }
    
    // 서치바 입력(리턴키)을 통해 스터디를 [내가 하고싶은] 섹션에 추가
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
        var inputStudy = text.components(separatedBy: " ")
        let inputStudyLength = inputStudy.map { $0.count }
        print(inputStudy)
        print(inputStudyLength)
        
        
        if inputStudyLength.min()! < 1 || inputStudyLength.max()! > 8  {
            mainView.makeToast("스터디명은 최소 한 자 이상, 최대 8글자까지 작성 가능합니다.", duration: 0.5, position: .center)
            return true
        } else if (inputStudy.count + mywishTagList.count) > 8 { // 복수개의 스터디 등록 시도할 경우(6 + 3), 총합 8개 이상이 되므로 막아야 함
            mainView.makeToast("내가 하고 싶은 스터디는 8개까지만 등록이 가능합니다.", duration: 0.5, position: .center)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    @objc func searchBtnTapped() {
        // 스터디를 함께할 새싹을 찾는 요청을 서버에 보냄
        
        let vc = SearchResultViewController()
        transition(vc, transitionStyle: .push)
    }
    
}

// MARK: - search 통신
extension SearchViewController {
    
    func searchNetwork(location: UserLocationDTO) {
        
        print(#function)
        
        
        let api = APIRouter.search(lat: String(location.lat), long: String(location.long))
        Network.share.requestLogin(type: SearchResponse.self, router: api) { [weak self] response in
            
            switch response {
            case .success(let searchResult):
                print("🦄search 통신 성공!!")
                print("🦄searchResult = \(searchResult)")
                self?.aroundTagList.removeAll()
                
                self?.aroundTagList.append(contentsOf: searchResult.fromRecommend) // 추천스터디 추가
                self?.rocommendNum = searchResult.fromRecommend.count // 추천스터디 수
                searchResult.fromQueueDB.forEach { self?.aroundTagList.append(contentsOf: $0.studylist) } // fromQueueDB 스터디 추가
                searchResult.fromQueueDBRequested.forEach { self?.aroundTagList.append(contentsOf: $0.studylist) } // fromQueueDBRequested 스터디 추가
                print("👍🏻추천스터디 + 주변새싹들의 스터디 모음 : \(self?.aroundTagList)")
                
                self?.mainView.collectionView.reloadData()
                
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = LoginError(rawValue: code) else { return }
                print("failure // code = \(code), errorCode = \(errorCode)")
                
                switch errorCode {
                case .fbTokenError:
                    self?.refreshIDToken(location: location)
                default :
                    self?.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", duration: 1.0, position: .center)
                }
            }
        }
    }
    
    func refreshIDToken(location: UserLocationDTO) {
        
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
                
                let api = APIRouter.search(lat: String(location.lat), long: String(location.long))
                Network.share.requestLogin(type: SearchResponse.self, router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let searchResult):
                        print("🦄search 통신 성공!!")
                        print("🦄searchResult = \(searchResult)")
                        self?.aroundTagList.removeAll()
                        
                        self?.aroundTagList.append(contentsOf: searchResult.fromRecommend) // 추천스터디 추가
                        self?.rocommendNum = searchResult.fromRecommend.count // 추천스터디 수
                        searchResult.fromQueueDB.forEach { self?.aroundTagList.append(contentsOf: $0.studylist) } // fromQueueDB 스터디 추가
                        searchResult.fromQueueDBRequested.forEach { self?.aroundTagList.append(contentsOf: $0.studylist) } // fromQueueDBRequested 스터디 추가
                        print("👍🏻추천스터디 + 주변새싹들의 스터디 모음 : \(self?.aroundTagList)")
                        
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
    
    
    
    
    
    
    
    
    
    
    
    
