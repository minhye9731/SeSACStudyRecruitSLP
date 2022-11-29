//
//  ChatAPIRouter.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/28/22.
//

import Foundation
import Alamofire

enum ChatAPIRouter: URLRequestConvertible {

case send(chat: String)
case takeList(lastchatDate: String)

    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:2022")!
    }

    var method: HTTPMethod {
        switch self {
        case .send:
            return .post
        case .takeList:
            return .get
        }
    }

    var path: String {
        switch self {
        case .send:
            return "/v1/chat/\(UserDefaultsManager.chatTO)"
        case .takeList:
            return "/v1/chat/\(UserDefaultsManager.chatFROM)"
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .send, .takeList:
            return [ "idtoken": UserDefaultsManager.idtoken,
                     "Content-Type": "application/json" ]
        }
    }

    var parameters: [String: String?] {
        switch self {
        case .send(let chat):
            return [
                "chat": chat
            ]
        case .takeList(let lastchatDate):
            return [
                "lastchatDate": lastchatDate
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
