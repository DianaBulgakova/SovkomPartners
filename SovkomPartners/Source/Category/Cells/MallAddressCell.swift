//
//  MallAddressCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 04.10.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class MallAddressCell: UITableViewCell {
    
    private(set) lazy var addressLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = .lightGray
        
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .blue
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("Маршрут - 800 км", for: .normal)
        button.titleColor = .white
        
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
        
        contentView.addSubview(addressLabel)
        addressLabel.layout.all.except(.bottom).equal(to: contentView, offset: UIEdgeInsets(horizontal: Constants.sideOffset, vertical: 0))
        
        contentView.addSubview(button)
        button.layout.bottom.equal(to: contentView)
        button.layout.horizontal.equal(to: contentView, offset: (first: Constants.sideOffset, second: Constants.sideOffset + 200))
        button.layout.height.equal(to: 30)
        
        addressLabel.layout.bottom.equal(to: button.layout.top, offset: 20)
    }
}
