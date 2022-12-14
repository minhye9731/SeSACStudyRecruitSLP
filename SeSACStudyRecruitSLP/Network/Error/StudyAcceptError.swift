//
//  StudyAcceptError.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/2/22.
//

import Foundation

enum StudyAcceptError: Int, Error {
    case success = 200
    case otherSesacAlreadyMatched = 201
    case otherSesacStopped = 202
    case alreadyAccepted = 203
    case fbTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension StudyAcceptError: LocalizedError {
    
    var studyAccepterrorDescription: String {
        switch self {
        case .success:
            return "스터디 수락 성공"
        case .otherSesacAlreadyMatched:
            return "상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다"
        case .otherSesacStopped:
            return "상대방이 스터디 찾기를 그만두었습니다"
        case .alreadyAccepted:
            return "앗! 누군가가 나의 스터디를 수락하였어요!"
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
