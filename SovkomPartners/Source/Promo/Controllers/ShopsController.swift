//
//  ShopsController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 27.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

final class ShopsController: UIViewController {
    
    private var canLoadMore = false
    private var page = 0
    
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
        view.register(IndicatorCell.self, forCellWithReuseIdentifier: IndicatorCell.className)
        
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
        
        NetworkManager.shared.promoInfo(promoId: promoId, page: page) { [weak self] promoInfoRequest in
            guard let self = self else { return }
            
            let newShops = promoInfoRequest?.shops.items ?? []
            self.shops += newShops
            self.canLoadMore = Constants.paginationLimit == newShops.count
            self.page += 1
            self.collectionView.reloadData()
            self.view.hideActivityIndicator()
            self.refreshControl.endRefreshing()
        }
    }
}

extension ShopsController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return shops.count + (canLoadMore ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0..<shops.count:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartnerCell.cellReuseIdentifier, for: indexPath) as? PartnerCell else { return UICollectionViewCell() }
            
            cell.setup(shop: shops[indexPath.row])
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCell.className, for: indexPath) as? IndicatorCell else { return UICollectionViewCell() }
            
            cell.activityIndicator.startAnimating()
            
            updateInfo()
            
            return cell
        }
    }
}

extension ShopsController: UICollectionViewDelegateFlowLayout {
    
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
