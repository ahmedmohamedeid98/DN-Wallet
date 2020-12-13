//
//  PopUpMenu.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 5/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

protocol PopUpMenuDelegate: class {
    func selectedItem(title: String, code: String?)
}

enum PopUpMenuDataSource {
    case currency, country, creditCard
    
    var data: [PopMenuItem] {
        switch self {
            case .currency: return currencyData // this is static data comes from utilities
            case .country: return countryData
            case .creditCard: return creditCardData
        }
    }
}

final class PopUpMenu: UIViewController {

    private var searchController            = UISearchController()
    private var List                        = UITableView()
    private var shouldReloadTableView: Bool = false
    var dataSource: PopUpMenuDataSource     = .currency {
        didSet {
            originalDataSource = dataSource.data
        }
    }
    private var originalDataSource : [PopMenuItem] = []
    private var currentDataSource  : [PopMenuItem] = []
    weak var menuDelegate: PopUpMenuDelegate?
    private var listDataSource : UITableViewDiffableDataSource<Section, PopMenuItem>!
    private var lastSelectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        configureNavBar()
        view.backgroundColor    = .DnVcBackgroundColor
        currentDataSource       = originalDataSource
        setupListTable()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = .secondaryLabel
        navigationItem.title = "Menu"
    }
    
    private func setupSearchBar() {
        searchController.searchBar.placeholder                  = "Search"
        //searchController.searchResultsUpdater                   = self
        searchController.searchBar.delegate                     = self
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.searchController                         = searchController
    }
    private func setupListTable() {
        List.register(PopUpMenuCell.self, forCellReuseIdentifier: PopUpMenuCell.reuseIdentifier)
        List.showsHorizontalScrollIndicator = false
        List.backgroundColor = .clear
        List.delegate = self
        
        view.addSubview(List)
        List.DNLayoutConstraintFill()
    }
    
    private func configureDataSource() {
        listDataSource = UITableViewDiffableDataSource<Section, PopMenuItem>(tableView: List, cellProvider: { (myTable, indexPath, data) -> UITableViewCell? in
            guard let cell = myTable.dequeueReusableCell(withIdentifier: PopUpMenuCell.reuseIdentifier, for: indexPath) as? PopUpMenuCell else { return UITableViewCell() }
            cell.data = data
            return cell
        })
        applySnapshot()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PopMenuItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(currentDataSource)
        listDataSource.apply(snapshot)
    }
    
}

extension PopUpMenu: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedCell = tableView.cellForRow(at: indexPath) as? PopUpMenuCell {
            let code_ = currentDataSource[indexPath.row].code
            menuDelegate?.selectedItem(title: selectedCell.getTitle, code: code_)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension PopUpMenu: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if self.shouldReloadTableView { restorDataSource() }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterResult(searchTerm: searchText)
    }
    
    private func filterResult(searchTerm: String?) {
        guard let filter = searchTerm else { return }
        if filter.isEmpty {
            currentDataSource = originalDataSource
            applySnapshot()
            return
        }
        
        shouldReloadTableView = true
        currentDataSource = originalDataSource
        let filterdResult = currentDataSource.filter {
            $0.title.replacingOccurrences(of: " ", with: "").lowercased().contains(filter.replacingOccurrences(of: " ", with: "").lowercased())
        }
        currentDataSource = filterdResult
        applySnapshot()
    }
    
    private func restorDataSource() {
        currentDataSource = originalDataSource
        applySnapshot()
    }
}
