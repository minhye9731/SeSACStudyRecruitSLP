//
//  ChatRepository.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/5/22.
//

import Foundation
import RealmSwift

protocol ChatRepositoryType {
    func fetchRealm()
    func filteredByUID(uid: String)
    func plusChat(item: ChatRealmModel)
}

class ChatRepository: ChatRepositoryType {
    // MARK: - property
    private init() { }
    static let standard = ChatRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<ChatRealmModel>!
    
    let calendar = Calendar.current
    
    // MARK: - functions
    func fetchRealm() {
        tasks = ChatRepository.standard.localRealm.objects(ChatRealmModel.self)
    }
    
    func filteredByUID(uid: String) {
        tasks = ChatRepository.standard.localRealm.objects(ChatRealmModel.self).where {
            $0.userID == uid
        }
    }
    
    func plusChat(item: ChatRealmModel) {
        do {
            try localRealm.write{
                localRealm.add(item)
            }
        } catch let error {
            print(error)
        }
    }
}
