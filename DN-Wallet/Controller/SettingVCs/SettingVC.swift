//
//  SettingVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 4/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    var settingTable: UITableView!
    var userQuikDetails: UserQuikDetails!
    var navBar: DNNavBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupUserQuikDetailsView()
        setupTableView()
        setupLayout()
    }
    
//    // convert the status bar color from black to white
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setNeedsStatusBarAppearanceUpdate()
//    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
   
    
    func setupNavBar() {
        let titleColor = UIColor.white
        let backgroundColor = UIColor.DN.DarkBlue.color()
        self.configureNavigationBar(largeTitleColor: titleColor, backgoundColor: backgroundColor, tintColor: titleColor, title: "Setting", preferredLargeTitle: true)
    }
    
    func setupUserQuikDetailsView() {
        userQuikDetails = UserQuikDetails()
        userQuikDetails.userName.text = "ahmed eid"
        userQuikDetails.userEmail.text = "ahmedmohamedeid98@gmail.com"
    }
    
    func setupTableView() {
        settingTable = UITableView()
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.register(SettingCell.self, forCellReuseIdentifier: "settingcellid")
        settingTable.rowHeight = 60
        settingTable.backgroundColor = .white
    }

    func setupLayout() {
        //view.addSubview(userQuikDetails)
        view.addSubview(settingTable)
        
//        userQuikDetails.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: 80))
        settingTable.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
    }
  
}
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingSection(rawValue: section) else {return 0}
        switch section {
        case .General : return General.allCases.count
        case .Security: return SecurityOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingTable.dequeueReusableCell(withIdentifier: "settingcellid", for: indexPath) as? SettingCell else {return UITableViewCell()}
        guard let section = SettingSection(rawValue: indexPath.section) else {return UITableViewCell()}
        switch section {
        case .General : cell.sectionType = General(rawValue: indexPath.row)
        case .Security: cell.sectionType = SecurityOptions(rawValue: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let title = UILabel()
        view.backgroundColor = UIColor.DN.DarkBlue.color()
        title.font = UIFont.DN.Regular.font(size: 16)
        title.textColor = .white
        //title.backgroundColor = UIColor.DN.DarkBlue.color()
        title.text = SettingSection(rawValue: section)?.description
        view.addSubview(title)
        if section == 0 {
            view.addSubview(userQuikDetails)
            userQuikDetails.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: 80))
            title.DNLayoutConstraint(userQuikDetails.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        } else {
            title.translatesAutoresizingMaskIntoConstraints = false
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 120
        }
        return 40
    }
    
}
extension UINavigationController {

   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}
