//
//  ChatRepository.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/5/22.
//

import Foundation
import RealmSwift

protocol ChatRepositoryType {
    func fetchRealm() -> [Chat]
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
    func fetchRealm() -> [Chat] {

        var lastChatData: [Chat] = ChatRepository.standard.localRealm.objects(ChatRealmModel.self).sorted(byKeyPath: "createdAt", ascending: true).map { data in
            
            let chat = data.text
            let userId = data.userID
            let name = data.name ?? ""
            let username = data.username ?? ""
            let id = data.id ?? ""
            let createdAt = data.createdAt
            let updatedAt = data.updatedAt ?? ""
            let v = data.v ?? 0
            let iD = data.ID ?? ""
            
            return Chat(text: chat, userID: userId, name: name, username: username, id: id, createdAt: createdAt, updatedAt: updatedAt, v: v, ID: iD)
        }
        dump(lastChatData)
        return lastChatData
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
