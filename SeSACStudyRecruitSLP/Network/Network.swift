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
    
    // session 정의
    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 5 // 재호출 제한 시간간격
        configuration.waitsForConnectivity = true
        return Session(configuration: configuration)
    }()

    // search(post) - timeout interval 적용
    func requestSearch<T: Codable>(type: T.Type = T.self, router: APIRouter, completion: @escaping (Result<T, Error>) -> Void) {
        
        // 적용 안되는데?;;
        sessionManager.request(router).validate(statusCode: 200...500).responseDecodable(of: T.self) { response in
            
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
    
    
    
    // login(get), my queue state(get)
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
    
    func requestSendChat<T: Codable>(type: T.Type = T.self, router: ChatAPIRouter, completion: @escaping (Result<T, Error>) -> Void) {
        
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
    
    
    
    
    // fcm messaging token 갱신
//    func requestFCMTokenUpdate(router: APIRouter, completion: @escaping (Result<String, Error>) -> Void) {
//
//        AF.request(router).validate(statusCode: 200...500).responseString { response in
//            switch response.result {
//            case .success(let data):
//                completion(.success(data))
//            case .failure(_):
//                guard let statusCode = response.response?.statusCode else { return }
//                guard let error = SignupError(rawValue: statusCode) else { return }
//                completion(.failure(error))
//            }
//        }
//    }
    
}
