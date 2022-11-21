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
    case state
    case fcmUpdate(fcmToken: String)
    case search(lat: String, long: String)
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1210")!
    }

    var method: HTTPMethod {
        switch self {
        case .login, .state:
            return .get
        case .signup, .withdraw, .search:
            return .post
        case .update, .fcmUpdate:
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
        case .state:
            return "/v1/queue/myQueueState"
        case .fcmUpdate:
            return "/v1/user/update_fcm_token"
        case .search:
            return "/v1/queue/search"
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .login, .state, .search:
            return [ "idtoken": UserDefaultsManager.idtoken,
                              "Content-Type": "application/json" ]
            
        case .signup, .withdraw, .update, .fcmUpdate:
            return [ "idtoken": UserDefaultsManager.idtoken,
                               "Content-Type": "application/x-www-form-urlencoded" ]
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
        case .fcmUpdate(let fcmToken):
            return [
                "FCMtoken": fcmToken
            ]
        case .search(let lat, let long):
            return [
                "lat" : lat,
                "long" : long
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
