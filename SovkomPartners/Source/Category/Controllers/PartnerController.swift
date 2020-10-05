//
//  PartnerController.swift
//  SovkomPartners
//
//  Created by Диана Булгакова on 29.09.2020.
//  Copyright © 2020 Диана Булгакова. All rights reserved.
//

import UIKit
import SwiftClasses

final class PartnerController: UIViewController {
    
    private var canLoadMore = false
    private var page = 0
    
    private var partner: PartnerDetail?
    
    private var itemsCount = 0
    private var contacts = [String?]()
    
    private var shops = [Shop]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var sections: [PartnerSection] {
        
        var sections = [PartnerSection]()
        
        if let shopInstallment = partner?.installmentTermsTp {
            if !shopInstallment.isEmpty {
                sections.append(PartnerSection(kind: .installment, title: "Рассрочка", itemsCount: 1))
            }
        }
        
        if let isMall = partner?.isMall {
            if isMall {
                sections.append(PartnerSection(kind: .address, title: nil, itemsCount: 1))
            } else {
                sections.append(PartnerSection(kind: .button, title: nil, itemsCount: 1))
            }
        }
        
        if let phones = partner?.phones,
           let siteTitle = partner?.siteTitle {
            contacts = [phones.first, siteTitle]
            if !phones.isEmpty {
                itemsCount = 1
            }
            
            if !siteTitle.isEmpty {
                itemsCount = phones.isEmpty ? 1 : 2
            }
            
            if itemsCount > 0 {
                sections.append(PartnerSection(kind: .contacts, title: "Контакты", itemsCount: itemsCount))
            }
        }
        
        if let onlinePayment = partner?.onlinePayment,
           let isOnlineStore = partner?.isOnlineStore,
           let deliveryRussia = partner?.deliveryRussia {
            if onlinePayment || isOnlineStore || deliveryRussia {
                sections.append(PartnerSection(kind: .waysToBuy, title: "Способы покупки", itemsCount: 1))
            }
        }
        
        if let isMall = partner?.isMall {
            if isMall {
                sections.append(PartnerSection(kind: .information, title: "О торговом центре", itemsCount: 1))
            } else {
                if let partnerFasComments = partner?.fasComments {
                    if partnerFasComments.isEmpty {
                        sections.append(PartnerSection(kind: .information, title: "О партнере", itemsCount: 1))
                    } else {
                        sections.append(PartnerSection(kind: .information, title: "О партнере", itemsCount: 2))
                    }
                }
            }
        }
        
        if let isMall = partner?.isMall {
            if isMall {
                sections.append(PartnerSection(kind: .shops, title: "Магазины", itemsCount: 1))
            } else {
                if let shopPromoObjects = partner?.promosObjects {
                    if !shopPromoObjects.isEmpty {
                        sections.append(PartnerSection(kind: .promos, title: "Акции и скидки", itemsCount: 1))
                    }
                }
            }
        }
        
        return sections
    }
    
