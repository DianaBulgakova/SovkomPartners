//
//  CategoryController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 08.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class CategoryController: UIViewController {
    
    private var shops = [Shop]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var category: Category?

    private static let minimumLineSpacing: CGFloat = 8
    private static let minimumInteritemSpacing: CGFloat = 10
    
    private static let cellSize = CGSize(width: (UIScreen.main.bounds.width - 2 * Constants.sideOffset - minimumInteritemSpacing) / 2, height: 240)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        layout.itemSize = Self.cellSize
        layout.minimumLineSpacing = Self.minimumLineSpacing
        layout.minimumInteritemSpacing = Self.minimumInteritemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.sideOffset, bottom: 0, right: Constants.sideOffset)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: CategoryPartnerCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CategoryPartnerCell.cellReuseIdentifier)
        view.register(UINib(nibName: HeaderReusableView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        view.backgroundColor = .white
        view.clipsToBounds = false
        
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    convenience init(category: Category?) {
        self.init()
        
        self.category = category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category?.title
        
        setupViews()
        updateInfo()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateInfo() {
        guard let categoryId = category?.id else { return }
        
        NetworkManager.shared.shops(categoryId: categoryId) { shops in
            self.shops = shops ?? []
        }
    }
}

extension CategoryController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryPartnerCell.cellReuseIdentifier, for: indexPath) as? CategoryPartnerCell else { return UICollectionViewCell() }
        
        let shop = shops[indexPath.row]
        
        cell.setup(shop: shop)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
        
        return headerView
    }
}

extension CategoryController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Self.cellSize.width, height: 60)
    }
}
