//
//  ShopItemError.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/14/22.
//

import Foundation

enum ShopItemError: Int, Error {
    case success = 200
    case noPossessionRequest = 201
    case fbTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension ShopItemError: LocalizedError {
    
    var shopItemErrorDescription: String {
        switch self {
        case .success:
            return "성공적으로 저장되었습니다"
        case .noPossessionRequest:
            return "구매가 필요한 아이템이 있어요"
        case .fbTokenError:
            return "토큰이 만료되었습니다."
        case .unknownUser:
            return "미가입된 사용자입니다. 회원가입을 진행해주세요."
        case .serverError:
            return "서버에러가 발생했습니다. 저장하기를 다시 시도해주세요."
        case .clientError:
            return "입력정보가 적절하지 않습니다. 다시 시도해주세요."
        }
    }
}
