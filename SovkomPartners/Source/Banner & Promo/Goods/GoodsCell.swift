//
//  GoodsCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 24.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class GoodsCell: UITableViewCell {
    
    static let cellReuseIdentifier = "GoodsCell"
    
    var goods = [Good]() {
        didSet {
            collectionView.reloadData()
        }
    }
    static var height: CGFloat { cellSize.height + indent }
    
    private static let cellSize = CGSize(width: (UIScreen.main.bounds.width - 3 * Constants.sideOffset) / 2, height: 250)
    
    private static let minimumLineSpacing: CGFloat = 8
    private static let indent: CGFloat = 40
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.itemSize = Self.cellSize
        layout.minimumLineSpacing = Self.minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.sideOffset, bottom: 0, right: Constants.sideOffset)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: GoodCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: GoodCell.cellReuseIdentifier)
        
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = false
        
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
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension GoodsCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodCell.cellReuseIdentifier, for: indexPath) as? GoodCell else { return UICollectionViewCell() }
        
        let good = goods[indexPath.row]
        
        cell.setup(good: good)
        
        return cell
    }
}
