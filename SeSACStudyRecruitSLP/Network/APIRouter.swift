//
//  APIRouter.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/12/22.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {

    case login
    case signup(phoneNumber: String, FCMtoken: String, nick: String, birth: String, email: String, gender: String)
    case withdraw
    case update(searchable: String, ageMin: String, ageMax: String, gender: String, study: String?)
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1210")!
    }

    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case .signup, .withdraw:
            return .post
        case .update:
            return .put
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/v1/user"
        case .signup:
            return "/v1/user"
        case .withdraw:
            return "/v1/user/withdraw"
        case .update:
            return "/v1/user/mypage"
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .login: return [ "idtoken": UserDefaults.standard.string(forKey: "idtoken")!,
                              "Content-Type": "application/json" ]
            
        case .signup: return [ "idtoken": UserDefaults.standard.string(forKey: "idtoken")!,
                               "Content-Type": "application/x-www-form-urlencoded" ]
            
        case .withdraw: return [ "idtoken": UserDefaults.standard.string(forKey: "idtoken")!,
                                 "Content-Type": "application/x-www-form-urlencoded" ] // 타입확인 필요
            
        case .update: return [ "idtoken": UserDefaults.standard.string(forKey: "idtoken")!,
                               "Content-Type": "application/x-www-form-urlencoded" ] // 타입확인 필요
        }
    }

    var parameters: [String: String?] {
        switch self {
        case .signup(let phoneNumber, let fcmtoken, let nick, let birth, let email, let gender):
            return [
                "phoneNumber": phoneNumber,
                "FCMtoken": fcmtoken,
                "nick": nick,
                "birth": birth,
                "email": email,
                "gender": gender
            ]
        case .update(let searchable, let ageMin, let ageMax, let gender, let study):
            return [
                "searchable": searchable,
                "ageMin": ageMin,
                "ageMax": ageMax,
                "gender": gender,
                "study": study
            ]
        default: return ["":""]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        return request
    }
}
