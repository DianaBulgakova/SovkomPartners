//
//  PromoController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 09.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

final class PromoController: UIViewController {
    
    private var promoId: String?
    
    private var promo: Promo?
    private var shops = [Shop]()
    private var goods = [Good]()
    
    private var sections: [PromoSection] {
        guard let promo = promo else { return [] }
        
        var sections = [PromoSection]()
        
        if !promo.promoDescription.isEmpty {
            sections.append(PromoSection(kind: .attributedLabel, title: promo.descriptionName))
        }
        
        if !promo.goods.isEmpty {
            sections.append(PromoSection(kind: .goods, title: promo.goodsName))
        }
        
        if !promo.actionStoresName.isEmpty {
            sections.append(PromoSection(kind: .shops, title: promo.actionStoresName))
        }
        
        return sections
    }
    
    private lazy var headerView: PromoHeader = {
        let header = PromoHeader()
        
        header.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        return header
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.title = "x"
        button.frame = CGRect(x: UIScreen.main.bounds.width - 50, y: 50, width: 30, height: 30)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.titleColor = .black
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tableView: PromoTableView = {
        let view = PromoTableView(frame: .zero, style: .grouped)
        
        view.register(AttributedLabelCell.self, forCellReuseIdentifier: AttributedLabelCell.className)
        view.register(GoodsCell.self, forCellReuseIdentifier: GoodsCell.cellReuseIdentifier)
        view.register(ParthersCell.self, forCellReuseIdentifier: ParthersCell.cellReuseIdentifier)
        view.register(UINib(nibName: HeaderView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderView.reuseIdentifier)
        
        view.delegate = self
        view.dataSource = self
        
        view.separatorStyle = .none
        view.backgroundColor = .white
        
        view.tableHeaderView = headerView
        
        return view
    }()
    
    convenience init(promoId: String) {
        self.init()
        
        self.promoId = promoId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        view.showActivityIndicator()
        updateInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func updateInfo() {
        guard let promoId = promoId else { return }
        
        NetworkManager.shared.promoInfo(promoId: promoId) { [weak self] promoInfoRequest in
            guard let self = self else { return }
            
            self.promo = promoInfoRequest?.promo
            self.shops = promoInfoRequest?.shops.items ?? []
            self.goods = promoInfoRequest?.promo.goods ?? []
            
            self.headerView.setup(promo: self.promo)
            self.tableView.reloadData()
            self.view.hideActivityIndicator()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(cancelButton)
    }
    
    @objc
    private func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension PromoController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return sections[section].itemsCount
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        
        switch section.kind {
        case .attributedLabel:
            AttributedLabelCell.shared.frame.size.width = tableView.frame.width
            AttributedLabelCell.shared.label.setAttributedTitle(promo?.promoDescription.attributedHTML)
            
            return AttributedLabelCell.shared.contentHeight
        case .goods:
            return GoodsCell.height
        case .shops:
            return ParthersCell.height
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
        
        return section.title != nil ? 60 : 0
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        
        guard let sectionTitle = section.title,
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.reuseIdentifier) as? HeaderView else { return nil }
        
        header.title.text = sectionTitle
        header.button.title = section.kind.headerButtonTitle
        header.tag = section.kind.rawValue
        
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section.kind {
        case .attributedLabel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttributedLabelCell.className) as? AttributedLabelCell else { return UITableViewCell() }
            
            cell.label.setAttributedTitle(promo?.promoDescription.attributedHTML)
            
            return cell
        case .goods:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GoodsCell.cellReuseIdentifier) as? GoodsCell else { return UITableViewCell() }
            
            cell.goods = goods
            
            return cell
        case .shops:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ParthersCell.cellReuseIdentifier) as? ParthersCell else { return UITableViewCell() }
            
            cell.shops = shops
            
            return cell
        }
    }
}

extension PromoController: HeaderViewDelegate {
    
    func buttonTapped(_ header: HeaderView) {
        guard let section = PromoSection.Kind(rawValue: header.tag) else { return }
        
        switch section {
        case .attributedLabel:
            return
        case .goods:
            let controller = GoodsController(goods: goods)
            navigationController?.pushViewController(controller, animated: true)
        case .shops:
            let controller = ShopsController(promoId: promoId)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
