//
//  WithdrawViewController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/17/22.
//

import UIKit
import FirebaseAuth

final class PopUpViewController: BaseViewController {
    
    // MARK: - property
    var popupMode: PopupMode = .withdraw
    var otheruid = ""
    var matchingMode: MatchingMode = .normal // 들어올때 판별해서 넣어주자. 스터디 취소시에 문구 구분용임.
    
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    let maintitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = CustomFonts.body1_M16()
        label.textAlignment = .center
        return label
    }()
    let subtitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = CustomFonts.title4_R14()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let cancelbtn: UIButton = {
        let button = UIButton.generalButton(title: "취소", textcolor: .black, bgcolor: ColorPalette.gray2, font: CustomFonts.body3_R14())
        button.layer.cornerRadius = 8
        return button
    }()
    let confirmbtn: UIButton = {
        let button = UIButton.generalButton(title: "확인", textcolor: .white, bgcolor: ColorPalette.green, font: CustomFonts.body3_R14())
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - lifecycle
    deinit {
        print("📡팝업화면 deinit")
    }
    
    // MARK: - functions
    override func configure() {
        super.configure()
        
        print("popupMode = \(popupMode), matchingMode = \(matchingMode)")
        
        view.layer.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6).cgColor
        
        view.addSubview(popupView)
        [maintitle, subtitle, cancelbtn, confirmbtn].forEach {
            popupView.addSubview($0)
        }
        
        cancelbtn.addTarget(self, action: #selector(calcenBtnTapped), for: .touchUpInside)
        confirmbtn.addTarget(self, action: #selector(confirmbtnTapped), for: .touchUpInside)
        setMainSubWords()
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let btnWidth = (popupView.frame.width - 40) / 2
        
        popupView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(popupMode.popupHeight.self)
            $0.centerY.equalTo(self.view.center)
        }
        
        maintitle.snp.makeConstraints {
            $0.horizontalEdges.equalTo(popupView).inset(10)
            $0.top.equalTo(popupView.snp.top).offset(16)
        }
        subtitle.snp.makeConstraints {
            $0.horizontalEdges.equalTo(popupView).inset(16.5)
            $0.top.equalTo(maintitle.snp.bottom).offset(8)
        }
        cancelbtn.snp.makeConstraints {
            $0.top.equalTo(subtitle.snp.bottom).offset(16)
            $0.leading.equalTo(popupView.snp.leading).offset(16)
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(cancelbtn.snp.width).multipliedBy(0.32)
        }
        confirmbtn.snp.makeConstraints {
            $0.centerY.equalTo(cancelbtn.snp.centerY)
            $0.leading.equalTo(cancelbtn.snp.trailing).offset(8)
            $0.width.equalTo(cancelbtn.snp.width)
            $0.height.equalTo(cancelbtn.snp.height)
            $0.trailing.equalTo(popupView.snp.trailing).offset(-16)
        }
    }
    
    func setMainSubWords() {
        if matchingMode == .normal {
            self.maintitle.text = "스터디를 종료하시겠습니까"
            self.subtitle.text = "상대방이 스터디를 취소했기 때문에 패널티가 부과되지 않습니다"
        } else {
            maintitle.text = popupMode.mainAnnouncement?.description
            subtitle.text = popupMode.subAnnouncement?.description
        }
    }
    
    @objc func calcenBtnTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func confirmbtnTapped() {
        
        switch popupMode {
        case .withdraw:
            withdraw()
            return
            
        case .askStudy:
            studyRequest()
            return
            
        case .acceptStudy:
            studyaccept()
            return
            
        case .cancelStudy:
            studyCancel()
            return
        }
    }
    
}

// MARK: - withdraw method
extension PopUpViewController {
    
