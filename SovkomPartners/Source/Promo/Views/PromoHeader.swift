//
//  PromoHeader.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 26.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

final class PromoHeader: UIView {
    
    private lazy var imageTop: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    private lazy var darkImage: UIImageView = {
        let image = UIImageView()
        
        image.backgroundColor = .black
        image.alpha = 0.35
        
        return image
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 28)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        addSubview(imageTop)
        imageTop.layout.all.equal(to: self)
        
        addSubview(darkImage)
        darkImage.layout.all.equal(to: self)
        
        addSubview(title)
        title.layout.left.equal(to: self, offset: Constants.sideOffset)
        title.layout.right.equal(to: self, offset: -Constants.sideOffset)
        title.layout.bottom.equal(to: self, offset: -2 * Constants.sideOffset)
    }
    
    func setup(promo: Promo?) {
        imageTop.load(url: promo?.imageURL, contentMode: .scaleAspectFill)
        title.text = promo?.title.uppercased()
    }
}
