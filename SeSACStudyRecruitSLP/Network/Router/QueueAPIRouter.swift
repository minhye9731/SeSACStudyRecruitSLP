//
//  QueueAPIRouter.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/2/22.
//

import Foundation
import Alamofire

enum QueueAPIRouter: URLRequestConvertible {
    
    case myQueueState
    case search(lat: String, long: String)
    case queue(long: String, lat: String, studylist: String)
    case delete
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1210")!
    }

    var method: HTTPMethod {
        switch self {
        case .myQueueState:
            return .get
        case .search, .queue:
            return .post
        case .delete:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .myQueueState:
            return "/v1/queue/myQueueState"
        case .search:
            return "/v1/queue/search"
        case .queue, .delete:
            return "/v1/queue"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .myQueueState, .search, .queue, .delete :
            return [ "idtoken": UserDefaultsManager.idtoken,
                     "Content-Type": "application/x-www-form-urlencoded" ]
        }
    }
    
    var parameters: [String: String?] {
        switch self {
        case .search(let lat, let long):
            return [
                "lat": lat,
                "long": long
            ]
        case .queue(let long, let lat, let studylist):
            return [
                "long": long,
                "lat": lat,
                "studylist": studylist
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