    func withdraw() {
        
        let api = APIRouter.withdraw
        
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status = WithdrawError(rawValue: statusCode) else { return }
            print("탈퇴 상태 결과 : \(value), \(statusCode)")
            
            switch status {
            case .success:
                self?.view.makeToast("회원탈퇴가 성공적으로 완료되었습니다.", duration: 1.0, position: .center) { didTap in
                    let vc = OnBoardingViewController()
                    self?.changeRootVC(vc: vc)
                }
                return
            case .fbTokenError:
                self?.refreshIDTokenWithdraw()
                return
            case .unknownUser:
                self?.view.makeToast("이미 탈퇴 처리된/미가입 사용자입니다.", duration: 1.0, position: .center) { didTap in
                    let vc = OnBoardingViewController()
                    self?.changeRootVC(vc: vc)
                }
                return
            default:
                self?.view.makeToast(status.errorDescription, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenWithdraw() {
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
                
                let api = APIRouter.withdraw
                
                Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let value = value else { return }
                    guard let statusCode = statusCode else { return }
                    guard let status = WithdrawError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        self?.view.makeToast("회원탈퇴가 성공적으로 완료되었습니다.", duration: 1.0, position: .center) { didTap in
                            let vc = OnBoardingViewController()
                            self?.changeRootVC(vc: vc)
                        }
                        return
                    default:
                        self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
}

// MARK: - studyrequest
extension PopUpViewController {
    
    func studyRequest() {
    
        let api = StudyAPIRouter.requestStudy(otheruid: otheruid)
        print("요청하기 보낸 상대방 uid : \(otheruid)")
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let statusCode = statusCode else { return }
            guard let status = StudyRequestError(rawValue: statusCode) else { return }
            
            switch status {
            case .success:
                self?.dismiss(animated: true, completion: {
                    UIApplication.getTopVC()?.view.makeToast(status.studyRequestErrorDescription, duration: 1, position: .bottom)
                })
                return
                
            case .alreadyRequest:
                self?.studyaccept()
                return
                
            case .otherSesacStopped:
                self?.dismiss(animated: true, completion: {
                    UIApplication.getTopVC()?.view.makeToast(status.studyRequestErrorDescription, duration: 1, position: .bottom)
                })
                return
                
            case .fbTokenError:
                self?.refreshIDTokenStudyRequest()
                return
                
            default:
                self?.view.makeToast(status.studyRequestErrorDescription, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenStudyRequest() {
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
                
                let api = StudyAPIRouter.requestStudy(otheruid: self.otheruid)
                Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let statusCode = statusCode else { return }
                    guard let status = StudyRequestError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        self?.dismiss(animated: true, completion: {
                            UIApplication.getTopVC()?.view.makeToast(status.studyRequestErrorDescription, duration: 1, position: .bottom)
                        })
                        return
                        
                    case .alreadyRequest:
                        self?.studyaccept()
                        return
                        
                    case .otherSesacStopped:
                        self?.dismiss(animated: true, completion: {
                            UIApplication.getTopVC()?.view.makeToast(status.studyRequestErrorDescription, duration: 1, position: .bottom)
                        })
                        return
                        
                    default:
                        self?.view.makeToast(status.studyRequestErrorDescription, duration: 1.0, position: .center)
                        return
                    }
                }
            }
            
        }
    }
}

// MARK: - studyaccept
extension PopUpViewController {
    
    func studyaccept() {
        print("스터디 요청을 수락했습니다.")
        
        let api = StudyAPIRouter.acceptStudy(otheruid: otheruid)
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let statusCode = statusCode else { return }
            guard let status = StudyAcceptError(rawValue: statusCode) else { return }
            
            switch status {
            case .success:
                
                if self?.popupMode == .askStudy {
                    self?.dismiss(animated: true, completion: {
                        UIApplication.getTopVC()?.view.makeToast("상대방도 스터디를 요청하여 매칭되었습니다. 잠시 후 채팅방으로 이동합니다", duration: 1, position: .bottom) { didTap in
                            let vc = ChattingViewController()
                            UIApplication.getTopVC()?.navigationController?.pushViewController(vc, animated: true)
                        }
                    })
                } else {
                    self?.dismiss(animated: true, completion: {
                            let vc = ChattingViewController()
                            UIApplication.getTopVC()?.navigationController?.pushViewController(vc, animated: true)
                    })
                }
                return
                
            case .otherSesacAlreadyMatched:
                self?.view.makeToast(status.studyAccepterrorDescription, duration: 0.5, position: .center)
                return
                
            case .otherSesacStopped:
                self?.view.makeToast(status.studyAccepterrorDescription, duration: 0.5, position: .center)
                return
                
            case .alreadyAccepted:
                self?.view.makeToast(status.studyAccepterrorDescription, duration: 0.5, position: .center) {didTap in
                    self?.myQueueState()
                }
                return
                
            case .fbTokenError:
                self?.refreshIDTokenStudyAccept()
                return
                
            default:
                self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenStudyAccept() {
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
                
                let api = StudyAPIRouter.acceptStudy(otheruid: self.otheruid)
                Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let statusCode = statusCode else { return }
                    guard let status = StudyAcceptError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
                        if self?.popupMode == .askStudy {
                            self?.dismiss(animated: true, completion: {
                                UIApplication.getTopVC()?.view.makeToast("상대방도 스터디를 요청하여 매칭되었습니다. 잠시 후 채팅방으로 이동합니다", duration: 1, position: .bottom) { didTap in
                                    let vc = ChattingViewController()
                                    UIApplication.getTopVC()?.navigationController?.pushViewController(vc, animated: true)
                                }
                            })
                        } else {
                            self?.dismiss(animated: true, completion: {
                                    let vc = ChattingViewController()
                                    UIApplication.getTopVC()?.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                        return
                        
                    case .otherSesacAlreadyMatched:
                        self?.view.makeToast(status.studyAccepterrorDescription, duration: 0.5, position: .center)
                        return
                        
                    case .otherSesacStopped:
                        self?.view.makeToast(status.studyAccepterrorDescription, duration: 0.5, position: .center)
                        return
                        
                    case .alreadyAccepted:
                        self?.view.makeToast(status.studyAccepterrorDescription, duration: 0.5, position: .center) {didTap in
                            self?.myQueueState()
                        }
                        return
                        
                    default:
                        self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
    
}

// MARK: - studyCancel
extension PopUpViewController {
    
    func studyCancel() {
        print("스터디 요청을 취소했습니다.")
        
        let api = StudyAPIRouter.cancelStudy(otheruid: otheruid)
        print("otheruid = \(otheruid)")
        Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
            
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status = DodgeError(rawValue: statusCode) else { return }
            print("취소 상태 결과 : \(value), \(statusCode)")
            
            switch status {
            case .success:
                print("스터디 취소는 성공이다~")
                
                self?.dismiss(animated: true, completion: {
//                    guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.navigationController?.topViewController else { return }
//
//                    viewController.navigationController?.popToRootViewController(animated: true)
                    let vc = TabBarController()
                    self?.changeRootVC(vc: vc)
                    
                })

                
                return
                
            case .wrongOtherUid:
                self?.view.makeToast("스터디 취소 상대방 정보를 다시 확인해주세요.", duration: 1.0, position: .center)
                return
                
            case .fbTokenError:
                self?.refreshIDTokenStudyCancel()
                return
                
            default:
                self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                return
            }
        }
    }
           
    func refreshIDTokenStudyCancel() {
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
                
                let api = StudyAPIRouter.cancelStudy(otheruid: self.otheruid)
                Network.share.requestForResponseStringTest(router: api) { [weak self] (value, statusCode, error) in
                    
                    guard let value = value else { return }
                    guard let statusCode = statusCode else { return }
                    guard let status =  DodgeError(rawValue: statusCode) else { return }
                    
                    switch status {
                    case .success:
//                        self?.navigationController?.popViewControllers(3)
                        return
                        
                    default:
                        self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
            

}

// MARK: - myQueueState
extension PopUpViewController {
    
    func myQueueState() {
        let api = QueueAPIRouter.myQueueState
        Network.share.requestMyQueueState(router: api) { [weak self] (value, statusCode, error) in
            guard let value = value else { return }
            guard let statusCode = statusCode else { return }
            guard let status = MyQueueStateError(rawValue: statusCode) else { return }
            print("⭐️value : \(value), ⭐️statusCode: \(statusCode)")
            
            switch status {
            case .success:
                switch self?.popupMode {
                case .acceptStudy:
                    if value.matched == 1 {
                        
                        self?.dismiss(animated: true, completion: {
                            UIApplication.getTopVC()?.view.makeToast("\(value.matchedNick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다.", duration: 1.0, position: .center) { didTap in
                                let vc = ChattingViewController()
                                UIApplication.getTopVC()?.navigationController?.pushViewController(vc, animated: true)
                            }
                        })
                    }
                    return
                    
                case .cancelStudy:
                    if value.matched == 1 {
                        
                    }
                    return
                    
                default:
                    print("")
                    return
                }
            case .normalStatus:
                switch self?.popupMode {
                case .cancelStudy:
                    if value.matched == 1 {
                        self?.maintitle.text = "스터디를 종료하시겠습니까"
                        self?.subtitle.text = "상대방이 스터디를 취소했기 때문에 패널티가 부과되지 않습니다"
                    }
                    return
                    
                default:
                    print("")
                    return
                }
                
                
            case .fbTokenError:
                self?.refreshIDTokenMyQueue()
                return
                
            default:
                self?.view.makeToast(status.errorDescription, duration: 1.0, position: .center)
                return
            }
        }
    }
    
    func refreshIDTokenMyQueue() {
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
                
                let api = QueueAPIRouter.myQueueState
                Network.share.requestMyQueueState(router: api) { [weak self] (value, statusCode, error) in
                    guard let value = value else { return }
                    guard let statusCode = statusCode else { return }
                    guard let status = MyQueueStateError(rawValue: statusCode) else { return }
                    print("⭐️value : \(value), ⭐️statusCode: \(statusCode)")
                    
                    switch status {
                    case .success:
                        if value.matched == 1 {
                            self?.view.makeToast("\(value.matchedNick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다.", duration: 1.0, position: .center) { didTap in
                                let vc = ChattingViewController()
                                self?.transition(vc, transitionStyle: .push)
                            }
                        }
                        return
                    default:
                        self?.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요. :)", duration: 1.0, position: .center)
                        return
                    }
                }
            }
        }
    }
    

}




