//
//  GoodCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 24.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class GoodCell: UICollectionViewCell {

    static let cellReuseIdentifier = "GoodCell"
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
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
    
    func setup(good: Good?) {
        iconView.load(url: good?.img, contentMode: .scaleAspectFill)
        nameLabel.text = good?.title
        priceLabel.text = good?.price
    }
}
