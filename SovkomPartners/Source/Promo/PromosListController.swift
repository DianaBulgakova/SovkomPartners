//
//  PromosListController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 10.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

final class PromosListController: UIViewController {
    
    private var promos = [Promo]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        layout.itemSize = Constants.collectionCellSize
        layout.minimumLineSpacing = Constants.collectionMinimumLineSpacing
        layout.minimumInteritemSpacing = Constants.collectionMinimumLineSpacing
        layout.sectionInset = UIEdgeInsets(side: Constants.sideOffset)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: PromoCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PromoCell.cellReuseIdentifier)
        
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = .white
        view.clipsToBounds = false
        
        return view
    }()
    
    convenience init(promos: [Promo]) {
        self.init()
        
        self.promos = promos
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = MainSection.Kind.promos.headerTitle
        
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

extension PromosListController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return promos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoCell.cellReuseIdentifier, for: indexPath) as? PromoCell else { return UICollectionViewCell() }
        
        cell.setup(promo: promos[indexPath.row])
        
        return cell
    }
}
