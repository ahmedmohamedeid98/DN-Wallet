//
//  PopUpMenu.swift
//  DN-Wallet
//
//  Created by Mac OS on 5/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

protocol PopUpMenuDelegate: class {
    func selectedItem(title: String)
}


class PopUpMenu: UIViewController {

    private var searchBar: UISearchBar!
    private var List: UITableView!
    private var shouldReloadTableView: Bool = false
    var originalDataSource : [PopMenuItem] = []
    private var currentDataSource : [PopMenuItem] = []
    weak var menuDelegate: PopUpMenuDelegate?
    var listDataSource : UITableViewDiffableDataSource<Section, PopMenuItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnBackgroundColor
        currentDataSource = originalDataSource
        setupSearchBar()
        setupListTable()
        setupLayout()
        
        configureDataSource()
        List.dataSource = listDataSource
    
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.searchTextField.placeholder = "search items"
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .label
        searchBar.showsCancelButton = true
    }
    
    private func setupListTable() {
        List = UITableView()
        List.backgroundColor = .DnBackgroundColor
        List.register(PopUpMenuCell.self, forCellReuseIdentifier: PopUpMenuCell.reuseIdentifier)
        //List.rowHeight = 60
        List.indicatorStyle = .white
        List.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(List)
        
        searchBar.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,margins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 50))
        List.DNLayoutConstraint(searchBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
    }
    
    private func configureDataSource() {
        listDataSource = UITableViewDiffableDataSource(tableView: List, cellProvider: { (myTable, indexPath, data) -> UITableViewCell? in
            guard let cell = myTable.dequeueReusableCell(withIdentifier: PopUpMenuCell.reuseIdentifier, for: indexPath) as? PopUpMenuCell else { return UITableViewCell() }
            cell.data = data
            return cell
        })
        applySnapshot()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PopMenuItem>()
        snapshot.appendSections(Section.allCases)
        for item in currentDataSource {
            snapshot.appendItems([item])
        }
        listDataSource.apply(snapshot)
    }
    
}

extension PopUpMenu: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        List.deselectRow(at: indexPath, animated: true)
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? PopUpMenuCell else { return }
        menuDelegate?.selectedItem(title: selectedCell.getTitle())
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension PopUpMenu: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.searchTextField.text = ""
        searchBar.searchTextField.endEditing(true)
        if self.shouldReloadTableView { restorDataSource() }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            filterResult(searchTerm: text)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterResult(searchTerm: searchText)
    }
    
    private func filterResult(searchTerm: String) {
        if !searchTerm.isEmpty {
            shouldReloadTableView = true
            currentDataSource = originalDataSource
            let filterdResult = currentDataSource.filter {
                $0.title.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTerm.replacingOccurrences(of: " ", with: "").lowercased())
            }
            currentDataSource = filterdResult
            applySnapshot()
        }
    }
    
    private func restorDataSource() {
        currentDataSource = originalDataSource
        applySnapshot()
    }
}
