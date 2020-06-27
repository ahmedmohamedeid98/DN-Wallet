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
        
        configureViewController()
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
    

    func configureViewController() {
        configureSearchBar()
        configureNavigationBar()
        setupTableView()
        view.addSubview(contactTable)
        contactTable.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    //MARK:- Configure Navigation Bar
    func configureNavigationBar() {
        self.configureNavigationBar(title: K.vc.myContactTitle, preferredLargeTitle: true)
        searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
        addBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add , target: self, action: #selector(addBtnPressed))
        navigationItem.rightBarButtonItems = [addBarButton, searchBarButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: K.sysImage.leftArrow), style: .plain, target: self, action: #selector(backBtnAction))
    }
    
    @objc func searchButtonPressed() {
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItems = []
    }
    
    @objc func backBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK:- Configure Table View
    
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
    
}

 
//MARK:- Configure Table View Delegate
extension MyContactsVC: UITableViewDelegate {
    
    //add deleting swip button to table view cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: K.alert.delete) { (action, view, completion) in
            self.deletingContact(atIndexPath: indexPath) //Networking method
            completion(true)
        }
        return .init(actions: [deleteAction])
    }
    
    //when user select a cell check if the app in safeMode or not if it is, then prevent navigation to sendMoney page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !inSafeMode else { return }
        if let item = contactTableDataSource.itemIdentifier(for: indexPath) {
            let st = UIStoryboard(name: "Services", bundle: .main)
            guard let vc = st.instantiateViewController(identifier: "sendAndRequestVC") as? SendAndRequestMoney else { return }
            vc.presentedFromMyContact = true
            vc.presentedEmail = item.userID.email
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK:- Configure Search Bar Delegate
extension MyContactsVC: UISearchBarDelegate {
    //=================
    // init method
    //=================
    private func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.searchTextField.stopSmartActions()
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .systemBlue
        searchBar.placeholder = K.vc.myContactSearchBarPlaceholder
        
    }
    //==================
    // delegate methods
    //==================
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
    
    //=================
    // filter methods
    //=================
    
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
                $0.userID.name.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTerm.replacingOccurrences(of: " ", with: "").lowercased())
            }
            currentDataSource = filteredResult
            updateTableViewDataSource()
        }
    }
    
}


//MARK:- Networking
extension MyContactsVC {
    ///================================
    //2. Load Table View Data
    //================================
    private func loadData() {
        Hud.showLoadingHud(onView: view, withLabel: "Load Contacts...")
        NetworkManager.getUserConcats { (result) in
            switch result {
                case .success(let contacts):
                    self.configureNetworkingSuccessCase(withData: contacts)
                case .failure(let error):
                    self.configureNetworkingFailureCase(withError: error.rawValue)
            }
        }
    }
    private func configureNetworkingSuccessCase(withData data: [Contact]) {
        Hud.hide(after: 0.0)
        self.originDataSource = data
        self.currentDataSource = data
        DispatchQueue.main.async {
            self.contactTable.alpha = 1.0
            self.updateTableViewDataSource()
        }
    }
    private func configureNetworkingFailureCase(withError error: String) {
        Hud.faildAndHide(withMessage: error)
    }
    
    
    //================================
    //2. Adding New Contact
    //================================
    private func configureAddingConatactAlert(actionName: String, msg: String, uemail: String?, completion: @escaping (UIAlertAction) -> () ) {
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
        configureAddingConatactAlert(actionName: K.alert.add, msg: K.vc.myContactEditMsg, uemail: nil) { (action) in
            if let email = self.alert.textFields![0].text {
                if !email.isEmpty && AuthManager.shared.isValidEmail(email) {
                    Hud.showLoadingHud(onView: self.view, withLabel: "Add Contact...")
                    NetworkManager.addNewContact(WithEmail: email) { (result) in
                        switch result {
                            case .success(let contact):
                                self.configureAddingContactSuccessCase(withContact: contact)
                            case .failure(let error):
                                self.configureAddingContactFailureCase(withError: error)
                        }
                    }
                }
            }
        }
       
    }
    private func configureAddingContactSuccessCase(withContact contact: Contact) {
        Hud.successAndHide()
        self.originDataSource.append(contact)
        self.addContact(contact)
    }
    private func configureAddingContactFailureCase(withError error: String) {
        Hud.faildAndHide(withMessage: error)
    }
    
    // this method call in add alert to add new contact to the table view
    func addContact(_ contact: Contact) {
        var currentSnapshot = contactTableDataSource.snapshot()
        currentSnapshot.appendItems([contact])
        DispatchQueue.main.async {
            self.contactTableDataSource.apply(currentSnapshot)
        }
        
    }
    
    
    //================================
    //2. Deleting Contact
    //================================
    private func deletingContact(atIndexPath indexPath: IndexPath) {
        var currentSnapshot = self.contactTableDataSource.snapshot()
        guard let contact = self.contactTableDataSource.itemIdentifier(for: indexPath) else {return}
        Hud.showLoadingHud(onView: self.view, withLabel: "Deleting...")
        NetworkManager.deleteContact(withID: contact._id) { (result) in
            switch result {
                case .success(_):
                    Hud.successAndHide()
                    currentSnapshot.deleteItems([contact])
                    self.originDataSource.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.contactTableDataSource.apply(currentSnapshot)
                }
                case .failure(let error):
                    Hud.faildAndHide(withMessage: error)
            }
        }
    }
    
}

