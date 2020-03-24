//
//  SideMenuVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 2/28/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {

    //let service : [Service] = [Service(]
    
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var serviceTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
        self.serviceTable.register(SideMenuCell.self, forCellReuseIdentifier: "sidemenucellid")
        
    }
    
    @IBAction func settingButtonWasPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func safeModeSwitchChange(_ sender: UISwitch) {
    }
    
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = serviceTable.dequeueReusableCell(withIdentifier: "sidemenucellid", for: indexPath) as? SideMenuCell else {return UITableViewCell()}
        cell.configure(id: 0, icon: "arrow.left", title: "Service", sys: true)
        cell.isSafe = true
        return cell
    }
    
    
}
