![핵심이미지slp5개](https://user-images.githubusercontent.com/53211818/209386633-c086b606-8e92-4036-91f6-c77b29aad3bb.jpeg)

# SeSAC Study Recruit

![180](https://user-images.githubusercontent.com/53211818/209387248-98f34b1e-2d67-403c-a161-b51eba55b798.png)
### 위치 기반 스터디(모각코) 서비스(SeSAC Study)🌱

* 핵심 기능
  * 🗺 위치 기반, 근방에 스터디를 원하는 사람을 찾아서 요청을 보냄
  * 💬 상대방이 스터디를 수락하면 채팅방이 열리며 채팅할 수 있음
  * 🛒 원하는 새싹 이미지, 배경 이미지를 인앱결제로 구매할 수 있음
  * 📝 내정보 관리에서 나의 성별, 검색허용 여부, 상대방 연령대 설정 및 탈퇴 가능

* 프로젝트 목적
  * ✅ 실무 환경과 동일한 개발 프로세스 진행 - Figma, Swagger, Confluence
  * ✅ 혼자 학습하기에 제한적인 기술이 적용된 서비스 구현 - Auth, RESTful API, Socket, IAP(인앱결제), Remote Push
  * ✅ 의도된 기획 변경, 장애, 이슈사항 해결


('모각코'란? = 모여서 각자 코딩)

## 개발기간
- 2022.11.08 ~ 2022.12.18 (6주)

## 개발환경
* Xcode 14.1.0
* Deployment Target iOS 15.0

## 기술스택 및 라이브러리
|     구분    |    Skill  |
| :--------: | :-------- |
|     iOS      | Foundation, UIKit, MapKit, CoreLocation, StoreKit, MessageUI |
|     UI화면    | AutoLayout, SnapKit, Compositional Layout, RxSwift, RXCocoa, RxKeyboard |
|   디자인 패턴   | MVC, MVVM, Singleton, Repository |
|    네트워크    | Alamofire |
| 오픈 라이브러리 | FirebaseAuth, FirebaseMessaging, IQKeyboardManagerSwift, Realm, Toast, Tabman, Socket.I.O |
|     기타     | UserDefaults, Diffable DataSource, Extension, Protocol, Closure, DTO, Codable, CustomColor, CustomFont, CustomView, CustomAnnotation, NSPredicate, UUID |

## 화면별 주요기능
* FirebaseAuth로 로그인 기능, 회원가입 구현시 임시저장값들 `UserDefaults property`로 관리
* 로그인/회원가입 구현시 이메일, 전화번호에 대해 `정규표현식`과 `Reactive Programming`으로 `유효성 검사`
* `Firebase Cloud Messaging`으로 발급받은 `FCM token`으로 유저의 `멀티 디바이스` 사용 대응
* `CoreLocation`과 `Mapkit`으로 지도내 주변새싹 위치 `Custom Annotation` 표기
* `RESTful API` 네트워크 실행시 `URLRequestConvertible`로 `router` 모듈화
* `Enum`으로 페이지모드를 case별로 구분하여 전체팝업 `ViewController 재사용`
* 스터디 수락/요청에 대해 특정 페이지에서 사용자 상태변화 감지시 `Timer`설정으로 `과도한 네트워크 호출 방지`
* `Socket.I.O` 실시간 채팅기능 구현시 `Realm DB`로 채팅내역 관리하여 `과도한 네트워크 호출 방지`
* `StoreKit`로 인앱결제 구현시 자체서버로 `RESTFul API`를 통한 `receiptValidation` 및 `transaction` 관리
* `Firebase Cloud Messaging`으로 스터디 요청, 매칭완료, 채팅수신 `Push Notification 적용


## 트러블 슈팅
[📗트러블슈팅 list](https://mhkang.notion.site/SeSAC-Study-Recruit-19818240bbff4f32978af0f1f7e87f9f)  

* 중복리뷰 문구로 인해 `DiffableDataSource`의 `ItemIdentifier`가 고유하지 이슈발생  
  &rarr; UUID값을 갖는 Review구조체를 생성하고 ItemIdentifierType을 전부 String에서 Review로 변경하여 해결
  
```swift
struct Review: Hashable {
    let identifier = UUID()
    var comment: String
}

final class MoreReviewViewController: BaseViewController {
    var dataSource: UICollectionViewDiffableDataSource<Section, Review>!
    var reviewList: [Review] = []
		...
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration
        <ReviewCollectionViewCell, Review> { (cell, indexPath, reviewItem) in
            cell.reviewLabel.text = reviewItem.comment
        }
        
        dataSource = UICollectionViewDiffableDataSource
        <Section, Review>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Review) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Review>()
        snapshot.appendSections([.main])
        snapshot.appendItems(reviewList)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

```
<br>  

* 입력 키워드 길이에 따른 `UICollectionViewCell`의 크기조절 이슈, `UIButton.Configuration`의 image 색상 미적용 이슈  
  &rarr; sizeForItemAt에서 입력테스트 뿐만 아니라 image 크기까지 고려한 값을 return하도록 수정, 이미지의 `withRenderingMode`를 `alwaysTemplate`로 적용하여 해결
  
```swift
extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label: UILabel = {
            let label = UILabel()
            label.font = CustomFonts.title4_R14()
            label.text = indexPath.section == 0 ? aroundTagList[indexPath.item] : mywishTagList[indexPath.item]
            label.sizeToFit()
            return label
        }()
        
        let size = label.frame.size
        
        return indexPath.section == 0 ? CGSize(width: size.width + 32, height: 32) : CGSize(width: size.width + 52, height: 32) // section으로 분기처리하여 width 설정
    }
}
```
```swift
class MyTagCell: BaseCollectionViewCell {
  let myTabButton: UIButton = {
       let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.image = UIImage(named: Constants.ImageName.smallClose.rawValue)?.withRenderingMode(.alwaysTemplate) // withRenderingMode 추가적용
        config.baseForegroundColor = ColorPalette.green
        config.imagePadding = 4
        config.imagePlacement = NSDirectionalRectEdge.trailing
        
        btn.configuration = config
        btn.setTitleColor(ColorPalette.green, for: .normal)
        return btn
    }()
  }
}
```
<br>  

* 뒤로가기 커스텀 이미지를 적용하고자 `UIBarButtonItem`으로 이미지 변경시 2개의 뒤로가기 버튼이 보이는 이슈
  &rarr; UIBarButtonItem으로 추가생성이 아닌 `backIndicatorImage`를 사용하여 이미지만 변경  
  
```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		UINavigationBar.appearance().backIndicatorImage = UIImage(named: "sesacBack")?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -12.0, bottom: 0.0, right: 0.0))
		UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "sesacBack")
		UINavigationBar.appearance().tintColor = .black
		return true
	}
}

