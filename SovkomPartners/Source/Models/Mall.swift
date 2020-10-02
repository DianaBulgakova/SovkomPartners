//
//  Mall.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 28.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

struct MallRequest: Codable {
    let malls: [Mall]
}

struct Mall: Codable {
    let id: String
    let title: String
    let imgURL: String
    let shopsCount: Int
    let mallDescription: String
    let partIn: Bool
    let phones: [String]
    let address: String
    let siteTitle: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imgURL = "img_url"
        case shopsCount = "shops_count"
        case mallDescription = "description"
        case partIn = "part_in"
        case phones
        case address
        case siteTitle = "site_title"
    }
}
