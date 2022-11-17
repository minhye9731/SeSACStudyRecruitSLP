//
//  LaunchScreenViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/17/22.
//

import UIKit
import FirebaseAuth
import Toast

final class LaunchScreenViewController: BaseViewController {
    
    // MARK: - property
    let iconImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Constants.ImageName.splashLogo.rawValue)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let logoLabelView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: Constants.ImageName.splashText.rawValue)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        [iconImageView, logoLabelView].forEach {
            view.addSubview($0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.startByState()
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        iconImageView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.view).inset(77)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.65)
            $0.height.equalTo(iconImageView.snp.width).multipliedBy(1.2)
        }
        logoLabelView.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(28)
            $0.horizontalEdges.equalTo(self.view).inset(42)
            $0.height.equalTo(logoLabelView.snp.width).multipliedBy(0.34)
        }
    }

    func startByState() {
        
        if true { // 앱 첫 실행하는 유저일 경우(최초사용자일 경우)
            if true { // 토큰 존재여부 (로그인해서 쓰다가 잠깐 나갔다온경우)
                // 토큰 없으면 로그인하러
                changeRootVC(vc: PhoneNumberViewController())
            } else {
                // 토큰 았으면, 해당정보로 로그인 시도
                let api = APIRouter.login
                Network.share.requestLogin(type: LoginResponse.self, router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let loginData):
                        
                        let vc = TabBarController()
                        // 데이터 통째로 전달?
                        self?.changeRootVC(vc: vc)
                        
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = LoginError(rawValue: code) else { return }
                        print("failure // code = \(code), errorCode = \(errorCode)")
                        
                        switch errorCode {
                        case .fbTokenError:
                            self?.refreshIDToken()
                        case .unknownUser:
                            self?.changeRootVC(vc: NickNameViewController())
                        case .serverError:
                            self?.showAlertMessage(title: "서버에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)")
                        case .clientError:
                            self?.changeRootVC(vc: PhoneNumberViewController())
                        default:
                            self?.view.makeToast(errorCode.errorDescription, duration: 1.0, position: .center)
                        }
                    }
                }
            }
        } else {
            self.changeRootVC(vc: OnBoardingViewController())
        }
    }
    
    func refreshIDToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error as? NSError {
                guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else { return }
                switch errorCode {
                default:
                    self.view.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
                }
                return
            } else if let idToken = idToken {
                UserDefaults.standard.set(idToken, forKey: "idtoken")
                let api = APIRouter.login
                Network.share.requestLogin(type: LoginResponse.self, router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let loginData):
                        let vc = TabBarController()
                        // 데이터 통째로 전달?
                        self?.changeRootVC(vc: vc)
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = LoginError(rawValue: code) else { return }
                        switch errorCode {
                        case .unknownUser:
                            self?.changeRootVC(vc: NickNameViewController())
                        default:
                            self?.showAlertMessage(title: "서버에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)")
                        }
                    }
                }
            }
        }
    }
    
    
    
}
