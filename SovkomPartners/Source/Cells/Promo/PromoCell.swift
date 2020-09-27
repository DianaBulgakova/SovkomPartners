//
//  PromoCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 05.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

final class PromoCell: UICollectionViewCell {
    
    static let cellReuseIdentifier = "PromoCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var darkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconView.image = nil
    }
    
    func setup(promo: Promo?) {
        iconView.load(url: promo?.imageURL, contentMode: .scaleAspectFill)
        nameLabel.text = promo?.title
    }
}
