//
//  IndicatorCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 23.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

final class IndicatorCell: UICollectionViewCell {
    
    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    func commonInit() {
        contentView.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
}
