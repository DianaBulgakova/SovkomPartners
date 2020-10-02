//
//  PartnerHeader.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 29.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

class PartnerHeader: UIView {
    
    private lazy var contentView: UIImageView = {
        let image = UIImageView()
        
        backgroundColor = .white
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.lightGray.cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 5)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.13
        layer.masksToBounds = false
        image.clipsToBounds = true
        
        return image
    }()
    
    private lazy var imageTop: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        
        return label
    }()
    
    private lazy var partinImage: UIImageView = {
        let image = UIImageView()
        
        image.image = UIImage(named: "general_percent")
        
        return image
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
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
        addSubview(contentView)
        contentView.layout.all.equal(to: self, offset: UIEdgeInsets(horizontal: Constants.sideOffset, vertical: 16))
        
        contentView.addSubview(imageTop)
        imageTop.layout.center.equal(to: contentView)
        imageTop.layout.size.equal(to: CGSize(width: 150, height: 60))
        
        contentView.addSubview(title)
        title.layout.all.except(.top).equal(to: contentView, offset: UIEdgeInsets(horizontal: Constants.sideOffset, vertical: 16))
        
        contentView.addSubview(partinImage)
        partinImage.layout.all.except(.bottom).except(.right).equal(to: contentView, offset: UIEdgeInsets(horizontal: Constants.sideOffset, vertical: 16))
        partinImage.layout.size.equal(to: CGSize(side: 20))
        
        contentView.addSubview(labelStackView)
        labelStackView.layout.all.except(.bottom).except(.left).equal(to: contentView, offset: UIEdgeInsets(horizontal: Constants.sideOffset, vertical: 16))
        labelStackView.layout.height.equal(to: 21)
    }
    
    func setup(partner: PartnerDetail) {
        imageTop.load(url: partner.icon, contentMode: .scaleAspectFit)
        title.text = partner.shopsCount?.pluralize(one: "магазин", two: "магазина", many: "магазинов")
        partinImage.isHidden = !(partner.partIn ?? false)
        
        guard let hashtags = partner.hashtags else { return }
        
        for hashtag in hashtags {
            let label = UILabel()
            
            label.backgroundColor = .systemYellow
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            
            label.textColor = .black
            label.font = .boldSystemFont(ofSize: 12)
            label.textAlignment = .center
            
            label.text = hashtag
            label.layout.width.equal(to: 95)
            labelStackView.addArrangedSubview(label)
        }
    }
}
