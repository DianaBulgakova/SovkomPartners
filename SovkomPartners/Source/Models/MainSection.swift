//
//  MainSection.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 06.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation

struct MainSection {
    
    private(set) var kind: Kind
    private(set) var itemsCount: Int
    
    init(kind: Kind, itemsCount: Int = 1) {
        self.kind = kind
        self.itemsCount = itemsCount
    }
}

extension MainSection {
    
    enum Kind: Int {
        
        case banners
        case promos
        case categories
        
        var headerTitle: String? {
            switch self {
            case .banners: return nil
            case .promos: return "Акции и скидки"
            case .categories: return "Магазины"
            }
        }
        
        var headerButtonTitle: String? {
            switch self {
            case .banners: return nil
            case .promos: return "Все"
            case .categories: return "На карте"
            }
        }
    }
}
