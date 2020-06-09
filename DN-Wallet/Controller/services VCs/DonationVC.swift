//
//  DonationVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/18/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

enum charitySection: CaseIterable {
    case main
}

class DonationVC: UIViewController {
    
    
    //MARK:- Properities
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var shouldRestoreCurrentDataSource: Bool = false
    var searchBarButton: UIBarButtonItem!
    var currentDataSource: [Charity] = []
    var charityLogo: [UIImage?] = []
    var originDataSource: [Charity] = []
    var charityTableDataSource: UITableViewDiffableDataSource<charitySection, Charity>!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        loadData()
        setupSearchBar()
        setupNavBar()
        setupTableView()
        setupLayout()
        configureDiffableDateSource()
        tableView.dataSource = charityTableDataSource
    }
    
    func loadData() {
        DNData.getCharityOrganizationInitialData(onView: view) { (charityList, error) in
            if error == nil {
                self.originDataSource = charityList
                self.currentDataSource = self.originDataSource
                self.updateTableInMainThread()
            }
        }
    }
    func updateTableInMainThread() {
        DispatchQueue.main.async {
            self.tableView.alpha = 1.0
            self.updateTableViewDataSource()
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK:- setup views
    
    func setupNavBar() {
        self.configureNavigationBar(title: K.vc.donationvcTitle, preferredLargeTitle: true)
        searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
        navigationItem.rightBarButtonItem = searchBarButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: K.sysImage.leftArrow), style: .plain, target: self, action: #selector(backBtnAction))
    }
    
    @objc func backBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.searchTextField.stopSmartActions()
        searchBar.searchTextField.textColor = .systemBlue
        searchBar.placeholder = K.vc.donationSearchBarPlaceholder
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.indicatorStyle = .white
        tableView.backgroundColor = .clear
        tableView.register(DonationCell.self, forCellReuseIdentifier: DonationCell.reuseIdentifier)
        tableView.rowHeight = 70
        tableView.alpha = 0.0
    }
    
    private func configureDiffableDateSource() {
        charityTableDataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (table, indexPath, data) -> UITableViewCell? in
            guard let cell = table.dequeueReusableCell(withIdentifier: DonationCell.reuseIdentifier, for: indexPath) as? DonationCell else {fatalError("can not dequeue charity cell")}
            cell.data = self.currentDataSource[indexPath.row]
            return cell
        })
        
        updateTableViewDataSource()
    }
    
    private func updateTableViewDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<charitySection, Charity>()
        snapShot.appendSections(charitySection.allCases)
        for item in currentDataSource {
            snapShot.appendItems([item])
        }
        charityTableDataSource.apply(snapShot)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    @objc func searchButtonPressed() {
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItem = nil
    }
    
    // the main function that use to filter data during searching
    private func filtercurrentDataSource(searchTerm: String) {
        if !searchTerm.isEmpty {
            shouldRestoreCurrentDataSource = true
            currentDataSource = originDataSource
            let filteredResult = currentDataSource.filter {
                $0.name.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTerm.replacingOccurrences(of: " ", with: "").lowercased())
            }
            currentDataSource = filteredResult
            updateTableViewDataSource()
        }
    }
    
    private func restoreCurrentDataSource() {
        currentDataSource = originDataSource
        updateTableViewDataSource()
    }

}

extension DonationVC: UISearchBarDelegate {
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            filtercurrentDataSource(searchTerm: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        searchBar.showsCancelButton = false
        navigationItem.rightBarButtonItem = searchBarButton
        if shouldRestoreCurrentDataSource { restoreCurrentDataSource() }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtercurrentDataSource(searchTerm: searchText)
    }
}

extension DonationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DonationDetailsVC()
        guard let charity = charityTableDataSource.itemIdentifier(for: indexPath) else { return }
        vc.charityID = charity.id
        vc.title = charity.name
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
}
