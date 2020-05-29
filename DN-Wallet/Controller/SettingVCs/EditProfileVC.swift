//
//  EditProfileVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/6/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    var userProfileTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        setupTableView()
        setupLayout()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupTableView() {
        userProfileTable = UITableView()
        userProfileTable.delegate = self
        userProfileTable.dataSource = self
        userProfileTable.rowHeight = 60
        //userProfileTable.backgroundColor = .white
    }
    
    func setupLayout() {
        view.addSubview(userProfileTable)
        userProfileTable.DNLayoutConstraintFill()
    }
   

}

extension EditProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileSection.allCases.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = EditProfileSection(rawValue: indexPath.row)?.description
        cell.backgroundColor = .white
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "nothing")
    }
    
}
