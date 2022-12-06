////
////  GenderViewModel.swift
////  SeSACStudyRecruitSLP
////
////  Created by 강민혜 on 11/10/22.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//final class GenderViewModel: CommonViewModel {
//
//    // MARK: - property
//    let signup = PublishSubject<String>()
//
//    struct Input {
//        let maleTap: ControlEvent<Void>
//        let femaleTap: ControlEvent<Void>
//        let nextTap: ControlEvent<Void>
//    }
//
//    struct Output {
//        let tap: ControlEvent<Void>
//    }
//
//    // MARK: - functions
//    func transform(input: Input) -> Output {
//        return Output(tap: input.nextTap)
//    }
//
//    func getSignUp(userData: UserInfoDTO) {
//
//        let api = APIRouter.signup(phoneNumber: userData.phoneNumber, FCMtoken: userData.fcmToken, nick: userData.nickname, birth: userData.birth, email: userData.email, gender: String(userData.gender))
//        Network.share.requestForResponseString(router: api) { [weak self] response in
//
//            switch response {
//            case .success(let success):
//                self?.signup.onNext(success)
//            case .failure(let failure):
//                self?.signup.onError(failure)
//            }
//        }
//    }
//
//}
