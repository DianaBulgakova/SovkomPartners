//
//  CategoryController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 08.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

final class CategoryController: UIViewController {
    
    private var canLoadMore = false
    private var page = 0
    
    private var category: Category?
    
    private var shops = [Shop]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var malls = [Mall]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = Constants.collectionMinimumLineSpacing
        layout.minimumInteritemSpacing = Constants.collectionMinimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: Constants.sideOffset, left: Constants.sideOffset, bottom: Constants.sideOffset, right: Constants.sideOffset)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: PartnerCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PartnerCell.cellReuseIdentifier)
        view.register(UINib(nibName: HeaderReusableView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        view.register(IndicatorCell.self, forCellWithReuseIdentifier: IndicatorCell.className)
        
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = .white
        
        view.refreshControl = refreshControl
        
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
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.layout.all.equal(to: view.layout.safe)
    }
    
    @objc
    private func updateInfo() {
        guard let category = category else { return }
        
        if category.isMall {
            NetworkManager.shared.malls(page: page) { [weak self] malls in
                guard let self = self else { return }
                
                let newMalls = malls ?? []
                self.malls += newMalls
                self.canLoadMore = Constants.paginationLimit == newMalls.count
                self.page += 1
                self.view.hideActivityIndicator()
                self.refreshControl.endRefreshing()
            }
        } else {
            NetworkManager.shared.shops(categoryId: category.id, page: page) { [weak self] shops in
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
}

extension CategoryController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let category = category else { return 0 }
        
        if category.isMall {
            return malls.count + (canLoadMore ? 1 : 0)
        } else {
            return shops.count + (canLoadMore ? 1 : 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let category = category else { return UICollectionViewCell() }
        
        if category.isMall {
            switch indexPath.row {
            case 0..<malls.count:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartnerCell.cellReuseIdentifier, for: indexPath) as? PartnerCell else { return UICollectionViewCell() }
                
                let mall = malls[indexPath.row]
                
                cell.setup(mall: mall)
                
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCell.className, for: indexPath) as? IndicatorCell else { return UICollectionViewCell() }
                
                cell.activityIndicator.startAnimating()
                
                updateInfo()
                
                return cell
            }
        } else {
            switch indexPath.row {
            case 0..<shops.count:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartnerCell.cellReuseIdentifier, for: indexPath) as? PartnerCell else { return UICollectionViewCell() }
                
                let shop = shops[indexPath.row]
                
                cell.setup(shop: shop)
                
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCell.className, for: indexPath) as? IndicatorCell else { return UICollectionViewCell() }
                
                cell.activityIndicator.startAnimating()
                
                updateInfo()
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let category = category else { return UICollectionReusableView() }
        
        if category.isMall {
            return UICollectionReusableView()
        } else {
            guard kind == UICollectionView.elementKindSectionHeader,
                  let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
            
            headerView.delegate = self
            
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let category = category else { return }
        
        let partner: PartnerDetail
        
        if category.isMall {
            let mall = malls[indexPath.row]
            print(mall.id)
            
            partner = PartnerDetail(mall: mall)
        } else {
            let shop = shops[indexPath.row]
            
            partner = PartnerDetail(shop: shop)
        }
        
        let controller = PartnerController(partner: partner)
        navigationController?.pushViewController(controller, animated: true)
        
    }
}

extension CategoryController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let category = category else { return CGSize(side: 0) }
        
        if category.isMall {
            return CGSize(side: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let category = category else { return CGSize(side: 0) }
        
        if category.isMall {
            switch indexPath.row {
            case 0..<malls.count:
                return Constants.collectionCellSize
            default:
                return CGSize(width: UIScreen.main.bounds.width - 2 * Constants.sideOffset, height: 40)
            }
        } else {
            switch indexPath.row {
            case 0..<shops.count:
                return Constants.collectionCellSize
            default:
                return CGSize(width: UIScreen.main.bounds.width - 2 * Constants.sideOffset, height: 40)
            }
        }
    }
}

extension CategoryController: HeaderReusableViewDelegate {
    
    func mapButtonTapped() {
        let controller = MapController(category: category)
        navigationController?.pushViewController(controller, animated: true)
    }
}
