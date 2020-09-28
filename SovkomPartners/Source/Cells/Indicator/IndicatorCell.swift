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
        activityIndicator.layout.centerY.equal(to: contentView)
        activityIndicator.layout.centerX.equal(to: contentView)
        activityIndicator.layout.height.equal(to: 30)
        activityIndicator.layout.width.equal(to: 30)
    }
}
