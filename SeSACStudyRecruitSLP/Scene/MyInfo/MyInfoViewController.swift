//
//  MyInfoViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/14/22.
//

import UIKit
import SnapKit

struct MenuList: Hashable {
    let id = UUID().uuidString
    let title: String?
    let image: String
    let nextimage: String?
    
    static let menuContents = [
        // UserDefaults.standard.string(forKey: "nickName")
        MenuList(title: "홍길동", image: "AppIcon", nextimage: Constants.ImageName.more.rawValue),
        MenuList(title: "공지사항", image: Constants.ImageName.notice.rawValue, nextimage: nil),
        MenuList(title: "자주 묻는 질문", image: Constants.ImageName.faq.rawValue, nextimage: nil),
        MenuList(title: "1:1 문의", image: Constants.ImageName.qna.rawValue, nextimage: nil),
        MenuList(title: "알림 설정", image: Constants.ImageName.alarm.rawValue, nextimage: nil),
        MenuList(title: "이용약관", image: Constants.ImageName.permit.rawValue, nextimage: nil)
    ]
}

final class MyInfoViewController: BaseViewController {

    // MARK: - property
    let mainView = MyInfoView()
    
    // MARK: - Lifecycle
    override func loadView()  {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        self.title = "내정보"
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }

}

extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuList.menuContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell1 = tableView.dequeueReusableCell(withIdentifier: MyProfileInfoCell.reuseIdentifier) as? MyProfileInfoCell else { return  UITableViewCell() }
        guard let cell2 = tableView.dequeueReusableCell(withIdentifier: MyInfoCell.reuseIdentifier) as? MyInfoCell else { return UITableViewCell() }
        
        let contents = MenuList.menuContents[indexPath.row]
        
        if indexPath.row == 0 {
            tableView.rowHeight = 100
            cell1.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell1.cellTitle.text = contents.title
            cell1.cellImage.image = UIImage(named: contents.image)
            cell1.moreViewImage.image = UIImage(named: contents.nextimage!)
            return cell1
        } else {
            tableView.rowHeight = 80
            cell2.titleLabel.text = contents.title
            cell2.menuimage.image = UIImage(named: contents.image)
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = InfoManageViewController()
            transition(vc, transitionStyle: .push)
        }
    }
}




//final class MyInfoViewController: BaseViewController {
//
//    // MARK: - property
//    let mainView = MyInfoView()
//    static let sectionHeaderElementKind = "test"
//    var menuList = [
//        Menu(title: "홍길동", image: "AppIcon", nextimage: Constants.ImageName.more.rawValue),
//        Menu(title: "공지사항", image: Constants.ImageName.notice.rawValue, nextimage: Constants.ImageName.more.rawValue),
//        Menu(title: "자주 묻는 질문", image: Constants.ImageName.faq.rawValue, nextimage: ""),
//        Menu(title: "1:1 문의", image: Constants.ImageName.qna.rawValue, nextimage: ""),
//        Menu(title: "알림 설정", image: Constants.ImageName.alarm.rawValue, nextimage: ""),
//        Menu(title: "이용약관", image: Constants.ImageName.permit.rawValue, nextimage: "")
//    ]
//
//    private var dataSource: UICollectionViewDiffableDataSource<Int, Menu>!
//
//    // MARK: - Lifecycle
//    override func loadView()  {
//        super.loadView()
//        self.view = mainView
//    }
//
//    // MARK: - functions
//    override func configure() {
//        super.configure()
//        mainView.collectionView.collectionViewLayout = createLayout()
//        configureDataSource()
//        setNav()
//    }
//
//}
//
//// MARK: - compositional
//extension MyInfoViewController {
//
//    private func createLayout() -> UICollectionViewCompositionalLayout {
//
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .absolute(70))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 5
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
//
//        // headerview 정보 생성
////        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
////                                                      heightDimension: .fractionalHeight(100.0))
//
//        // section에 headerview 추가
////        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
////            layoutSize: headerFooterSize,
////            elementKind: UICollectionView.elementKindSectionHeader,
////            alignment: .top
////        )
////        section.boundarySupplementaryItems = [sectionHeader]
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
//
//    private func configureDataSource() {
//        let cellRegisteration = UICollectionView.CellRegistration<MyInfoCell, Menu>(handler: { cell, indexPath, itemIdentifier in
//
//            cell.menuimage.image = UIImage(named: itemIdentifier.image)
//            cell.titleLabel.text = itemIdentifier.title
//
//            if indexPath.row == 0 {
//                cell.menuimage.contentMode = .scaleAspectFit
//                cell.menuimage.image = UIImage(named: "AppIcon") // test 사용자 프로필
//                cell.menuimage.layer.borderWidth = 1
//                cell.menuimage.layer.borderColor = ColorPalette.gray2.cgColor
//                cell.menuimage.contentMode = .scaleAspectFill
//                cell.menuimage.layer.cornerRadius = 25
//                cell.menuimage.snp.makeConstraints { make in
//                    make.width.height.equalTo(50)
//                }
//
//                cell.titleLabel.font = CustomFonts.title1_M16()
//                cell.nextPage.image = UIImage(named: Constants.ImageName.more.rawValue)
//            }
//
//        })
//
//        // headerRegistration 생성
////        let headerRegistration = UICollectionView.SupplementaryRegistration<MycellHeaderView>(elementKind: MyInfoViewController.sectionHeaderElementKind) { supplementaryView, string, indexPath in
////
////            supplementaryView.profileimage.image = UIImage(named: "AppIcon") //test
////            supplementaryView.userNameLabel.text = "홍길동" // test
////        }
//
//        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
//            return cell
//        })
//
//        // datasource에서 supplementaryViewProvider를 적용 - 3
////        dataSource.supplementaryViewProvider = { (view, kind, index) in
////            if kind == UICollectionView.elementKindSectionHeader {
////                return self.mainView.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
////            }
////            else {
////                return nil
////            }
////        }
//
//        var snapshot = NSDiffableDataSourceSnapshot<Int, Menu>()
//        snapshot.appendSections([0])
//        snapshot.appendItems(menuList)
//        // 여기서 헤더를 줘라
//        dataSource.apply(snapshot)
//    }
//
//}

// UICollectionView
//extension MyInfoViewController  {
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MycellHeaderView.reuseIdentifier, for: indexPath) as! MycellHeaderView
//        return header
//    }
//
//}
