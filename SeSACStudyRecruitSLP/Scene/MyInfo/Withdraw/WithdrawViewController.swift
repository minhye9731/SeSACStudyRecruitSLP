//
//  WithdrawViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/17/22.
//

import UIKit
import FirebaseAuth

final class WithdrawViewController: BaseViewController {
    
    // MARK: - property
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let maintitle: UILabel = {
        let label = UILabel()
        label.text = "정말 탈퇴하시겠습니까?"
        label.textColor = UIColor.black
        label.font = CustomFonts.body1_M16()
        label.textAlignment = .center
        return label
    }()
    let subtitle: UILabel = {
        let label = UILabel()
        label.text = "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ"
        label.textColor = UIColor.black
        label.font = CustomFonts.title4_R14()
        label.textAlignment = .center
        return label
    }()
    
    let cancelbtn: UIButton = {
        let button = UIButton.generalButton(title: "취소", textcolor: .black, bgcolor: ColorPalette.gray2, font: CustomFonts.body3_R14())
        button.layer.cornerRadius = 8
        return button
    }()
    let withdrawbtn: UIButton = {
        let button = UIButton.generalButton(title: "확인", textcolor: .white, bgcolor: ColorPalette.green, font: CustomFonts.body3_R14())
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        view.layer.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6).cgColor
        
        view.addSubview(popupView)
        [maintitle, subtitle, cancelbtn, withdrawbtn].forEach {
            popupView.addSubview($0)
        }
        
        cancelbtn.addTarget(self, action: #selector(calcenBtnTapped), for: .touchUpInside)
        withdrawbtn.addTarget(self, action: #selector(withdrawBtnTapped), for: .touchUpInside)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let btnWidth = (popupView.frame.width - 40) / 2
        
        popupView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(popupView.snp.width).multipliedBy(0.45)
            $0.centerY.equalTo(self.view.center)
        }
        
        maintitle.snp.makeConstraints {
            $0.horizontalEdges.equalTo(popupView).inset(16.5)
            $0.top.equalTo(popupView.snp.top).offset(16)
        }
        subtitle.snp.makeConstraints {
            $0.horizontalEdges.equalTo(popupView).inset(16.5)
            $0.top.equalTo(maintitle.snp.bottom).offset(8)
        }
        
        cancelbtn.snp.makeConstraints {
            $0.leading.equalTo(popupView.snp.leading).offset(16)
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(cancelbtn.snp.width).multipliedBy(0.32)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-16)
        }
        withdrawbtn.snp.makeConstraints {
            $0.leading.equalTo(cancelbtn.snp.trailing).offset(8)
            $0.width.equalTo(cancelbtn.snp.width)
            $0.height.equalTo(cancelbtn.snp.height)
            $0.trailing.equalTo(popupView.snp.trailing).offset(-16)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-16)
        }
    }
    
    @objc func calcenBtnTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func withdrawBtnTapped() {
        let api = APIRouter.withdraw
        Network.share.requestForResponseString(router: api) { [weak self] response in
            switch response {
            case .success(let success):
                self?.view.makeToast("회원탈퇴가 성공적으로 완료되었습니다.", duration: 0.5, position: .center)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    let vc = OnBoardingViewController()
                    self?.changeRootVC(vc: vc)
                }
            case .failure(let error):
                let code = (error as NSError).code
                guard let errorCode = SignupError(rawValue: code) else { return }
                print("failure // code = \(code), errorCode = \(errorCode)")
                
                switch errorCode {
                case .fbTokenError:
                    self?.refreshIDToken()
                case .unknownUser:
                    self?.view.makeToast("이미 탈퇴 처리된/미가입 사용자입니다.", duration: 0.5, position: .center)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let vc = OnBoardingViewController()
                        self?.changeRootVC(vc: vc)
                    }
                case .serverError:
                    self?.view.makeToast(errorCode.errorDescription, duration: 0.5, position: .center)
                case .clientError:
                    self?.view.makeToast(errorCode.errorDescription, duration: 0.5, position: .center)
                default:
                    self?.view.makeToast("\(error.localizedDescription)", duration: 0.5, position: .center)
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
                    self.view.makeToast("\(error.localizedDescription)", duration: 1.0, position: .center)
                }
                return
            } else if let idToken = idToken {
                UserDefaultsManager.idtoken = idToken
                print("🦄갱신된 idToken 저장완료 |  UserDefaultsManager.idtoken = \(UserDefaultsManager.idtoken)")
                
                let api = APIRouter.withdraw
                Network.share.requestForResponseString(router: api) { [weak self] response in
                    
                    switch response {
                    case .success(let success):
                        self?.view.makeToast("회원탈퇴가 성공적으로 완료되었습니다.", duration: 0.5, position: .center)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            let vc = OnBoardingViewController()
                            self?.changeRootVC(vc: vc)
                        }
                    case .failure(let error):
                        let code = (error as NSError).code
                        guard let errorCode = SignupError(rawValue: code) else { return }
                        switch errorCode {
                        case .unknownUser:
                            self?.view.makeToast("이미 탈퇴 처리된/미가입 사용자입니다.", duration: 0.5, position: .center)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                let vc = OnBoardingViewController()
                                self?.changeRootVC(vc: vc)
                            }
                        default:
                            self?.showAlertMessage(title: "서버에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)")
                        }
                    }
                }
            }
        }
    }
    
}
