//
//  SignupError.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/13/22.
//

import Foundation

enum SignupError: Int, Error { // 그냥 에러로 통합하자.
    case success = 200
    case existUser = 201
    case invalidNickname = 202
    case cancelPenalty1 = 203
    case cancelPenalty2 = 204
    case cancelPenalty3 = 205
    case fbTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension SignupError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .success:
            return "로그인 성공"
        case .existUser:
            return "이미 가입된 사용자 정보입니다. 로그인 해주세요."
        case .invalidNickname:
            return "사용할 수 없는 닉네임입니다. 닉네임 변경 후 다시 회원가입 요청해주세요."
        case .cancelPenalty1:
            return "스터디 취소 패널티로, 1분동안 이용하실 수 없습니다"
        case .cancelPenalty2:
            return "스터디 취소 패널티로, 2분동안 이용하실 수 없습니다"
        case .cancelPenalty3:
            return "스터디 취소 패널티로, 3분동안 이용하실 수 없습니다"
        case .fbTokenError:
            return "토큰에러가 발생했습니다. 다시 시도해주세요."
        case .unknownUser:
            return "미가입 사용자입니다. 회원가입을 진행해주세요."
        case .serverError:
            return "서버에러가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .clientError:
            return "입력정보가 적절하지 않습니다. 다시 시도해주세요."
        }
    }
}


