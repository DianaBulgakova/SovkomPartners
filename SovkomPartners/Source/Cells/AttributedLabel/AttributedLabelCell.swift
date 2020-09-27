//
//  AttributedLabelCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 24.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

class AttributedLabelCell: UITableViewCell {
    
    static let shared = AttributedLabelCell()
    
    static let cellReuseIdentifier = "AttributedLabelCell"
    
    private lazy var attributedLabel: AttributedLabel = {
        let label = AttributedLabel()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
        
        contentView.addSubview(attributedLabel)
        attributedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.sideOffset).isActive = true
        attributedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.sideOffset).isActive = true
        attributedLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        attributedLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setup(promo: Promo?) {
        attributedLabel.setTitle(promo?.promoDescription)
    }
    
    var contentHeight: CGFloat {
        setNeedsLayout()
        layoutIfNeeded()
        
        return attributedLabel.contentHeight + 10
    }
}
