//
//  SignupError.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/13/22.
//

import Foundation

enum SignupError: Int, Error {
    case existUser = 201
    case invalidNickname = 202
    case fbTokenError = 401
    case serverError = 500
    case clientError = 501
}

extension SignupError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .existUser:
            return "이미 가입한 사용자 정보입니다."
        case .invalidNickname:
            return "사용할 수 없는 닉네임입니다. 닉네임 변경 후 다시 회원가입 요청해주세요."
        case .fbTokenError:
            return "토큰에러가 발생했습니다. 다시 해 시도해주세요."
        case .serverError:
            return "서버에러가 발생했습니다. 로그인을 다시 시도해주세요."
        case .clientError:
            return "입력정보가 적절하지 않습니다. 다시 시도해주세요."
        }
    }
    
}
