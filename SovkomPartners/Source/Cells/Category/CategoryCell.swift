//
//  PartnersCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 03.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

final class CategoryCell: TableViewCell {
    
    static let cellReuseIdentifier = "CategoryCell"
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showBottomSeparator = true
        separatorAlignmentView = nameLabel
        
        accessoryType = .disclosureIndicator
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconView.image = nil
    }
    
    func setup(category: Category?) {
        if let iconName = category?.iconName {
            iconView.image = UIImage(named: iconName)
        }
        
        nameLabel.text = category?.title
    }
}
