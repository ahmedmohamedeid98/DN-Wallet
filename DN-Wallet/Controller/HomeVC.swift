//
//  FirstViewController.swift
//  DN-Wallet
//
//  Created by Mac OS on 2/28/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    
    //MARK:- Outlets
    @IBOutlet weak var MenuBtn: UIButton!
    
    //MARK:- Properities
    
    //MARK:- Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuBtn.addTarget(self.revealViewController() , action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController().panGestureRecognizer()))
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
    }

    
}

