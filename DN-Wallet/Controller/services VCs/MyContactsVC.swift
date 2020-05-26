//
//  MyContactsVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/17/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

enum contactTableSection: CaseIterable {
    case main
}


class ContactDataSource:  UITableViewDiffableDataSource<contactTableSection, Contact> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

class MyContactsVC: UIViewController {

    
    //MARK:- Properities
    private var inSafeMode = Auth.shared.isAppInSafeMode
    
    var searchBar: UISearchBar!
    var contactTable: UITableView!
    var contactTableDataSource: ContactDataSource!
    var currentDataSource: [Contact] = []
    var originDataSource: [Contact] = []
    var shouldRestoreCurrentDataSource: Bool = false
    var alert: UIAlertController!
    
    var addBarButton: UIBarButtonItem!
    var searchBarButton: UIBarButtonItem!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        originDataSource = [Contact(username: "ahmed", email: "ahmed54@gmail.com"),
                            Contact(username: "zoro", email: "zoro54@gmail.com"),
                            Contact(username: "mohamed", email: "mohamed_eid54@gmail.com"),
                            Contact(username: "eid", email: "eid87214@gmail.com")
        ]
        currentDataSource = originDataSource
        setupSearchBar()
        setupNavBar()
        setupTableView()
        setupLayout()
        configureContactTableDataSource()
        contactTable.dataSource = contactTableDataSource
        //updateTableViewDataSource()
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    deinit {
        print("My Contact VC Free From MEMORY :: DN")
    }
    
    //MARK:- setup views
    func setupNavBar() {
        self.configureNavigationBar(title: K.vc.myContactTitle, preferredLargeTitle: true)
        searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
        addBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add , target: self, action: #selector(addBtnPressed))
        navigationItem.rightBarButtonItems = [addBarButton, searchBarButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: K.sysImage.leftArrow), style: .plain, target: self, action: #selector(backBtnAction))
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.searchTextField.stopSmartActions()
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = K.vc.myContactSearchBarPlaceholder
        
    }
    
    //MARK:- Navigation Bar Item's Action
    @objc func searchButtonPressed() {
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItems = []
    }
    
    @objc func backBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func AddEditeAlert(actionName: String, msg: String, uname: String?, uemail: String?, completion: @escaping (UIAlertAction) -> () ) {
        alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: K.alert.cancel, style: .cancel, handler: nil)
        let alertAction = UIAlertAction(title: actionName, style: .default, handler: completion)
        alert.addTextField { (usernameText) in
            usernameText.font = UIFont.systemFont(ofSize: 14)
            usernameText.textColor = .DnDarkBlue
            usernameText.placeholder = K.placeholder.username
            usernameText.text = uname
        }
        alert.addTextField { (emailText) in
            emailText.font = UIFont.systemFont(ofSize: 14)
            emailText.textColor = .DnDarkBlue
            emailText.placeholder = K.placeholder.email
            emailText.text = uemail
        }
        
        alert.addAction(cancelAction)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func addBtnPressed() {
        AddEditeAlert(actionName: K.alert.add, msg: K.vc.myContactEditMsg, uname: nil, uemail: nil) { (action) in
            if let username = self.alert.textFields![0].text, let email = self.alert.textFields![1].text {
                if !username.isEmpty && !email.isEmpty && Auth.shared.isValidEmail(email) {
                    // check if email is already exist
                    if self.emailIsExist(email) {
                        self.alert.dismiss(animated: true, completion: nil)
                        Alert.syncActionOkWith(K.vc.myContactAlertEmailExist, msg: K.vc.myContactAlertEmailExistMsg, viewController: self)
                    } else {
                        // add it locally
                        let contact = Contact(username: username, email: email)
                        self.originDataSource.append(contact)
                        self.addContact(contact)
                        // add it to API <=============================================
                    }
                }
            
            }
        }
       
    }
    
    // when user try to add new contact this function check if there contact is already exist or not.
    func emailIsExist(_ email: String) -> Bool {
        for item in originDataSource {
            if item.email == email {
                return true
            }
        }
        return false
    }
    
