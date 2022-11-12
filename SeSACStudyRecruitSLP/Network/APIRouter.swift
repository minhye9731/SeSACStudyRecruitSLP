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
    case signup(phoneNumber: String, FCMtoken: String, nick: String, birth: String, email: String, gender: Int)
//    case signup
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1207")!
//        return URL(string: "http://api.memolease.com/api/v1/users/")!
    }

    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case .signup:
            return .post
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/v1/user"
        case .signup:
            return "/v1/user"
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .signup, .login: return [ "idtoken": UserDefaults.standard.string(forKey: "idtoken")!,
                                      "Content-Type": "application/x-www-form-urlencoded" ]
        }
    }

    var parameters: [String: Any] {
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
        case .login: return ["":""]
        }
    }

//    var parameters: [String: Any]  {
//        switch self {
//        case .signup:
//            return [
//                "phoneNumber": UserDefaults.standard.string(forKey: "phoneNum"),
//                "FCMtoken": UserDefaults.standard.string(forKey: "fcmToken"),
//                "nick": UserDefaults.standard.string(forKey: "nickName"),
//                "birth": UserDefaults.standard.date(forKey: "realAge"),
//                "email": UserDefaults.standard.string(forKey: "email"),
//                "gender": UserDefaults.standard.string(forKey: "gender")
//            ]
//        case .login: return ["":""]
//        }
//    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        return request
    }
}
