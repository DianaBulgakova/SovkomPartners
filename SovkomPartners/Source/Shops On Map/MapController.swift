//
//  MapController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 10.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class MapController: UIViewController {
    
    private var category: Category?
    
    convenience init(category: Category?) {
        self.init()
        
        self.category = category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category?.title ?? MainSection.Kind.categories.headerTitle
    }
}
