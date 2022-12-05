//
//  ChatAPIRouter.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/28/22.
//

import Foundation
import Alamofire

enum ChatAPIRouter: URLRequestConvertible {

    case send(chat: String, uid: String)
    case takeList(lastchatDate: String, uid: String)

    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1210")!
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
        case .send(_, let uid):
            return "/v1/chat/\(uid)"
        case .takeList(_, let uid):
            return "/v1/chat/\(uid)"
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .send, .takeList:
            return [ "idtoken": UserDefaultsManager.idtoken,
                               "Content-Type": "application/x-www-form-urlencoded" ]
        }
    }

    var parameters: [String: String] {
        switch self {
        case .send(let chat, _):
            return [ "chat": chat ]
        case .takeList(let lastchatDate, _):
            return [ "lastchatDate": lastchatDate ]
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
