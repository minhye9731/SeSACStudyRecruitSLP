//
//  ShopAPIRouter.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/13/22.
//

import Foundation
import Alamofire

enum ShopAPIRouter: URLRequestConvertible {

    case myinfo
    case shopitem(sesac: String, background: String)
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1210")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .myinfo:
            return .get
        case .shopitem:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .myinfo:
            return "/v1/user/shop/myinfo"
        case .shopitem:
            return "/v1/user/shop/item"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .myinfo, .shopitem:
            return [ "idtoken": UserDefaultsManager.idtoken,
                     "Content-Type": "application/x-www-form-urlencoded" ]
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .shopitem(let sesac, let background):
            return [
                "sesac": sesac,
                "background": background
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
