//
//  WayToBuyCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 29.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class WayToBuyCell: UITableViewCell {
    
    private lazy var labelStackView: UIStackView = {
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
        
        labelStackView.removeAllSubviews()
    }
    
    private func commonInit() {
        selectionStyle = .none
        
        contentView.addSubview(labelStackView)
        labelStackView.layout.all.equal(to: contentView, offset: UIEdgeInsets(horizontal: Constants.sideOffset, vertical: 0))
    }
    
    func setup(partner: PartnerDetail) {
        let onlinePaymentLabel = UILabel()
        let isOnlineStoreLabel = UILabel()
        let deliveryRussiaLabel = UILabel()
        
        if partner.onlinePayment {
            onlinePaymentLabel.text = "- поддержка оплаты картой"
            labelStackView.addArrangedSubview(onlinePaymentLabel)
        }
        
        if partner.isOnlineStore {
            isOnlineStoreLabel.text = "- купить товар в магазине"
            labelStackView.addArrangedSubview(isOnlineStoreLabel)
        }
        
        if partner.deliveryRussia {
            deliveryRussiaLabel.text = "- купить товар онлайн с доставкой"
            labelStackView.addArrangedSubview(deliveryRussiaLabel)
        }
    }
}
