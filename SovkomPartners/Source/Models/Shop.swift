//
//  Shop.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 08.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

struct ShopRequest: Codable {
    
    let shops: [Shop]
}

struct Shop: Codable {
    
    let id: String
    let brandName: String
    let tpInstallmentPeriod: String
    let iconURL: String
    let partIn: Bool
    let hashtags: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case brandName = "brand_name"
        case tpInstallmentPeriod = "tp_installment_period"
        case iconURL = "icon_url"
        case partIn = "part_in"
        case hashtags
    }
}
