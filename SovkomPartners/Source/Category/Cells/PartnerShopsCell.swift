//
//  PartnerShopsCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 05.10.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class PartnerShopsCell: UITableViewCell {
    
    var shops = [Shop]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = Constants.collectionMinimumLineSpacing
        layout.minimumInteritemSpacing = Constants.collectionMinimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: Constants.sideOffset, left: Constants.sideOffset, bottom: Constants.sideOffset, right: Constants.sideOffset)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: PartnerCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PartnerCell.cellReuseIdentifier)
        
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
        
        contentView.addSubview(collectionView)
        collectionView.layout.all.equal(to: contentView)
    }
}

extension PartnerShopsCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartnerCell.cellReuseIdentifier, for: indexPath) as? PartnerCell else { return UICollectionViewCell() }
        
        let shop = shops[indexPath.row]
        
        cell.setup(shop: shop)
        
        return cell
    }
}

extension PartnerShopsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0..<shops.count:
            return Constants.collectionCellSize
        default:
            return CGSize(width: UIScreen.main.bounds.width - 2 * Constants.sideOffset, height: 40)
        }
    }
}
