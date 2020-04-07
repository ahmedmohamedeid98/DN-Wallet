//
//  DonationVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/18/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit


class DonationVC: UIViewController {
    
    let data: [CharityOrg] = [CharityOrg(id: "ss", title: "dd", email: "dd", logoLink: "dd", imageLink: "aa", location: Location(lat: 20.05, log: 47.54), concats: "54ww", address: "45s", founders: "ss", vision: "ss", about: "ss")]
    
    func cellButtonActions(orgId: String, tag: Int) {
        if tag == 0 { // tag 0 stand to detail Button, tag 1 stand to denote button
            for org in data {
                if org.id == orgId {
                    let vc = DonationDetailsVC()
                    vc.org = org
                    vc.modalPresentationStyle = .fullScreen
                    present(vc, animated: true, completion: nil)
                    break
                }
            }
        } else {
            for org in data {
                if org.id == orgId {
                    let vc = DonationDetailsVC()
                    vc.org = org
                    vc.modalPresentationStyle = .fullScreen
                    present(vc, animated: true, completion: nil)
                    break
                }
            }
            
        }
    }
    
    
    
        //MARK:- Properities
    var navBar: DNNavBar!
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
    }
    
    // convert the status bar color from black to white
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK:- setup views
    
    func setupNavBar() {
        navBar = DNNavBar()
        navBar.title.text = "Donation"
        navBar.addLeftItem(imageName: "arrow.left", systemImage: true)
        navBar.leftBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
    }
    
    @objc func backBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.searchTextField.stopSmartActions()
        searchBar.placeholder = "search about organization"
        searchBar.delegate = self
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.indicatorStyle = .white
        tableView.register(DonationCell.self, forCellReuseIdentifier: "donationcellidentifier")
    }
    
    func setupLayout() {
        view.addSubview(navBar)
    //     view.addSubview(infoLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
    navBar.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: 100))
        
        searchBar.DNLayoutConstraint(navBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 20,left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 50))
        tableView.DNLayoutConstraint(searchBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20))
    }

}

extension DonationVC: UISearchBarDelegate {
        
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

extension DonationVC: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "donationcellidentifier", for: indexPath) as? DonationCell else {return UITableViewCell()}
        cell.donationDelegate = self
        let org = data[indexPath.row]
        cell.configureCell(id: org.id, name: org.title, email: org.email, logo: UIImage())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
        
}

