//
//  Partner.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 01.10.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

struct PartnerDetail {
    
    let id: String
    let name: String
    let icon: String
    let partIn: Bool?
    let hashtags: [String]?
    let descriptionFull: String?
    let fasComments: [String]?
    let promosObjects: [PromosObject]?
    let installmentTermsTp: [InstallmentTerm]?
    let shopsCount: Int?
    let phones: [String]
    let siteTitle: String
    
    init(shop: Shop) {
        self.id = shop.id
        self.name = shop.brandName
        self.icon = shop.iconURL
        self.partIn = shop.partIn
        self.hashtags = shop.hashtags
        self.descriptionFull = shop.descriptionFull
        self.fasComments = shop.fasComments
        self.promosObjects = shop.promosObjects
        self.installmentTermsTp = shop.installmentTermsTp
        self.shopsCount = nil
        self.phones = shop.phones
        self.siteTitle = shop.siteTitle
    }
    
    init(mall: Mall) {
        self.id = mall.id
        self.name = mall.title
        self.icon = mall.imgURL
        self.partIn = mall.partIn
        self.hashtags = nil
        self.descriptionFull = mall.mallDescription
        self.fasComments = nil
        self.promosObjects = nil
        self.installmentTermsTp = nil
        self.shopsCount = mall.shopsCount
        self.phones = mall.phones
        self.siteTitle = mall.siteTitle
    }
}
