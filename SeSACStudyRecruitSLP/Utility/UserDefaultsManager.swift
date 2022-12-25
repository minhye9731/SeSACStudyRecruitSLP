//
//  UserDefaultsManager.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 11/18/22.
//

import Foundation

struct UserDefaultsManager {

    // MARK: - 기타
    // 첫 실행여부
    @UserDefaultsWrapper(key: "firstRun", defaultValue: true)
    static var firstRun: Bool
    
    // MARK: - 번호인증
    @UserDefaultsWrapper(key: "fcmTokenSU", defaultValue: "")
    static var fcmTokenSU: String
    
    @UserDefaultsWrapper(key: "authVerificationID", defaultValue: "")
    static var authVerificationID: String
    
    @UserDefaultsWrapper(key: "phoneNumSU", defaultValue: "")
    static var phoneNumSU: String
    
    @UserDefaultsWrapper(key: "idtoken", defaultValue: "")
    static var idtoken: String
    
    
    // MARK: - 회원가입
    @UserDefaultsWrapper(key: "nickNameSU", defaultValue: "")
    static var nickNameSU: String
    
    @UserDefaultsWrapper(key: "realAgeSU", defaultValue: "")
    static var realAgeSU: String
    
    @UserDefaultsWrapper(key: "emailSU", defaultValue: "")
    static var emailSU: String
    
    @UserDefaultsWrapper(key: "genderSU", defaultValue: "")
    static var genderSU: String
    
    
    // MARK: - home
    @UserDefaultsWrapper(key: "selectedGender", defaultValue: "") // 검색필터 성별값
    static var selectedGender: String
    
    // MARK: - sesac 입력
    @UserDefaultsWrapper(key: "searchLAT", defaultValue: "") // 검색하고 싶은 위치 lat
    static var searchLAT: String
    
    @UserDefaultsWrapper(key: "searchLONG", defaultValue: "") // 검색하고 싶은 위치 lat
    static var searchLONG: String
    
    @UserDefaultsWrapper(key: "mywishTagList", defaultValue: []) // 내가 하고싶은 스터디
    static var mywishTagList: Array
    
}
