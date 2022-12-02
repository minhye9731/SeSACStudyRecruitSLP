//
//  MyQueueStateError.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/2/22.
//

import Foundation

enum MyQueueStateError: Int, Error {
    case success = 200
    case normalStatus = 201
    case fbTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension MyQueueStateError: LocalizedError {
    
    var errorDescription: String {
        switch self {
        case .success:
            return "나의 상태확인 성공"
        case .normalStatus:
            return "현재는 스터디 찾기를 요청하지 않은 '일반 상태'입니다. "
        case .fbTokenError:
            return "토큰이 만료되었습니다. 전화번호 인증을 다시 해주세요."
        case .unknownUser:
            return "미가입된 사용자입니다. 회원가입을 진행해주세요."
        case .serverError:
            return "서버에러가 발생했습니다. 로그인을 다시 시도해주세요."
        case .clientError:
            return "입력정보가 적절하지 않습니다. 다시 시도해주세요."
        }
    }
}
