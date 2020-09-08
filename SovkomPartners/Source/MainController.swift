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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Город не выбран"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addTapped))
        
        tableView.register(UINib(nibName: CategoryCell.cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: CategoryCell.cellReuseIdentifier)
        tableView.register(PromosCell.self, forCellReuseIdentifier: PromosCell.cellReuseIdentifier)
        tableView.register(BannersCell.self, forCellReuseIdentifier: BannersCell.cellReuseIdentifier)
        tableView.register(UINib(nibName: HeaderView.reuseIdentifier, bundle: .main), forHeaderFooterViewReuseIdentifier: HeaderView.reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        
        view.showActivityIndicator()
        updateInfo()
    }
    
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
        }
    }
    
    @objc
    private func addTapped() {
        let controller = SearchPartnerController()
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
            
            return cell
        case .promos:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PromosCell.cellReuseIdentifier) as? PromosCell else { return UITableViewCell() }
            
            cell.promos = promos
            
            return cell
        case .categories:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.cellReuseIdentifier) as? CategoryCell else { return UITableViewCell() }
            
            let category = categories[indexPath.row]
            
            cell.setup(category: category)
            
            return cell
        }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        
        guard let sectionTitle = section.kind.headerTitle,
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.reuseIdentifier) as? HeaderView else { return UIView() }
        
        header.title.text = sectionTitle
        header.button.title = section.kind.headerButtonTitle
        
        return header
    }
}
