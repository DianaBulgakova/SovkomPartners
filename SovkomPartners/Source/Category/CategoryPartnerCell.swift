//
//  CategoryPartnerCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 08.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class CategoryPartnerCell: UICollectionViewCell {
    
    static let cellReuseIdentifier = "CategoryPartnerCell"
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var partinImage: UIImageView!
    @IBOutlet weak var hashtagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 5)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.13
        layer.masksToBounds = false
        
        iconView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        iconView.layer.cornerRadius = 10
        
        hashtagLabel.layer.cornerRadius = 8
        hashtagLabel.isHidden = true
    }
    
    func setup(shop: Shop?) {
        iconView.load(url: shop?.iconURL, contentMode: .scaleAspectFit)
        nameLabel.text = shop?.brandName
        
        if let period = shop?.tpInstallmentPeriod {
            shortNameLabel.text = "до \(period) мес."
        } else {
            shortNameLabel.text = nil
        }
        
        if let partIn = shop?.partIn,
            partIn {
            partinImage.image = #imageLiteral(resourceName: "general_percent")
        } else {
            partinImage.image = nil
        }
        
        if let hashtag = shop?.hashtags.first {
            hashtagLabel.text = hashtag
            hashtagLabel.isHidden = false
        }
    }
}
