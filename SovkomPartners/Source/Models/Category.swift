//
//  Category.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 03.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

struct Category: Codable {
    
    let id: String
    let title: String
    let iconName: String?
    let isMall: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case iconName = "icon_name"
        case isMall = "is_mall"
    }
}
