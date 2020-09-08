//
//  Promo.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 05.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

struct Promo: Codable {
    
    let id: String
    let title: String
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "img_url"
    }
}
