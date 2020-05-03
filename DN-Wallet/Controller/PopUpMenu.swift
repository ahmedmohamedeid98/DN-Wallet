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
    weak var PopUpMenuDelegate: PopUpMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDataSource = originalDataSource
        setupSearchBar()
        setupListTable()
        setupLayout()
    
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.searchTextField.placeholder = "search items"
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white
        searchBar.showsCancelButton = true
    }
    
    private func setupListTable() {
        List = UITableView()
        List.backgroundColor = .white
        List.delegate = self
        List.dataSource = self
        List.register(PopUpMenuCell.self, forCellReuseIdentifier: PopUpMenuCell.reuseIdentifier)
        List.rowHeight = 60
        List.indicatorStyle = .white
    }
    
    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(List)
        
        searchBar.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: 50))
        List.DNLayoutConstraint(searchBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
    }
    

}

extension PopUpMenu: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = List.dequeueReusableCell(withIdentifier: PopUpMenuCell.reuseIdentifier, for: indexPath) as? PopUpMenuCell else { return UITableViewCell() }
        cell.data = currentDataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        List.deselectRow(at: indexPath, animated: true)
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? PopUpMenuCell else { return }
        PopUpMenuDelegate?.selectedItem(title: selectedCell.getTitle())
        dismiss(animated: true, completion: nil)
    }
    
}

extension PopUpMenu: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            filterResult(searchTerm: text)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.searchTextField.text = ""
        if self.shouldReloadTableView { restorDataSource() }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filterResult(searchTerm: searchText)
        }
    }
    
    private func filterResult(searchTerm: String) {
        if searchTerm.count > 0 {
            shouldReloadTableView = true
            let filterdResult = currentDataSource.filter {
                $0.title.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTerm.replacingOccurrences(of: " ", with: "").lowercased())
            }
            currentDataSource = filterdResult
            reloadList()
        }
    }
    
    private func reloadList() {
        self.List.beginUpdates()
        self.List.reloadData()
        self.List.endUpdates()
    }
    
    private func restorDataSource() {
        currentDataSource = originalDataSource
        reloadList()
    }
}
