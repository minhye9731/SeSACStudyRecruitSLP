//
//  UserInfoUpdateDTO.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/18/22.
//

import Foundation

struct UserInfoUpdateDTO: Codable {
    
    var bgNum: Int
    var fcNum: Int
    var name: String
    var reputation: [Int]
    var comment: [String]
    
    
    var searchable: Int
    var ageMin: Int
    var ageMax: Int
    var gender: Int
    var study: String?
}
