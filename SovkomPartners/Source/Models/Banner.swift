//
//  Banner.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 06.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

struct BannerRequest: Codable {
    
    let banners: [Banner]
}

struct Banner: Codable {
    
    let id: String
    let title: String
    let titleShort: String
    let imageURL: String?
    let screen: Screen
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleShort = "title_short"
        case imageURL = "img_url_web"
        case screen
    }
}

struct Screen: Codable {
    
    let id: String
}
