//
//  PromosListController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 10.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

final class PromosListController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = MainSection.Kind.promos.headerTitle
    }
}