// baseviewcontroller에서 기존의 기본 백버튼 문구 안보이게끔 처리
class BaseViewController: UIViewController {
	override func viewDidLoad() {
	super.viewDidLoad()
	        configure()
  }
    
	func configure() {
		setNavi()
	}

	func setNavi() {
	  self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
	}
}
```

* 새싹찾기에서 리스트로 보이는 UserCard를 `tableViewHeaderView`로 적용해서 `sticky header` 이슈 발생  
  &rarr; tableview의 `style`을 `grouped`로 변경하고, `section`간 간격을 삭제하고, `footer`높이를 최소 설정하여 해결  
  
```swift
lazy var tableView: UITableView = {
	let tableview = UITableView(frame: .zero, style: .grouped) // style을 grouped로 변경
	...
  tableview.tableFooterView =
	  UIView(frame: CGRect(origin: .zero,
                             size: CGSize(width:CGFloat.leastNormalMagnitude,
                                          height: CGFloat.leastNormalMagnitude))) // footerView 높이 최소설정
  tableview.backgroundColor = .white // 배경색상 변경하여 section header와 cell간 배경색상 통일해줌
        return tableview
    }()

func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude // section간 간격 삭제
    }
```  


## 회고

[🧐상세한 회고 보러가기![SeSAC Study Post-Mortem]](https://wannab-it-pm.tistory.com/130)

Good👍 에셋을 Enum으로 관리하여 데이터 일관성 부여  
Good👍 API Router적용 및 종류별로 관리하여 코드 가독성 향상, 네트워크 통신코드 간편 사용  
Good👍 반복UI는 커스텀하고 반복뷰컨 재사용하여 코드의 재사용성 향상  
Good👍 서비스적인 고려사항을 고민하고 기획자와 소통하며 작업  
  
Bad👎 RxSwift, MVVM사용이 적절한 곳에 충분히 활용하지 못했고 추가 공부의 필요성을 느낌  
Bad👎 API별 Error관리시 여러개가 아닌 하나의 Enum으로 관리할 수 있도록 통합적인 구조개선 필요
Bad👎 싱글톤으로 정리할 수 있는 기능들을 뷰컨에서 분리하여 별도 정리 필요  
(ex. locationManager, SocketManager,IAPHelper 등) 


## 개발과정
|  구분  |     월     |     화     |     수     |     목     |     금     |     토     |     일     |
| ----- | :--------: | :--------: | :--------: | :--------: | :--------: | :--------: | :--------: |
| Week1 |     🌱     | [20221108] | 온보딩UI 구현 | [20221110] | [20221111] | [20221112] | [20221113] |
| Week2 | [20221114] | [20221115] | [20221116] | [20221117] | [20221118] | [20221119] | [20221120] |
| Week3 | [20221121] | [20221122] | [20221123] | [20221124] | [20221125] | [20221126] | [20221127] |
| Week4 | [20221128] | [20221129] | [20221130] | [20221201] | [20221202] | [20221203] | [20221204] |
| Week5 | [20221205] | [20221206] | [20221207] | dodge API 개선 | UserCard 개선 | [20221210] | rate API 적용 |
| Week6 | [20221212] | [20221213] | [20221214] | [20221215] | [20221216] | [20221217] | [20221218] |

   [20221108]: <https://mhkang.notion.site/11-08-8f65d1b818434e4ba73f40a111a5db5d>
   [20221110]: <https://mhkang.notion.site/11-10-a8991e71bafb422398aa63cf4585cb74>
   [20221111]: <https://mhkang.notion.site/11-11-55da8df0f12140b9ac296f2899882a19>
   [20221112]: <https://mhkang.notion.site/11-12-a9ee6259d01c4e428ed91be7f9e5f9dc>
   [20221113]: <https://mhkang.notion.site/11-13-0510002d440f47b18d688f0b4f98ad94>
   
   [20221114]: <https://mhkang.notion.site/11-14-bffefda9d1d04e03896a46ff5a3aaa96>
   [20221115]: <https://mhkang.notion.site/11-15-31594813ec1f489a81f3c283f497a091>
   [20221116]: <https://mhkang.notion.site/11-16-3a9c3fd92cf8483a81f3550e92d24560>
   [20221117]: <https://mhkang.notion.site/11-17-2974e5011f19482f8eec8a29573a2a0b>
   [20221118]: <https://mhkang.notion.site/11-18-f7470af089cb47298e8785b0a1bb0cee>
   [20221119]: <https://mhkang.notion.site/11-19-560fee0d11ce4dfea0e81de9aa682976>
   [20221120]: <https://mhkang.notion.site/11-20-495b1da625f44534a8df656c28ef262f>
   
   [20221121]: <https://mhkang.notion.site/11-21-fef06091606e4a0ab28af41b7f9930d5>
   [20221122]: <https://mhkang.notion.site/11-22-fdf96a249cdc4bee8431f1b864e5c023>
   [20221123]: <https://mhkang.notion.site/11-23-5a06db5cdd3c47e5880c596bb7e7adf0>
   [20221124]: <https://mhkang.notion.site/11-24-2cc355ad299d4bb4b74863a6f07ffd79>
   [20221125]: <https://mhkang.notion.site/11-25-86175aa154d9439db9ebd2ea2ecd3c8d>
   [20221126]: <https://mhkang.notion.site/11-26-4027dc0f9f4f466b83008dc250fa2918>
   [20221127]: <https://mhkang.notion.site/11-27-5dd215908914421889aaa942a308b35a>
   
   [20221128]: <https://mhkang.notion.site/11-28-3dc5602238024c27b2357abdd8db552c>
   [20221129]: <https://mhkang.notion.site/11-29-8224e6c2340f46e3855f0a8b5914a4f5>
   [20221130]: <https://mhkang.notion.site/11-30_-a226a525a0df425aa85af588123ead0d>
   [20221201]: <https://mhkang.notion.site/12-1-bcb4759643eb4d4685c53c041bcd9ac2>
   [20221202]: <https://mhkang.notion.site/12-2-b3743923e2c6498a88fff39a7675428d>
   [20221203]: <https://mhkang.notion.site/12-3-d9137fa9088a4fb4bd04b89055f0680a>
   [20221204]: <https://mhkang.notion.site/12-4-d4ce984883904fad93ea7ad11720e0d4>

   [20221205]: <https://mhkang.notion.site/12-5-c3c13e205f4544a7a961926af9e4fef5>
   [20221206]: <https://mhkang.notion.site/12-6-23b3261df115428fa92569effc952933>
   [20221207]: <https://mhkang.notion.site/12-7-f555d1bed6204981bd7ed99b7d3c1ca6>
   [20221210]: <https://mhkang.notion.site/12-10-012cd5d13ee64745b5330c54301511f4>
   
   [20221212]: <https://mhkang.notion.site/12-12-d611a5df85c34d69a0dfc36a5c48f003>
   [20221213]: <https://www.notion.so/mhkang/12-13-fe300be0e9c040ec97a0eb53627fb435>
   [20221214]: <https://mhkang.notion.site/12-14-e44a9d4582bb42b6a270a3b8dffa3509>
   [20221215]: <https://mhkang.notion.site/12-15-3d7d887b70094cfd9b223fbb260a73e4>
   [20221216]: <https://mhkang.notion.site/12-16-52efc17274f34ce7a12a6f62b2e50a06>
   [20221217]: <https://mhkang.notion.site/12-17-38ed0a0ab4f84b83a634de296520359a>
   [20221218]: <https://mhkang.notion.site/12-18-c6f085d794644fec98d9d1eb540035e6>
