//
//  NotificationVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 5/25/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    
    //MARK:- Properities
    // tableView
    private var tableView: UITableView!
    // search bar
    var originalData: [Message] = []
    var currentData: [Message] = []
    private var shouldResetCurrentDataToOriginal: Bool = false
    private var searchBar: UISearchBar!
    // dismiss button
    private var dismissBtn: UIButton!
    
    //MARK:- Init ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        setupDismissButon()
        setupSearchBar()
        setupTableView()
        setupLayout()
       // fetchData()
        currentData = originalData
    }
    
    //MARK:- setup VC Methods
    /*
    // Network method fetch data from API
    private func fetchData() {
        self.originalData = Message.fetchMessages()
        currentData = originalData
    }*/
    // initialize table view
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: NotificationCell.reuseIdentifier)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    // setup NotificationVC's Layout
    func setupLayout() {
        view.addSubview(dismissBtn)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        dismissBtn.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, margins: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0), size: CGSize(width: 30, height: 40))
        searchBar.DNLayoutConstraint(dismissBtn.topAnchor, left: dismissBtn.rightAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 40))
        tableView.DNLayoutConstraint(dismissBtn.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, margins: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
    // initialize search bar controller
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white
        searchBar.showsCancelButton = true
    }
    // initialize dismiss button
    private func setupDismissButon() {
        dismissBtn = UIButton(type: .system)
        dismissBtn.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        dismissBtn.tintColor = .systemGray
        dismissBtn.addTarget(self, action: #selector(dismissBtnWasPressed), for: .touchUpInside)
    }
    @objc func dismissBtnWasPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
 //MARK:- setup table view dataSource & delegate
extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier, for: indexPath) as? NotificationCell else { return UITableViewCell() }
        cell.data = currentData[indexPath.row]
                return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let notificatioCell = cell as? NotificationCell else {return}
        if notificatioCell.isNew {
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (_) in
                UIView.animate(withDuration: 0.8) {
                    notificatioCell.newLabel.isHidden = true
                }
            }
        }
    }
    
}
 //MARK:- setup search bar delegate
extension NotificationVC: UISearchBarDelegate {
    
    func resetOriginalData() {
        currentData = originalData
        tableView.reloadData()
    }
    
    func filterData(searchTerm: String) {
        if !searchTerm.isEmpty {
            shouldResetCurrentDataToOriginal = true
            currentData = originalData
            let filteredResult = currentData.filter {
                $0.sender.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTerm.replacingOccurrences(of: " ", with: "").lowercased())
            }
            currentData = filteredResult
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let txt = searchBar.text {
            filterData(searchTerm: txt)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        searchBar.searchTextField.endEditing(true)
        if shouldResetCurrentDataToOriginal { resetOriginalData() }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData(searchTerm: searchText)
    }
    
}

