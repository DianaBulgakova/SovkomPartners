//
//  HeaderView.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 06.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    
    func buttonTapped(_ header: HeaderView)
}

final class HeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: HeaderViewDelegate?
    
    static let reuseIdentifier = "HeaderView"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBAction
    private func buttonPressed() {
        delegate?.buttonTapped(self)
    }
}