    // this method call in add alert to add new contact to the table view
    func addContact(_ contact: Contact) {
        var currentSnapshot = contactTableDataSource.snapshot()
        currentSnapshot.appendItems([contact])
        contactTableDataSource.apply(currentSnapshot)
    }
    
    //MARK:- Setup TableView and Configur It's DiffableDataSource
    
    // initial contact table view
    func setupTableView() {
        contactTable = UITableView()
        contactTable.backgroundColor = .white
        contactTable.delegate = self
        contactTable.register(MyContactCell.self, forCellReuseIdentifier: MyContactCell.reuseIdentifier)
        contactTable.rowHeight = 70
    }
    
    // populate table view cell
    func configureContactTableDataSource() {
        contactTableDataSource = .init(tableView: contactTable, cellProvider: {
            (table, indexPath, data) -> UITableViewCell? in
            guard let cell = self.contactTable.dequeueReusableCell(withIdentifier: MyContactCell.reuseIdentifier, for: indexPath) as? MyContactCell else {fatalError("can not dequue my contact cell")}
            cell.data = data
            return cell
        })
        
        
        
        updateTableViewDataSource()
    }
    
    // initial contact table with contact's data.
    func updateTableViewDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<contactTableSection, Contact>()
        snapShot.appendSections(contactTableSection.allCases)
        currentDataSource.forEach { snapShot.appendItems([$0], toSection: .main) }
        contactTableDataSource.apply(snapShot)
    }
    
    //MARK:- Search Bar's assest method
    
    // call this func when the user press cancel button
    func restoreCurrentDataSource() {
        currentDataSource = originDataSource
        updateTableViewDataSource()
    }
    
    // the main function that use to filter data during searching
    func filtercurrentDataSource(searchTerm: String) {
        if !searchTerm.isEmpty {
            shouldRestoreCurrentDataSource = true
            currentDataSource = originDataSource
            let filteredResult = currentDataSource.filter {
                $0.username.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTerm.replacingOccurrences(of: " ", with: "").lowercased())
            }
            currentDataSource = filteredResult
            updateTableViewDataSource()
        }
    }
    
    // setup view Controller's subviews layout
    func setupLayout() {
        view.addSubview(contactTable)
        contactTable.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
}


extension MyContactsVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            filtercurrentDataSource(searchTerm: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItems = [addBarButton, searchBarButton]
        if shouldRestoreCurrentDataSource { restoreCurrentDataSource() }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtercurrentDataSource(searchTerm: searchText)
    }
    
}

extension MyContactsVC: UITableViewDelegate { //, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editeAction = UIContextualAction(style: .normal, title: K.alert.edit) { (action, view, completion) in
            var currentSnapshot = self.contactTableDataSource.snapshot()
            guard let contact = self.contactTableDataSource.itemIdentifier(for: indexPath) else {return}
            self.AddEditeAlert(actionName: K.alert.edit, msg: K.vc.myContactEditMsg, uname: contact.username, uemail: contact.email) { (action) in
                if let username = self.alert.textFields![0].text, let email = self.alert.textFields![1].text {
                    if !username.isEmpty && !email.isEmpty && Auth.shared.isValidEmail(email) {
                        if username != contact.username || email != contact.email {
                            if username != contact.username {
                                contact.username = username
                            }
                            if email != contact.email {
                                contact.email = email
                            }
                            currentSnapshot.reloadItems([contact])
                            self.contactTableDataSource.apply(currentSnapshot)
                            // update with api <======================================
                        }else {
                            // do nothing
                        }
                    }
        
                }
            }
           completion(true)
        }
        editeAction.backgroundColor = .DnDarkBlue
        return .init(actions: [editeAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: K.alert.delete) { (action, view, completion) in
            var currentSnapshot = self.contactTableDataSource.snapshot()
            guard let contact = self.contactTableDataSource.itemIdentifier(for: indexPath) else {return}
            currentSnapshot.deleteItems([contact])
            self.originDataSource.remove(at: indexPath.row)
            self.contactTableDataSource.apply(currentSnapshot)
            completion(true)
        }
        return .init(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !inSafeMode {
            if let item = contactTableDataSource.itemIdentifier(for: indexPath) {
                let vc = SendAndRequestMoney()
                vc.presentedFromMyContact = true
                vc.presentedEmail = item.email
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
