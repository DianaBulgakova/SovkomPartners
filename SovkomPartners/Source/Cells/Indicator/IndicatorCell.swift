//
//  IndicatorCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 23.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

class IndicatorCell: UICollectionViewCell {
    
    static let cellReuseIdentifier = "IndicatorCell"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}
