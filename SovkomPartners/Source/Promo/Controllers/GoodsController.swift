//
//  GoodsController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 27.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class GoodsController: UIViewController {
    
    private var promoId: String?
    private var goods: [Good]?
    
    private static let minimumLineSpacing: CGFloat = 8
    private static let minimumInteritemSpacing: CGFloat = 10
    
    private static let cellSize = CGSize(width: (UIScreen.main.bounds.width - 2 * Constants.sideOffset - minimumInteritemSpacing) / 2, height: 240)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = Self.minimumLineSpacing
        layout.minimumInteritemSpacing = Self.minimumInteritemSpacing
        layout.sectionInset = UIEdgeInsets(top: Constants.sideOffset, left: Constants.sideOffset, bottom: Constants.sideOffset, right: Constants.sideOffset)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: GoodCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: GoodCell.cellReuseIdentifier)
        
        view.backgroundColor = .white
        view.clipsToBounds = false
        
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    convenience init(promoId: String?) {
        self.init()
        
        self.promoId = promoId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Все товары"
        
        view.backgroundColor = .white
        
        setupViews()
        updateInfo()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateInfo() {
        guard let promoId = promoId else { return }
        
        NetworkManager.shared.promoInfo(promoId: promoId) { [weak self] promoInfoRequest in
            guard let self = self else { return }
            
            self.goods = promoInfoRequest?.promo.goods
            
            self.collectionView.reloadData()
        }
    }
}

extension GoodsController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return goods?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodCell.cellReuseIdentifier, for: indexPath) as? GoodCell else { return UICollectionViewCell() }
        
        let good = goods?[indexPath.row]
        
        cell.setup(good: good)
        
        return cell
        
    }
}

extension GoodsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Self.cellSize.width, height: Self.cellSize.height)
    }
}
