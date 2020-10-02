//
//  ContactsCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 29.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

class ContactsCell: UITableViewCell {
    
    private(set) lazy var contactView: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    private(set) lazy var contactLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contactView.image = nil
        contactLabel.text = nil
    }
    
    private func commonInit() {
        selectionStyle = .none
//        showBottomSeparator = true
//        separatorAlignmentView = contactView
        
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(contactView)
        contactView.layout.all.except(.right).equal(to: contentView, offset: UIEdgeInsets(horizontal: Constants.sideOffset, vertical: 10))
        contactView.layout.size.equal(to: CGSize(width: 40, height: 30))
        
        contentView.addSubview(contactLabel)
        contactLabel.layout.all.except(.right).equal(to: contentView, offset: UIEdgeInsets(horizontal: Constants.sideOffset + 60, vertical: 10))
        contactLabel.layout.width.equal(to: 200)
    }
}
