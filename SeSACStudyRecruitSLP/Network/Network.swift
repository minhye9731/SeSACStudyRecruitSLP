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
    
    // login(get), my queue state(get)
    func requestLogin<T: Codable>(type: T.Type = T.self, router: APIRouter, completion: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(router).responseDecodable(of: T.self) { response in
            
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
    
    // signup(post), 내정보 update(put), delete(delete), requestStudy(post), acceptStudy(post)
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
    
    // MARK: - test
    func requestForResponseStringTest(router: URLRequestConvertible, completion: @escaping (String?, Int?, Error?) -> Void) {
        
        AF.request(router).responseString { response in
            guard let statusCode = response.response?.statusCode else { return }
            
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    // 탈퇴 withdraw(post)
    func requestWithdraw(router: APIRouter, completion: @escaping (String?, Int?, Error?) -> Void) {
        
        AF.request(router).responseString { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
                
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    // search(post)
    func requestSearch(router: QueueAPIRouter, completion: @escaping (SearchResponse?, Int?, Error?) -> Void) {
        
        AF.request(router).responseDecodable(of: SearchResponse.self) { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
                
            case .failure(let error):
                completion(nil, statusCode, error)
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
    
    func requestRate(uid: String, rep: [String], com: String, completion: @escaping (String?, Int?, Error?) -> Void) {
        
        let url = "http://api.sesac.co.kr:1210" + "/v1/queue/rate/\(uid)"
        
        let header: HTTPHeaders = [
            "idtoken": UserDefaultsManager.idtoken,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameter: [String : Any] = [
            "otheruid": uid,
            "reputation": rep,
            "comment": com
        ]
        
        let enc: ParameterEncoding = URLEncoding(arrayEncoding: .noBrackets)
        
        AF.request(url, method: .post, parameters: parameter, encoding: enc, headers: header).responseString { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
                
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    
    // my queue state
    func requestMyQueueState(router: QueueAPIRouter, completion: @escaping (MyQueueStateResponse?, Int?, Error?) -> Void) {
        
        AF.request(router).responseDecodable(of: MyQueueStateResponse.self) { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
                
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    // 채팅 보내기 (post)
    func requestPostChat(router: ChatAPIRouter, completion: @escaping (SendChatResponse?, Int?, Error?) -> Void) {
        
        AF.request(router).responseDecodable(of: SendChatResponse.self) { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
                
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    // 채팅 목록 가져오기 (get)
    func requestLastChat(router: ChatAPIRouter, completion: @escaping (LastChatResponse?, Int?, Error?) -> Void) {
        
        AF.request(router).responseDecodable(of: LastChatResponse.self) { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
                
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
    
    func requestCancelStudy(router: StudyAPIRouter, completion: @escaping (String?, Int?, Error?) -> Void) {
        
        AF.request(router).responseString { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch response.result {
            case .success(let data):
                completion(data, statusCode, nil)
                
            case .failure(let error):
                completion(nil, statusCode, error)
            }
        }
    }
}
