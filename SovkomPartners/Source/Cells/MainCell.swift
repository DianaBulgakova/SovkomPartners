//
//  PromosCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 05.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class PromosCell: UITableViewCell {
    
    static let cellReuseIdentifier = "PromosCell"
    
    static let size = CGSize(width: 240, height: 300)
    
    var promos = [Promo]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = Self.size
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: PromoCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PromoCell.cellReuseIdentifier)
        
        view.backgroundColor = .white
        
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
        
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension PromosCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoCell.cellReuseIdentifier, for: indexPath) as? PromoCell else { return UICollectionViewCell() }
        
        let promo = promos[indexPath.row] 
        
        cell.setup(promo: promo)
        
        return cell
    }
}
