//
//  BannersCell.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 06.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit

protocol BannersCellDelegate: class {
    
    func selectedBanner(_ banner: Banner)
}

class BannersCell: UITableViewCell {
    
    weak var delegate: BannersCellDelegate?
    
    static let cellReuseIdentifier = "BannersCell"
    
    static var height: CGFloat { cellSize.height + indent }
    
    private static let cellSize = CGSize(width: UIScreen.main.bounds.width - 2 * Constants.sideOffset, height: 250)
    
    private static let minimumLineSpacing: CGFloat = 8
    private static let indent: CGFloat = 40
    
    var banners = [Banner]() {
        didSet {
            pageControl.numberOfPages = banners.count
            collectionView.reloadData()
        }
    }
    
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.itemSize = Self.cellSize
        layout.minimumLineSpacing = Self.minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.sideOffset, bottom: 0, right: Constants.sideOffset)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UINib(nibName: BannerCell.cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: BannerCell.cellReuseIdentifier)
        
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = false
        
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .black
        
        return control
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
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Self.indent).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 70).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        pageControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateCurrentPage() {
        let center = CGPoint(x: collectionView.center.x + collectionView.contentOffset.x, y: collectionView.center.y + collectionView.contentOffset.y)
        
        var index = currentPage
        
        defer {
            currentPage = index
        }
        
        guard let indexPath = collectionView.indexPathForItem(at: center) else { return }
        
        index = indexPath.row
    }
}

extension BannersCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.cellReuseIdentifier, for: indexPath) as? BannerCell else { return UICollectionViewCell() }
        
        let banner = banners[indexPath.row]
        
        cell.setup(banner: banner)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let banner = banners[indexPath.row]
        
        delegate?.selectedBanner(banner)
    }
}

extension BannersCell: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentPage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            updateCurrentPage()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Self.cellSize.width + Self.minimumLineSpacing
        
        var newPage: CGFloat
        if velocity.x == 0 {
            newPage = floor((targetContentOffset.pointee.x - pageWidth / 2) / pageWidth) + 1
        } else {
            newPage = CGFloat(velocity.x > 0 ? currentPage + 1 : currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            let contentWidth = scrollView.contentSize.width
            if newPage > contentWidth / pageWidth {
                newPage = ceil(contentWidth / pageWidth) - 1
            }
        }
        
        targetContentOffset.pointee = CGPoint(x: newPage * pageWidth, y: targetContentOffset.pointee.y)
        
        updateCurrentPage()
    }
}
