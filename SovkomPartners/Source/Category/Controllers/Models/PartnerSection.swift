//
//  PartnerSection.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 29.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

struct PartnerSection {
    
    private(set) var kind: Kind
    private(set) var title: String?
    private(set) var itemsCount: Int
    
    init(kind: Kind, title: String?, itemsCount: Int) {
        self.kind = kind
        self.title = title
        self.itemsCount = itemsCount
    }
}

extension PartnerSection {
    
    enum Kind: Int {
        
        case installment
        case button
        case address
        case contacts
        case waysToBuy
        case information
        case promosOrShops
        
        var headerButtonTitle: String? {
            switch self {
            case .installment: return "?"
            case .address: return nil
            case .button: return nil
            case .contacts: return nil
            case .waysToBuy: return nil
            case .information: return nil
            case .promosOrShops: return nil
            }
        }
    }
}
