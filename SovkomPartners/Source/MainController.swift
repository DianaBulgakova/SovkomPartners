//
//  MainController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 03.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

final class MainController: UIViewController {
    
    private var banners = [Banner]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var categories = [Category]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var promos = [Promo]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var sections: [MainSection] {
        var sections = [MainSection]()
        
        if !banners.isEmpty {
            sections.append(MainSection(kind: .banners))
        }
        
        if !promos.isEmpty {
            sections.append(MainSection(kind: .promos))
        }
        
        if !categories.isEmpty {
            sections.append(MainSection(kind: .categories, itemsCount: categories.count))
        }
        
        return sections
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        
        refresh.tintColor = .gray
        refresh.addTarget(self, action: #selector(updateInfo), for: .valueChanged)
    
        return refresh
    }()
    
    private lazy var cityButton: UIButton = {
        let button = UIButton()
        
        button.title = "Город не выбран"
        button.titleColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(selectCity), for: .touchUpInside)
        
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = cityButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addTapped))
        
        setupTableView()
        
        view.showActivityIndicator()
        updateInfo()
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.barTintColor = .white
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: CategoryCell.cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: CategoryCell.cellReuseIdentifier)
        tableView.register(PromosCell.self, forCellReuseIdentifier: PromosCell.cellReuseIdentifier)
        tableView.register(BannersCell.self, forCellReuseIdentifier: BannersCell.cellReuseIdentifier)
        tableView.register(UINib(nibName: HeaderView.reuseIdentifier, bundle: .main), forHeaderFooterViewReuseIdentifier: HeaderView.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
       
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = refreshControl
        
        tableView.contentInset.top = 16
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
    }
    
    @objc
    private func updateInfo() {
        let group = DispatchGroup()
        
        group.enter()
        NetworkManager.shared.categories { [weak self] categories in
            self?.categories = categories ?? []
            group.leave()
        }
        
        group.enter()
        NetworkManager.shared.promos { [weak self] promos in
            self?.promos = promos ?? []
            group.leave()
        }
        
        group.enter()
        NetworkManager.shared.banners { [weak self] banners in
            self?.banners = banners ?? []
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view.hideActivityIndicator()
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc
    private func addTapped() {
        let controller = SearchPartnerController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc
    private func selectCity() {
        let controller = SearchCityController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return sections[section].itemsCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section.kind {
        case .banners:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BannersCell.cellReuseIdentifier) as? BannersCell else { return UITableViewCell() }
            
            cell.banners = banners
            cell.delegate = self
            
            return cell
        case .promos:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PromosCell.cellReuseIdentifier) as? PromosCell else { return UITableViewCell() }
            
            cell.promos = promos
            cell.delegate = self
            
            return cell
        case .categories:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.cellReuseIdentifier) as? CategoryCell else { return UITableViewCell() }
            
            let category = categories[indexPath.row]
            
            cell.setup(category: category)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        let controller = CategoryController(category: category)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        
        switch section.kind {
        case .banners:
            return BannersCell.height
        case .promos:
            return PromosCell.height
        case .categories:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
        
        return section.kind.headerTitle != nil ? 60 : 0
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        
        guard let sectionTitle = section.kind.headerTitle,
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.reuseIdentifier) as? HeaderView else { return UIView() }
        
        header.title.text = sectionTitle
        header.button.title = section.kind.headerButtonTitle
        header.tag = section.kind.rawValue
        
        header.delegate = self
        
        return header
    }
}

extension MainController: PromosCellDelegate {
    
    func selectedPromo(_ promo: Promo) {
        let controller = PromoController(promo: promo)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MainController: BannersCellDelegate {
    
    func selectedBanner(_ banner: Banner) {
        let controller = PromoController(banner: banner)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MainController: HeaderViewDelegate {
    
    func buttonTapped(_ header: HeaderView) {
        guard let section = MainSection.Kind(rawValue: header.tag) else { return }
        
        switch section {
        case .banners:
            return
        case .promos:
            let controller = AllPromosController()
            navigationController?.pushViewController(controller, animated: true)
        case .categories:
            let controller = MapController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
