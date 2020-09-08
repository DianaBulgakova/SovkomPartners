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
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case iconName = "icon_name"
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let title = dictionary["title"] as? String else { return nil }
        
        self.id = id
        self.title = title
        self.iconName = dictionary["icon_name"] as? String
    }
}
