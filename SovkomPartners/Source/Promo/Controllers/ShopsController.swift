//
//  ShopsController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 27.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class ShopsController: UIViewController {
    
    private var promoId: String?
    private var shops: [Shop]?
    
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
        
        view.register(UINib(nibName: PartnerCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PartnerCell.cellReuseIdentifier)
        
        view.backgroundColor = .white
        view.clipsToBounds = false
        
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        
        refresh.tintColor = .gray
        refresh.addTarget(self, action: #selector(updateInfo), for: .valueChanged)
    
        return refresh
    }()
    
    convenience init(promoId: String?) {
        self.init()
        
        self.promoId = promoId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Все магазины"
        
        view.backgroundColor = .white
        
        setupViews()
        
        view.showActivityIndicator()

        updateInfo()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.refreshControl = refreshControl
    }
    
    @objc
    private func updateInfo() {
        guard let promoId = promoId else { return }
        
        NetworkManager.shared.promoInfo(promoId: promoId) { [weak self] promoInfoRequest in
            guard let self = self else { return }
            
            self.shops = promoInfoRequest?.shops.items
            
            self.collectionView.reloadData()
            self.view.hideActivityIndicator()
            self.refreshControl.endRefreshing()
        }
    }
}

extension ShopsController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return shops?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartnerCell.cellReuseIdentifier, for: indexPath) as? PartnerCell else { return UICollectionViewCell() }
        
        let shop = shops?[indexPath.row]
        
        cell.setup(shop: shop)
        
        return cell
        
    }
}

extension ShopsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Self.cellSize.width, height: Self.cellSize.height)
    }
}
