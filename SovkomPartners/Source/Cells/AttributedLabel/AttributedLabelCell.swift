//
//  AttributedLabelCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 24.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

final class AttributedLabelCell: UITableViewCell {
    
    static let shared = AttributedLabelCell()
    
    private(set) lazy var label: AttributedLabel = {
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
        
        contentView.addSubview(label)
        label.layout.left.equal(to: contentView, offset: Constants.sideOffset)
        label.layout.right.equal(to: contentView, offset: -Constants.sideOffset)
        label.layout.centerX.equal(to: contentView)
    }
    
    var contentHeight: CGFloat {
        setNeedsLayout()
        layoutIfNeeded()
        
        return label.contentHeight + 10
    }
}
