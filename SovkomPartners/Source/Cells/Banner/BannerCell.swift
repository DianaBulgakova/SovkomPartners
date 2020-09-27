//
//  BannerCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 06.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

class BannerCell: UICollectionViewCell {
    
    static let cellReuseIdentifier = "BannerCell"
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shortNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 5)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.13
        layer.masksToBounds = false
        
        iconView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        iconView.layer.cornerRadius = 10
    }
    
    func setup(banner: Banner?) {
        iconView.load(url: banner?.imageURL, contentMode: .scaleAspectFill)
        nameLabel.text = banner?.title
        shortNameLabel.text = banner?.titleShort
    }
}
