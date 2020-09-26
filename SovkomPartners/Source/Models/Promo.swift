//
//  Promo.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 05.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

struct PromoRequest: Codable {
    
    let promos: [Promo]
}

struct PromoInfoRequest: Codable {
    
    let promo: Promo
    let shops: PromoShops
}

struct PromoShops: Codable {
    
    let items: [Shop]
}

struct Promo: Codable {
    
    let id: String
    let title: String
    let imageURL: String?
    let promoDescription: String
    let descriptionName: String
    let goods: [Good]
    let goodsName: String
    let actionStoresName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "img_url"
        case promoDescription = "description"
        case descriptionName
        case goods
        case goodsName
        case actionStoresName
    }
}

struct Good: Codable {
    
    let title: String
    let url: String
    let img: String
    let price: String
}
