//
//  HeaderReusableView.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 09.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

protocol HeaderReusableViewDelegate: class {
    
    func mapButtonTapped()
}

final class HeaderReusableView: UICollectionReusableView {
    
    weak var delegate: HeaderReusableViewDelegate?
    
    static let reuseIdentifier = "HeaderReusableView"
    
    @IBAction
    func mapButton() {
        delegate?.mapButtonTapped()
    }
}
