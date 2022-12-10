//
//  WriteReviewViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/28/22.
//

import UIKit
import FirebaseAuth

final class WriteReviewViewController : BaseViewController {
    
    enum Section {
        case main
    }
    
    // MARK: - property
    let mainView = WriteReviewView()
    var otherSesacUID = ""
    var otherSesacNick = ""
    var reputation = ["0", "0", "0", "0", "0", "0"]
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    let reviewSet = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
    
    // MARK: - Lifecycle
    override func loadView()  {
        self.view = mainView
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        view.layer.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6).cgColor
        mainView.subtitle.text = "\(otherSesacNick)님과의 스터디는 어떠셨나요?"

        mainView.closebtn.addTarget(self, action: #selector(closebtnTapped), for: .touchUpInside)
        mainView.registerbtn.addTarget(self, action: #selector(registerbtnTapped), for: .touchUpInside)
        
        configureDataSource()
        mainView.collectionView.delegate = self
        mainView.reviewTextView.delegate = self
    }
    
}

// MARK: - collectionView
extension WriteReviewViewController {

    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TagCell, String> { (cell, indexPath, identifier) in
            
            cell.setReviewData(reputation: self.reputation, indexPath: indexPath, identifier: identifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: mainView.collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(reviewSet)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

// MARK: - 리뷰 클릭시
extension WriteReviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reputation[indexPath.row] = reputation[indexPath.row] == "0" ? "1" : "0"
        self.mainView.collectionView.reloadData()
    }
}

// MARK: - textview
extension WriteReviewViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.textColor = ColorPalette.gray7
            textView.text = Constants.Word.reviewPlaceholder.rawValue
        } else if textView.text == Constants.Word.reviewPlaceholder.rawValue {
            textView.textColor = .black
            textView.text = nil
        }
        textView.textColor = .black
    }
        
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 500 { textView.deleteBackward() }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == Constants.Word.reviewPlaceholder.rawValue {
            textView.textColor = ColorPalette.gray7
            textView.text = Constants.Word.reviewPlaceholder.rawValue
        }
    }
        
}

// MARK: - 기타
extension WriteReviewViewController {
    
    @objc func closebtnTapped() {
        dismiss(animated: true)
    }
    
    @objc func registerbtnTapped() {
        requestRateAPI()
        print("리뷰쓰기")
    }
}

// MARK: - 통신 API
extension WriteReviewViewController {
    
    func requestRateAPI() {
        
        reputation.append(contentsOf: ["0", "0", "0"])
        print(reputation)
        
        guard let review = mainView.reviewTextView.text == Constants.Word.reviewPlaceholder.rawValue ? "" : mainView.reviewTextView.text else { return }
        print(review)
        
        Network.share.requestRate(uid: otherSesacUID, rep: self.reputation, com: review ) { [weak self] (value, statusCode, error) in

            guard let statusCode = statusCode else { return }
            guard let status =  RateError(rawValue: statusCode) else { return }
            print("👁리뷰쓰기 statusCode : \(statusCode)")
            switch status {
            case .success:
                print("홈 화면으로 이동")
                guard let presentingViewController = self?.presentingViewController as? UINavigationController else { return }

                self?.dismiss(animated: true, completion: {
                    presentingViewController.popToRootViewController(animated: true)
                })
                
            case .fbTokenError:
                self?.refreshIDTokenRate()
                return
            default :
                self?.mainView.makeToast(status.errorDescription, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenRate() {
        guard let review = mainView.reviewTextView.text == Constants.Word.reviewPlaceholder.rawValue ? "" : mainView.reviewTextView.text else { return }
        print(review)
        
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

                Network.share.requestRate(uid: self.otherSesacUID, rep: self.reputation, com: review) { [weak self] (value, statusCode, error) in

                    guard let statusCode = statusCode else { return }
                    guard let status =  RateError(rawValue: statusCode) else { return }
                    print("👁리뷰쓰기 statusCode : \(statusCode)")

                    switch status {
                    case .success:
                        print("홈 화면으로 이동")
                        guard let presentingViewController = self?.presentingViewController as? UINavigationController else { return }

                        self?.dismiss(animated: true, completion: {
                            presentingViewController.popToRootViewController(animated: true)
                        })
                        
                    default :
                        self?.mainView.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
}


