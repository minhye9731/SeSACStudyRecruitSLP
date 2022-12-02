//
//  StudyAPIRouter.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/2/22.
//

import Foundation
import Alamofire

enum StudyAPIRouter: URLRequestConvertible {
    
    case requestStudy(otheruid: String)
    case acceptStudy(otheruid: String)
    case cancelStudy(otheruid: String)
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1210")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestStudy, .acceptStudy, .cancelStudy:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .requestStudy:
            return "/v1/queue/studyrequest"
        case .acceptStudy:
            return "/v1/queue/studyaccept"
        case .cancelStudy:
            return "/v1/queue/dodge"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .requestStudy, .acceptStudy, .cancelStudy:
            return [ "idtoken": UserDefaultsManager.idtoken,
                     "Content-Type": "application/x-www-form-urlencoded" ]
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .requestStudy(let otheruid):
            return [
                "otheruid": otheruid
            ]
        case .acceptStudy(let otheruid):
            return [
                "otheruid": otheruid
            ]
        case .cancelStudy(let otheruid):
            return [
                "otheruid": otheruid
            ]
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
