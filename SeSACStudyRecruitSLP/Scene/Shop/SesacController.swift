//
//  SesacController.swift
//  SeSACStudyRecruitSLP
//
//  Created by 강민혜 on 12/7/22.
//

import UIKit

class SesacController: NSObject {
    
    struct SesacItem: Hashable {
        let image: String
        let name: String
        let description: String
        let price: String
        let identifier = UUID()
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        init(image: String, name: String, description: String, price: String) {
            self.image = image
            self.name = name
            self.description = description
            self.price = price
        }
    }
    
    lazy var faces: [SesacItem] = {
        return facesInternal()
    }()
    lazy var backgrounds: [SesacItem] = {
        return backgroundsInternal()
    }()
}

extension SesacController {
    func facesInternal() -> [SesacItem] {
        return [SesacItem(image: Constants.ImageName.face1.rawValue, name: "기본 새싹", description: "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다.", price: "보유"),
                SesacItem(image: Constants.ImageName.face2.rawValue, name: "튼튼 새싹", description: "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다.", price: "1,200"),
                SesacItem(image: Constants.ImageName.face3.rawValue, name: "민트 새싹", description: "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다.", price: "2,500"),
                SesacItem(image: Constants.ImageName.face4.rawValue, name: "퍼플 새싹", description: "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다.", price: "2,500"),
                SesacItem(image: Constants.ImageName.face5.rawValue, name: "골드 새싹", description: "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스하는 자유분방한 새싹입니다.", price: "2,500")
        ]
    }
    
    func backgroundsInternal() -> [SesacItem] {
        return [
            SesacItem(image: Constants.ImageName.bg1.rawValue, name: "하늘 공원", description: "새싹들을 많이 마주치는 매력적인 하늘 공원입니다", price: "보유"),
            SesacItem(image: Constants.ImageName.bg2.rawValue, name: "씨티 뷰", description: "창밖으로 보이는 도시 야경이 아름다운 공간입니다", price: "1,200"),
            SesacItem(image: Constants.ImageName.bg3.rawValue, name: "밤의 산책로", description: "어둡지만 무섭지 않은 조용한 산책로입니다", price: "1,200"),
            SesacItem(image: Constants.ImageName.bg4.rawValue, name: "낮의 산책로", description: "즐겁고 가볍게 걸을 수 있는 산책로입니다", price: "1,200"),
            SesacItem(image: Constants.ImageName.bg5.rawValue, name: "연극 무대", description: "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다", price: "2,500"),
            SesacItem(image: Constants.ImageName.bg6.rawValue, name: "라틴 거실", description: "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다", price: "2,500"),
            SesacItem(image: Constants.ImageName.bg7.rawValue, name: "홈트방", description: "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다", price: "2,500"),
            SesacItem(image: Constants.ImageName.bg8.rawValue, name: "뮤지션 작업실", description: "여러가지 음악 작업을 할 수 있는 작업실입니다", price: "2,500")
        ]
    }
}






