//
//  Network.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/12/22.
//

import Foundation
import Alamofire
//import RxSwift
import FirebaseAuth

final class Network {
    
    static let share = Network()
    
    private init() { }
    
    // login(get)
    func requestLogin<T: Codable>(type: T.Type = T.self, router: APIRouter, completion: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(router).validate(statusCode: 200...500).responseDecodable(of: T.self) { response in
            
            switch response.result {
                
            case .success(let data):
                print("Network에서의 로그인 통신성공 : 200~500 내부임!!!")
                completion(.success(data))
                
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                guard let error = LoginError(rawValue: statusCode) else { return }
                print("로그인 통신실패!!!")
                completion(.failure(error))
                
            }
        }
    }
    
    
    // signup(post)
    func requestSignup(router: APIRouter, completion: @escaping (Result<String, Error>) -> Void) {

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
    
    // withdraw(post)
    func requestWithdraw(router: APIRouter, completion: @escaping (Result<String, Error>) -> Void) {
        
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
    
    func update(router: APIRouter, completion: @escaping (Result<String, Error>) -> Void) {
        
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
    
    
    //    func refreshFCMidToken() {
    //
    //        let currentUser = Auth.auth().currentUser
    //        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
    //
    //            if let error = error {
    //                return
    //            }
    //            UserDefaults.standard.set(idToken, forKey: "idtoken")
    //        }
    //
    
    // my queue state(get)
    func requestMyState<T: Codable>(type: T.Type = T.self, router: APIRouter, completion: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(router).validate(statusCode: 200...500).responseDecodable(of: T.self) { response in
            
            switch response.result {
            case .success(let data):
                print("Network > my queue state > 통신성공 : 200~500 내부임!!!✅")
                completion(.success(data))
                
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                guard let error = LoginError(rawValue: statusCode) else { return }
                print("Network > my queue state > 로그인 통신실패!!!🔥")
                completion(.failure(error))
                
            }
        }
    }
    
}
