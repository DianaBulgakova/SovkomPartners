//
//  ShopsController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 27.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

final class ShopsController: UIViewController {
    
    private var promoId: String?
    private var shops = [Shop]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        layout.itemSize = Constants.collectionCellSize
        layout.minimumLineSpacing = Constants.collectionMinimumLineSpacing
        layout.minimumInteritemSpacing = Constants.collectionMinimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: Constants.sideOffset, left: Constants.sideOffset, bottom: Constants.sideOffset, right: Constants.sideOffset)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: PartnerCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PartnerCell.cellReuseIdentifier)
        
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = .white
        view.clipsToBounds = false
        
        view.refreshControl = refreshControl
        
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
        
        setupViews()
        
        view.showActivityIndicator()
        updateInfo()
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
    
    @objc
    private func updateInfo() {
        guard let promoId = promoId else { return }
        
        NetworkManager.shared.promoInfo(promoId: promoId) { [weak self] promoInfoRequest in
            guard let self = self else { return }
            
            self.shops = promoInfoRequest?.shops.items ?? []
            
            self.collectionView.reloadData()
            self.view.hideActivityIndicator()
            self.refreshControl.endRefreshing()
        }
    }
}

extension ShopsController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartnerCell.cellReuseIdentifier, for: indexPath) as? PartnerCell else { return UICollectionViewCell() }
        
        cell.setup(shop: shops[indexPath.row])
        
        return cell
    }
}
