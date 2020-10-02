//
//  InstallmentCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 29.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class InstallmentCell: UITableViewCell {
    
    private lazy var installmentView: UIImageView = {
        let image = UIImageView()
        
        backgroundColor = .white
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        
        return image
    }()
    
    private lazy var descriptionLabelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = Constants.sideOffset
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var monthLabelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = Constants.sideOffset
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
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
        
        descriptionLabelStackView.removeAllSubviews()
        monthLabelStackView.removeAllSubviews()
    }
    
    private func commonInit() {
        selectionStyle = .none
        
        contentView.addSubview(installmentView)
        installmentView.layout.all.equal(to: contentView, offset: UIEdgeInsets(horizontal: Constants.sideOffset, vertical: 0))
        
        installmentView.addSubview(descriptionLabelStackView)
        descriptionLabelStackView.layout.all.except(.right).equal(to: installmentView, offset: UIEdgeInsets(side: 16))
        descriptionLabelStackView.layout.width.equal(to: 200)
        
        installmentView.addSubview(monthLabelStackView)
        monthLabelStackView.layout.all.except(.left).equal(to: installmentView, offset: UIEdgeInsets(side: 16))
        monthLabelStackView.layout.width.equal(to: 80)
    }
    
    func setup(partner: PartnerDetail) {
        
        guard let installmentTermsTp = partner.installmentTermsTp else { return }
        
        for installmentTermTp in installmentTermsTp {
            let descriptionLabel = UILabel()
            let monthLabel = UILabel()
            monthLabel.textAlignment = .left
            
            descriptionLabel.text = installmentTermTp.installmentTermDescription
            descriptionLabelStackView.addArrangedSubview(descriptionLabel)
            
            monthLabel.text = "\(installmentTermTp.month) мес"
            monthLabelStackView.addArrangedSubview(monthLabel)
        }
    }
}
