//
//  SideMenuVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 2/28/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
    }
    

    
}
