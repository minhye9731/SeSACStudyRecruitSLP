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
    case ios(receipt: String, product: String)
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1210")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .myinfo:
            return .get
        case .shopitem, .ios:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .myinfo:
            return "/v1/user/shop/myinfo"
        case .shopitem:
            return "/v1/user/shop/item"
        case .ios:
            return "/v1/user/shop/ios"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .myinfo, .shopitem, .ios:
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
        case .ios(let receipt, let product):
            return [
                "receipt": receipt,
                "product": product
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
