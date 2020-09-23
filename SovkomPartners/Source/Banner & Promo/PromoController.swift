//
//  PromoController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 09.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

class PromoController: UIViewController {
    
    private var promos = [Promo]()
    private var promo: Promo?
    
    private var banners = [Banner]()
    private var banner: Banner?
    
//    private lazy var imageTop: UIImageView = {
//        let image = UIImageView()
//
//        image.load(url: promo?.imageURL, contentMode: .scaleAspectFill)
//        return image
//    }()
    
//    private lazy var titleImageTop: UILabel = {
//        let label = UILabel()
//
//        label.text = promo?.title
//
//        return label
//    }()
    
//    private lazy var attributedLabel: AttributedLabel = {
//        let label = AttributedLabel()
//
//        label.setTitle(self.promo?.promoDescription)
//
//        return label
//    }()
    
    convenience init(promo: Promo) {
        self.init()
        
        self.promo = promo
    }
    
    convenience init(banner: Banner) {
        self.init()
        
        self.banner = banner
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupViews()
        updateInfo()
        view.backgroundColor = .white
    }
    
    private func updateInfo() {
        NetworkManager.shared.promos { [weak self] promos in
            self?.promos = promos ?? []
        }
        
        NetworkManager.shared.banners { [weak self] banners in
            self?.banners = banners ?? []
        }
    }
    
//    private func setupViews() {
//        view.addSubview(imageTop)
//        imageTop.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        imageTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        imageTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        imageTop.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        imageTop.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(attributedLabel)
//        attributedLabel.topAnchor.constraint(equalTo: imageTop.topAnchor, constant: Constants.sideOffset).isActive = true
//        attributedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideOffset).isActive = true
//        attributedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.sideOffset).isActive = true
//        attributedLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        attributedLabel.translatesAutoresizingMaskIntoConstraints = false
//    }
}
