//
//  PartnerPromosCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 29.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class PartnerPromosCell: UITableViewCell {
    
    var promosObjects = [PromosObject]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    static var height: CGFloat { Constants.collectionCellSize.height + indent }
    
    private static let indent: CGFloat = 40
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.itemSize = Constants.collectionCellSize
        layout.minimumLineSpacing = Constants.collectionMinimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.sideOffset, bottom: 0, right: Constants.sideOffset)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: PromoCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PromoCell.cellReuseIdentifier)
        
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        
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

extension PartnerPromosCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return promosObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoCell.cellReuseIdentifier, for: indexPath) as? PromoCell else { return UICollectionViewCell() }
        
        let promosObject = promosObjects[indexPath.row]
        
        cell.setup(promosObject: promosObject)
        
        return cell
    }
}
