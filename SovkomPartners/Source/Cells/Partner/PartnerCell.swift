//
//  PartnerCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 08.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

final class PartnerCell: UICollectionViewCell {
    
    static let cellReuseIdentifier = "PartnerCell"
    
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
        
        hashtagLabel.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconView.image = nil
    }
    
    func setup(shop: Shop) {
        iconView.load(url: shop.iconURL, contentMode: .scaleAspectFit)
        nameLabel.text = shop.brandName
        
        shortNameLabel.text = "до \(shop.tpInstallmentPeriod) мес."
        
        partinImage.isHidden = !shop.partIn
        
        if let hashtag = shop.hashtags.first {
            hashtagLabel.text = hashtag
            hashtagLabel.isHidden = false
        } else {
            hashtagLabel.isHidden = true
        }
    }
}
