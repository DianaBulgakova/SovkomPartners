//
//  ShopButtonCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 03.10.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class ShopButtonCell: UITableViewCell {
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .lightGray
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        
        button.setTitle("Перейти в магазин", for: .normal)
        button.titleColor = .black
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }

    func commonInit() {
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(button)
        button.layout.vertical.equal(to: contentView)
        button.layout.horizontal.equal(to: contentView, offset: Constants.sideOffset)
    }
}
