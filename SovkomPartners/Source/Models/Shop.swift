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
    let descriptionFull: String
    let fasComments: [String]
    let promosObjects: [PromosObject]
    let installmentTermsTp: [InstallmentTerm]
//    let phones: [JSONAny]
    //let site: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case brandName = "brand_name"
        case tpInstallmentPeriod = "tp_installment_period"
        case iconURL = "icon_url"
        case partIn = "part_in"
        case hashtags
        case descriptionFull = "description_full"
        case fasComments = "fas_comments"
        case promosObjects = "promos_objects"
        case installmentTermsTp = "installment_terms_tp"
//        case phones
        //case site
    }
}

struct PromosObject: Codable {
    
    let id: String
    let title: String
    let imgURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imgURL = "img_url"
    }
}

struct InstallmentTerm: Codable {
    
    let month: String
    let installmentTermDescription: String

    enum CodingKeys: String, CodingKey {
        case month
        case installmentTermDescription = "description"
    }
}
