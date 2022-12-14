//
//  StudyRequestError.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/2/22.
//

import Foundation

enum StudyRequestError: Int, Error {
    case success = 200
    case alreadyRequest = 201
    case otherSesacStopped = 202
    case fbTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension StudyRequestError: LocalizedError {
    
    var studyRequestErrorDescription: String? {
        switch self {
        case .success:
            return "스터디 요청을 보냈습니다"
        case .alreadyRequest:
            return "상대방도 스터디를 요청하여 매칭되었습니다. 잠시 후 채팅방으로 이동합니다"
        case .otherSesacStopped:
            return "상대방이 스터디 찾기를 그만두었습니다"
        case .fbTokenError:
            return "토큰이 만료되었습니다."
        case .unknownUser:
            return "미가입된 사용자입니다. 회원가입을 진행해주세요."
        case .serverError:
            return "서버에러가 발생했습니다. 다시 시도해주세요."
        case .clientError:
            return "입력정보가 적절하지 않습니다. 다시 시도해주세요."
        }
    }
}
