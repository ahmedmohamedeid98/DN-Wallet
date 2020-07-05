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
    private lazy var charityManager: CharityManagerProtocol = CharityManager()
    
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
        charityTableDataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] (table, indexPath, data) -> UITableViewCell? in
            guard let self = self else { return UITableViewCell()}
            guard let cell = table.dequeueReusableCell(withIdentifier: DonationCell.reuseIdentifier, for: indexPath) as? DonationCell else {fatalError("can not dequeue charity cell")}
            let data = self.currentDataSource[indexPath.row]
            cell.data = data
            self.charityManager.loadImageWithStrURL(str: data.org_logo) { result in
                switch result {
                    case .success(let img):
                        DispatchQueue.main.async {
                           cell.logo.image = img
                        }
                    case .failure(_):
                        break
                }
            }
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
        let charity = currentDataSource[indexPath.row]
        vc.charityID = charity._id
        vc.title = charity.name
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
//MARK:- Networking
extension DonationVC {
    func loadData() {
        Hud.showLoadingHud(onView: view)
        charityManager.getCharityInitData { [weak self] (result) in
            Hud.hide(after: 0.0)
            guard let self = self else { return }
            switch result {
                case .success(let charityList):
                    self.configureGetCharityDataSuccessCase(list: charityList)
                case .failure(let error):
                    self.configureGetCharityDataFailureCase(error: error.localizedDescription)
            }
        }
    }
    
    
    private func configureGetCharityDataSuccessCase(list: [Charity]) {
        
        self.originDataSource = list
        self.currentDataSource = self.originDataSource
        self.updateTableInMainThread()
    }
    
    private func configureGetCharityDataFailureCase(error: String) {
        self.asyncDismissableAlert(title: "Failure", Message: error)
    }
    
    func updateTableInMainThread() {
        DispatchQueue.main.async {
            self.tableView.alpha = 1.0
            self.updateTableViewDataSource()
        }
        
    }
}
