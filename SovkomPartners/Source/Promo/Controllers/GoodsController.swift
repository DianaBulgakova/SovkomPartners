//
//  GoodsController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 27.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

final class GoodsController: UIViewController {
    
    private var goods = [Good]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        layout.itemSize = Constants.collectionCellSize
        layout.minimumLineSpacing = Constants.collectionMinimumLineSpacing
        layout.minimumInteritemSpacing = Constants.collectionMinimumLineSpacing
        layout.sectionInset = UIEdgeInsets(side: Constants.sideOffset)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: GoodCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: GoodCell.cellReuseIdentifier)
        
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = .white
        view.clipsToBounds = false
        
        return view
    }()
    
    convenience init(goods: [Good]) {
        self.init()
        
        self.goods = goods
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Все товары"
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension GoodsController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodCell.cellReuseIdentifier, for: indexPath) as? GoodCell else { return UICollectionViewCell() }
        
        cell.setup(good: goods[indexPath.row])
        
        return cell
    }
}
