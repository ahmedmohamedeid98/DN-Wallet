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
    private var inSafeMode = AuthManager.shared.isAppInSafeMode
    
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
        view.backgroundColor = .DnVcBackgroundColor
        setupSearchBar()
        setupNavBar()
        setupTableView()
        setupLayout()
        configureContactTableDataSource()
        contactTable.dataSource = contactTableDataSource
        loadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    deinit {
        print("My Contact VC Free From MEMORY :: DN")
    }
    
    private func loadData() {
        NetworkManager.getUserConcats(onView: view) { (contacts, error) in
            if error != nil {
                return
            }
            
            self.originDataSource = contacts
            self.currentDataSource = contacts
            DispatchQueue.main.async {
                self.contactTable.alpha = 1.0
                self.updateTableViewDataSource()
            }
            
        }
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
        searchBar.searchTextField.textColor = .systemBlue
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
    
    func AddEditeAlert(actionName: String, msg: String, uemail: String?, completion: @escaping (UIAlertAction) -> () ) {
        alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: K.alert.cancel, style: .cancel, handler: nil)
        let alertAction = UIAlertAction(title: actionName, style: .default, handler: completion)
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
        AddEditeAlert(actionName: K.alert.add, msg: K.vc.myContactEditMsg, uemail: nil) { (action) in
            if let email = self.alert.textFields![0].text {
                if !email.isEmpty && AuthManager.shared.isValidEmail(email) {
                    NetworkManager.addNewContact(WithEmail: email, onView: self.view) { (success, id) in
                        if success {
                            let newContact = Contact(username: String(email.split(separator: "@")[0]), email: email, id: id!, identifier: UUID().uuidString)
                            self.originDataSource.append(newContact)
                            self.addContact(newContact)
                        }
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
        DispatchQueue.main.async {
            self.contactTableDataSource.apply(currentSnapshot)
        }
        
    }
    
    //MARK:- Setup TableView and Configur It's DiffableDataSource
    
    // initial contact table view
    func setupTableView() {
        contactTable = UITableView()
        contactTable.delegate = self
        contactTable.backgroundColor = .clear
        contactTable.register(MyContactCell.self, forCellReuseIdentifier: MyContactCell.reuseIdentifier)
        contactTable.rowHeight = 70
        contactTable.alpha = 0.0
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
        DispatchQueue.main.async {
            self.contactTableDataSource.apply(snapShot)
        }
        
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: K.alert.delete) { (action, view, completion) in
            var currentSnapshot = self.contactTableDataSource.snapshot()
            guard let contact = self.contactTableDataSource.itemIdentifier(for: indexPath) else {return}
            NetworkManager.deleteContact(withID: contact.id, onView: self.view) { (isSuccess) in
                if isSuccess {
                    currentSnapshot.deleteItems([contact])
                    self.originDataSource.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.contactTableDataSource.apply(currentSnapshot)
                    }
                }
            }
            completion(true)
        }
        return .init(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !inSafeMode {
            if let item = contactTableDataSource.itemIdentifier(for: indexPath) {
                let st = UIStoryboard(name: "Services", bundle: .main)
                guard let vc = st.instantiateViewController(identifier: "sendAndRequestVC") as? SendAndRequestMoney else { return }
                vc.presentedFromMyContact = true
                vc.presentedEmail = item.email
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
