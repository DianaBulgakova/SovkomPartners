//
//  PromoTableView.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 26.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import Foundation
import UIKit

class PromoTableView: UITableView {
    
    override var tableHeaderView: UIView? {
        get {
            return elasticHeaderView
        }
        set {
            elasticHeaderView = newValue
        }
    }
    
    private var elasticHeaderView: UIView? {
        willSet {
            elasticHeaderView?.removeFromSuperview()
        }
        didSet {
            if let headerView = elasticHeaderView {
                addSubview(headerView)
                bringSubviewToFront(headerView)
                
                updateHeaderMargins()
                let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                contentInset.top = headerSize.height - safeAreaInsets.top
                contentOffset.y = -headerSize.height
            }
        }
    }
    
    private func updateHeaderMargins () {
        elasticHeaderView?.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: safeAreaInsets.top,
            leading: safeAreaInsets.left,
            bottom: 0,
            trailing: safeAreaInsets.right)
    }
    
    override var contentOffset: CGPoint {
        didSet {
            layoutHeaderView()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutHeaderView()
    }
    
    private func layoutHeaderView () {
        updateHeaderMargins()
        
        if let headerView = elasticHeaderView {
            let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let stretch = -min(0, contentOffset.y + headerSize.height)
            let headerRect = CGRect(
                x: 0,
                y: -headerSize.height - stretch,
                width: bounds.width,
                height: headerSize.height + stretch)
            
            headerView.frame = headerRect
            
            contentInset.top = headerSize.height - safeAreaInsets.top
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let header = super.tableHeaderView
        super.tableHeaderView = nil
        elasticHeaderView = header
    }
}
