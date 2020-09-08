//
//  HeaderView.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 06.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "HeaderView"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBAction
    func buttonPressed() {
    }
}
