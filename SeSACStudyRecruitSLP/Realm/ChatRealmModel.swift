//
//  ChatRealmModel.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/5/22.
//

import Foundation
import RealmSwift

class ChatRealmModel: Object {
    
    @Persisted var text: String
    @Persisted var userID: String
    @Persisted var name: String?
    @Persisted var username: String?
    @Persisted var id: String?
    @Persisted var createdAt: String
    @Persisted var updatedAt: String?
    @Persisted var v: Int?
    @Persisted var ID: String?
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(text: String, userID: String, name: String?, username: String?, id: String?, createdAt: String, updatedAt: String?, v: Int?, ID: String?) {
        self.init()
        self.text = text
        self.userID = userID
        self.name = name
        self.username = username
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.v = v
        self.ID = ID
    }
    
    
    
    
}
