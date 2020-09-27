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
        addSubview(darkImage)
        addSubview(title)
        
        imageTop.translatesAutoresizingMaskIntoConstraints = false
        darkImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageTop.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageTop.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageTop.topAnchor.constraint(equalTo: topAnchor),
            imageTop.bottomAnchor.constraint(equalTo: bottomAnchor),
            darkImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            darkImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            darkImage.topAnchor.constraint(equalTo: topAnchor),
            darkImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.sideOffset),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.sideOffset),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2 * Constants.sideOffset),
        ])
    }
    
    func setup(promo: Promo?) {
        imageTop.load(url: promo?.imageURL, contentMode: .scaleAspectFill)
        title.text = promo?.title.uppercased()
    }
}
