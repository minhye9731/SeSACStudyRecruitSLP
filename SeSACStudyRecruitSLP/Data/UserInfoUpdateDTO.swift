//
//  UserInfoUpdateDTO.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/18/22.
//

import Foundation

struct UserInfoUpdateDTO: Codable {
    var searchable: Int
    var ageMin: Int
    var ageMax: Int
    var gender: Int
    var study: String?
}
