//
//  Network.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/12/22.
//

import Foundation
import Alamofire
import FirebaseAuth

final class Network {
    
    static let share = Network()
    
    private init() { }
    
    // login(get), search(post), my queue state(get)
    func requestLogin<T: Codable>(type: T.Type = T.self, router: APIRouter, completion: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(router).validate(statusCode: 200...500).responseDecodable(of: T.self) { response in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data))
                
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                guard let error = LoginError(rawValue: statusCode) else { return }
                completion(.failure(error))
                
            }
        }
    }
    
    // signup(post), withdraw(post), 내정보 update(put), delete(delete), requestStudy(post), acceptStudy(post)
    func requestForResponseString(router: APIRouter, completion: @escaping (Result<String, Error>) -> Void) {
        
        AF.request(router).validate(statusCode: 200...500).responseString { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                guard let error = SignupError(rawValue: statusCode) else { return }
                completion(.failure(error))
            }
        }
    }


    func requestQueue(long: String, lat: String, studyList: [String], completion: @escaping (Result<String, Error>) -> Void) {
        
        let url = "http://api.sesac.co.kr:1210" + "/v1/queue"
        
        let header: HTTPHeaders = [
            "idtoken": UserDefaultsManager.idtoken,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameter: [String : Any] = [
            "long": long,
            "lat": lat,
            "studylist": studyList
        ]
        
        let enc: ParameterEncoding = URLEncoding(arrayEncoding: .noBrackets)
//        let encoder: ParameterEncoding = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets)) as! ParameterEncoding
        
        AF.request(url, method: .post, parameters: parameter, encoding: enc, headers: header).validate(statusCode: 200...500).responseString { response in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data))
                
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                guard let error = LoginError(rawValue: statusCode) else { return }
                completion(.failure(error))
                
            }
        }
    }
    
    
    // fcm messaging token 갱신
    func requestFCMTokenUpdate(router: APIRouter, completion: @escaping (Result<String, Error>) -> Void) {
        
        AF.request(router).validate(statusCode: 200...500).responseString { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                guard let error = SignupError(rawValue: statusCode) else { return }
                completion(.failure(error))
            }
        }
    }
    
}