    private lazy var headerView: PartnerHeader = {
        let header = PartnerHeader()
        
        return header
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        
        view.register(InstallmentCell.self, forCellReuseIdentifier: InstallmentCell.className)
        view.register(ShopButtonCell.self, forCellReuseIdentifier: ShopButtonCell.className)
        view.register(MallAddressCell.self, forCellReuseIdentifier: MallAddressCell.className)
        view.register(ContactsCell.self, forCellReuseIdentifier: ContactsCell.className)
        view.register(WayToBuyCell.self, forCellReuseIdentifier: WayToBuyCell.className)
        view.register(AttributedLabelCell.self, forCellReuseIdentifier: AttributedLabelCell.className)
        view.register(UINib(nibName: HeaderView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderView.reuseIdentifier)
        view.register(PartnerPromosCell.self, forCellReuseIdentifier: PartnerPromosCell.className)
        view.register(PartnerShopsCell.self, forCellReuseIdentifier: PartnerShopsCell.className)
        
        view.delegate = self
        view.dataSource = self
        
        view.separatorStyle = .none
        view.backgroundColor = .white
        
        view.refreshControl = refreshControl
        
        return view
    }()
    
    private lazy var mapButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        
        button.setImage(UIImage(named: "partners_navigation_map"), for: .normal)
        
        button.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        
        refresh.tintColor = .gray
        refresh.addTarget(self, action: #selector(updateInfo), for: .valueChanged)
        
        return refresh
    }()
    
    convenience init(partner: PartnerDetail?) {
        self.init()
        
        self.partner = partner
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        setupViews()
        
        view.showActivityIndicator()
        updateInfo()
    }
    
    private func setupNavigation() {
        title = partner?.name
        
        if let isMall = partner?.isMall {
            navigationItem.rightBarButtonItem = isMall ? nil : UIBarButtonItem(customView: mapButton)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.layout.all.except(.bottom).equal(to: view)
        tableView.layout.bottom.equal(to: view.layout.safe)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = headerView
        
        headerView.layout.all.except(.bottom).equal(to: tableView)
        headerView.layout.width.equal(to: tableView.layout.width)
        headerView.layout.height.equal(to: 200)
        tableView.tableHeaderView?.layoutIfNeeded()
        
        guard let partner = partner else { return }
        headerView.setup(partner: partner)
    }
    
    @objc
    private func updateInfo() {
        guard let partner = partner else { return }
        
        if partner.isMall {
            NetworkManager.shared.storesForMall(mallId: partner.id, page: page) { [weak self] shops in
                guard let self = self else { return }
                
                let newShops = shops ?? []
                self.shops += newShops
                self.canLoadMore = Constants.paginationLimit == newShops.count
                self.page += 1
                self.view.hideActivityIndicator()
                self.refreshControl.endRefreshing()
            }
        } else {
            self.view.hideActivityIndicator()
        }
    }
    
    @objc
    private func mapButtonPressed() {
        let controller = MapController(partner: partner)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension PartnerController: UITableViewDelegate, UITableViewDataSource {
    
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
        case .installment:
            return CGFloat(60 * CGFloat(partner?.installmentTermsTp?.count ?? 0))
        case .button, .waysToBuy:
            return 80
        case .address:
            return 100
        case .information:
            AttributedLabelCell.shared.frame.size.width = tableView.frame.width
            AttributedLabelCell.shared.label.setAttributedTitle(partner?.descriptionFull?.attributedHTML)
            
            return AttributedLabelCell.shared.contentHeight
        case .promos:
            return PartnerPromosCell.height
        case .shops:
            return Constants.collectionCellHeight + 20
        default:
            return 60
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
        case .installment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InstallmentCell.className) as? InstallmentCell,
                  let partner = partner else { return UITableViewCell() }
            
            cell.setup(partner: partner)
            
            return cell
        case .address:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MallAddressCell.className) as? MallAddressCell else { return UITableViewCell() }
            
            cell.addressLabel.text = partner?.address
            
            return cell
        case .button:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShopButtonCell.className) as? ShopButtonCell else { return UITableViewCell() }
            
            return cell
        case .contacts:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsCell.className) as? ContactsCell else { return UITableViewCell() }
            
            let contact = contacts[indexPath.row]
            
            cell.contactLabel.text = contact
            
            if itemsCount == 1 {
                cell.contactLabel.text = partner?.phones.first ?? partner?.siteTitle
            }
            
            if cell.contactLabel.text == partner?.siteTitle {
                cell.contactView.image = UIImage(named: "partners_details_web")
            } else {
                cell.contactView.image = UIImage(named: "partners_details_phone")
            }
            
            return cell
        case .waysToBuy:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WayToBuyCell.className) as? WayToBuyCell,
                  let partner = partner else { return UITableViewCell() }
            
            cell.setup(partner: partner)
            
            return cell
        case .information:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttributedLabelCell.className) as? AttributedLabelCell else { return UITableViewCell() }
            
            switch indexPath.row {
            case 0:
                cell.label.setAttributedTitle(partner?.descriptionFull?.attributedHTML)
            default:
                cell.label.setAttributedTitle(partner?.fasComments?.first?.attributedHTML)
            }
            
            return cell
        case .promos:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PartnerPromosCell.className) as? PartnerPromosCell,
                  let partner = partner else { return UITableViewCell() }
            
            cell.promosObjects = partner.promosObjects ?? []
            
            return cell
        case .shops:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PartnerShopsCell.className) as? PartnerShopsCell else { return UITableViewCell() }
            
            cell.shops = shops
            
            return cell
        }
    }
}

extension PartnerController: HeaderViewDelegate {
    
    func buttonTapped(_ header: HeaderView) {
        guard let section = PartnerSection.Kind(rawValue: header.tag) else { return }
        
        switch section {
        case .installment:
            Hint.present(content: "+3 месяца рассрочки на любую покупку, Карл!", reference: header.button, superview: view)
        default:
            return
        }
    }
}
