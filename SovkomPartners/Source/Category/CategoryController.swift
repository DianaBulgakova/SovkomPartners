//
//  CategoryController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 08.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

class CategoryController: UIViewController {
    
    private var canLoadMore = false
    private var page = 0
    
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
        
        layout.minimumLineSpacing = Self.minimumLineSpacing
        layout.minimumInteritemSpacing = Self.minimumInteritemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.sideOffset, bottom: 0, right: Constants.sideOffset)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: PartnerCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PartnerCell.cellReuseIdentifier)
        view.register(UINib(nibName: HeaderReusableView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        view.register(UINib(nibName: IndicatorCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: IndicatorCell.cellReuseIdentifier)
        
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
    
    convenience init(category: Category?) {
        self.init()
        
        self.category = category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category?.title
        
        setupViews()
        
        view.showActivityIndicator()
        updateInfo()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.refreshControl = refreshControl
    }
    
    @objc
    private func updateInfo() {
        guard let categoryId = category?.id else { return }
 
        NetworkManager.shared.shops(categoryId: categoryId, page: page) { [weak self] shops in
            guard let self = self else { return }
            
            let newShops = shops ?? []
            self.shops += newShops
            self.canLoadMore = Constants.paginationLimit == newShops.count
            self.page += 1
            self.view.hideActivityIndicator()
            self.refreshControl.endRefreshing()
        }
    }
}

extension CategoryController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return shops.count + (canLoadMore ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0..<shops.count:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartnerCell.cellReuseIdentifier, for: indexPath) as? PartnerCell else { return UICollectionViewCell() }
            
            let shop = shops[indexPath.row]
            
            cell.setup(shop: shop)
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCell.cellReuseIdentifier, for: indexPath) as? IndicatorCell else { return UICollectionViewCell() }
            
            cell.activityIndicator.startAnimating()
            
            updateInfo()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
        
        headerView.delegate = self
        
        return headerView
    }
}

extension CategoryController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Self.cellSize.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0..<shops.count:
            return CGSize(width: Self.cellSize.width, height: Self.cellSize.height)
        default:
            return CGSize(width: UIScreen.main.bounds.width - 2 * Constants.sideOffset, height: 40)
        }
    }
}

extension CategoryController: HeaderReusableViewDelegate {
    
    func mapButtonTapped() {
        let controller = MapController(category: category)
        navigationController?.pushViewController(controller, animated: true)
    }
}
