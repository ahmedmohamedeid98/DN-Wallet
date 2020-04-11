//
//  MyContactsVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/17/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class MyContactsVC: UIViewController {

    
    //MARK:- Properities
    var infoLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Find contact"
        return lb
    }()
    var searchBar: UISearchBar!
    var tableView: UITableView!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupSearchBar()
        setupTableView()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK:- setup views
    func setupNavBar() {
        navigationItem.title = "My Contacts"
        navigationController?.navigationBar.barTintColor = UIColor.DN.DarkBlue.color()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add , target: self, action: #selector(addBtnPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtnAction))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc func backBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addBtnPressed() {
        print("addBtnPressed")
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.searchTextField.stopSmartActions()
        searchBar.delegate = self
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyContactCell.self, forCellReuseIdentifier: "mycontactcellidentifier")
    }
    
    func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        searchBar.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 50))
        tableView.DNLayoutConstraint(searchBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20))
    }
}

extension MyContactsVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("a")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("b")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("c")
    }
}

extension MyContactsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycontactcellidentifier", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
