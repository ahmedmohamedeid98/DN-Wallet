//
//  SecondViewController.swift
//  DN-Wallet
//
//  Created by Mac OS on 2/28/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SaleVC: UIViewController {

    
    //MARK:- Outlets
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNavigationBar()
    }
    
    func handleNavigationBar() {
        let titleColor = UIColor.white
        let backgroundColor = UIColor.DN.DarkBlue.color()
        self.configureNavigationBar(largeTitleColor: titleColor, backgoundColor: backgroundColor, tintColor: titleColor, title: "Sale", preferredLargeTitle: false)
//        leftBarButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(sideMenuButtonPressed))
//        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    //MARK:- Actions
    @IBAction func downlaodQRCodeBtn(_ sender: Any) {
    }
    
}

