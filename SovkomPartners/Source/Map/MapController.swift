//
//  MapController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 10.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

final class MapController: UIViewController {
    
    private var category: Category?
    private var partner: PartnerDetail?
    
    convenience init(category: Category?) {
        self.init()
        
        self.category = category
    }
    
    convenience init(partner: PartnerDetail?) {
        self.init()
        
        self.partner = partner
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = partner?.name ?? category?.title ?? MainSection.Kind.categories.headerTitle 
    }
}
