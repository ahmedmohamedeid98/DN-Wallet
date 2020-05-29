//
//  EditProfileVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/6/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class PrivacyVC: UIViewController {

    var privacyTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = false
        setupTableView()
        setupLayout()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupTableView() {
        privacyTable = UITableView()
        privacyTable.delegate = self
        privacyTable.dataSource = self
        privacyTable.register(PrivacyCell.self, forCellReuseIdentifier: "privcecellid")
        
    }
    
    func setupLayout() {
        view.addSubview(privacyTable)
        privacyTable.DNLayoutConstraintFill(top: 10)
    }
   

}

extension PrivacyVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PrivacySection.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = privacyTable.dequeueReusableCell(withIdentifier: "privcecellid", for: indexPath) as? PrivacyCell else { return UITableViewCell() }
        switch indexPath.section {
        case 0: cell.configureCell(text: PrivacySection(rawValue: 0)?.description)
        case 1: cell.configureCell(text: PrivacySection(rawValue: 1)?.description)
        case 2: cell.configureCell(text: PrivacySection(rawValue: 2)?.description)
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let title = UILabel()
        view.backgroundColor = .DnColor
        title.font = UIFont.DN.Regular.font(size: 16)
        title.textColor = .white
        title.text = PrivacySection(rawValue: section)?.title
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height =  PrivacySection(rawValue: indexPath.section)?.height else {return 0}
        return height + 40
    }
    
}
