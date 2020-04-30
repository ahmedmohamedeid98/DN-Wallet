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
    
    let data: [CharityOrg] = [CharityOrg(title: "ElNasser Shcool", email: "egd87@org.co.com", logoLink: "http://www.google.com", imageLink: "http://www.google.com", location: Location(lat: 20.05, log: 47.54), concats: "151451\n1451451", address: "dkjlskd skdlksdjs lsdlkdj slkjsdjs ljsdkjsd", founders: "sksldskds kljskdjsd lskjdksd lskdjslkd", vision: "ksdlkjdlkjlsk skldjksd lasdkj sdlk ds sldks jdlks sd kasldoidj sds lskd", about: "skdlsdksd dskdkls ds dskdsd sds ds; dsd;sldksdkod q sd ods dslds;dkpq dsa sldks dqpks dspdsod ksdpsd ds dsa;dkspd apsd sdkpsodkaod s dsodk spdsd s fjposfjsjd psod asdpao aodoqpos s dspodksdksok w wokposkdosd qkwqpqokowkd aspodks dpasod ksda spodkkw wodsjiw pskdosk wpskdpa apowkd aspoas pasodk asp asd"),
    CharityOrg(title: "Google", email: "egd87@org.co.com", logoLink: "http://www.google.com", imageLink: "http://www.google.com", location: Location(lat: 20.05, log: 47.54), concats: "151451\n1451451", address: "dkjlskd skdlksdjs lsdlkdj slkjsdjs ljsdkjsd", founders: "sksldskds kljskdjsd lskjdksd lskdjslkd", vision: "ksdlkjdlkjlsk skldjksd lasdkj sdlk ds sldks jdlks sd kasldoidj sds lskd", about: "skdlsdksd dskdkls ds dskdsd sds ds; dsd;sldksdkod q sd ods dslds;dkpq dsa sldks dqpks dspdsod ksdpsd ds dsa;dkspd apsd sdkpsodkaod s dsodk spdsd s fjposfjsjd psod asdpao aodoqpos s dspodksdksok w wokposkdosd qkwqpqokowkd aspodks dpasod ksda spodkkw wodsjiw pskdosk wpskdpa apowkd aspoas pasodk asp asd"),
    CharityOrg(title: "Yahoo", email: "egd87@org.co.com", logoLink: "http://www.google.com", imageLink: "http://www.google.com", location: Location(lat: 20.05, log: 47.54), concats: "151451\n1451451", address: "dkjlskd skdlksdjs lsdlkdj slkjsdjs ljsdkjsd", founders: "sksldskds kljskdjsd lskjdksd lskdjslkd", vision: "ksdlkjdlkjlsk skldjksd lasdkj sdlk ds sldks jdlks sd kasldoidj sds lskd", about: "skdlsdksd dskdkls ds dskdsd sds ds; dsd;sldksdkod q sd ods dslds;dkpq dsa sldks dqpks dspdsod ksdpsd ds dsa;dkspd apsd sdkpsodkaod s dsodk spdsd s fjposfjsjd psod asdpao aodoqpos s dspodksdksok w wokposkdosd qkwqpqokowkd aspodks dpasod ksda spodkkw wodsjiw pskdosk wpskdpa apowkd aspoas pasodk asp asd")]
    
    //MARK:- Properities
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var shouldRestoreCurrentDataSource: Bool = false
    var searchBarButton: UIBarButtonItem!
    var currentDataSource: [CharityOrg] = []
    var originDataSource: [CharityOrg] = []
    var charityTableDataSource: UITableViewDiffableDataSource<charitySection, CharityOrg>!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnBackgroundColor
        originDataSource = data
        currentDataSource = originDataSource
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
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1.0)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Donation"
        
        searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
        
        navigationItem.rightBarButtonItem = searchBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnAction))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc func backBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.searchTextField.stopSmartActions()
        searchBar.placeholder = "search about organization"
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white
        
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .DnBackgroundColor
        tableView.delegate = self
        tableView.indicatorStyle = .white
        tableView.register(DonationCell.self, forCellReuseIdentifier: DonationCell.reuseIdentifier)
        tableView.rowHeight = 70
    }
    
    private func configureDiffableDateSource() {
        charityTableDataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (table, indexPath, data) -> UITableViewCell? in
            guard let cell = table.dequeueReusableCell(withIdentifier: DonationCell.reuseIdentifier, for: indexPath) as? DonationCell else {fatalError("can not dequeue charity cell")}
            cell.org_mail = data.email
            cell.org_title = data.title
            return cell
        })
        
        updateTableViewDataSource()
    }
    
    private func updateTableViewDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<charitySection, CharityOrg>()
        snapShot.appendSections(charitySection.allCases)
        for item in currentDataSource {
            snapShot.appendItems([item])
        }
        charityTableDataSource.apply(snapShot)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
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
                $0.title.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTerm.replacingOccurrences(of: " ", with: "").lowercased())
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
        guard let currentOrg = charityTableDataSource.itemIdentifier(for: indexPath) else { return }
        vc.data = currentOrg
        print("currentOrg \(currentOrg)")
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
}

