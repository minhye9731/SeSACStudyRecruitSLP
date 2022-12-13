//
//  ShopIosError.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/14/22.
//

import Foundation

enum ShopIosError: Int, Error {
    case success = 200
    case failReceiptCheck = 201
    case fbTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension ShopIosError: LocalizedError {
    
    var shopIosErrorDescription: String {
        switch self {
        case .success:
            return "아이템 구매가 완료되었습니다"
        case .failReceiptCheck:
            return "아이템 구매에 실패했습니다."
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
