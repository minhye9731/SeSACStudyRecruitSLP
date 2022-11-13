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
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1207")!
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
        case .login: return [ "idtoken": UserDefaults.standard.string(forKey: "idtoken")!,
                              "Content-Type": "application/json" ]
            
        case .signup: return [ "idtoken": UserDefaults.standard.string(forKey: "idtoken")!,
                               "Content-Type": "application/x-www-form-urlencoded" ]
        }
    }

    var parameters: [String: String] {
        switch self {
        case .signup(let phoneNumber, let fcmtoken, let nick, let birth, let email, let gender):
            return [
                "phoneNumber": phoneNumber,
                "FCMtoken": fcmtoken,
                "nick": nick,
                "birth": birth,
                "email": email,
                "gender": gender // 타입 케스팅해서 해보자
            ]
        case .login: return ["":""]
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