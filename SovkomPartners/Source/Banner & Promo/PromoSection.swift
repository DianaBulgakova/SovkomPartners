//
//  PromoSection.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 23.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

struct PromoSection {
    
    private(set) var kind: Kind
    private(set) var title: String?
    private(set) var itemsCount: Int
    
    init(kind: Kind, title: String?, itemsCount: Int = 1) {
        self.kind = kind
        self.title = title
        self.itemsCount = itemsCount
    }
}

extension PromoSection {
    
    enum Kind: Int {
        
        case attributedLabel
        case goods
        case shops
        
        var headerButtonTitle: String? {
            switch self {
            case .attributedLabel: return nil
            case .goods: return "См. все"
            case .shops: return "См. все"
            }
        }
    }
}
