//
//  startControllerForTest.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class startControllerForTest: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        // Do any additional setup after loading the view.
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//         // if traitCollection.userInterfaceStyle == .light {
//           //   return .darkContent
//          //} else {
//              return .lightContent
//          //}
//    }
    @IBAction func login(_ sender: Any) {
        //let storyboard = UIStoryboard(name: "Services", bundle: .main)
        //let vc = storyboard.instantiateViewController(withIdentifier: "donationVCID") as? TestDonationsVC
        //let vc = storyboard.instantiateViewController(identifier: "historyVCID") as? HistoryVC
        /// present SettingVC
        //let settingvc = SettingVC()
        //let vc = UINavigationController(rootViewController: settingvc)
        //vc.modalPresentationCapturesStatusBarAppearance = true
        //vc.modalPresentationStyle = .fullScreen
        //present(vc, animated: true)
        /// present NewSideMenu
        let newSideMenu = ContainerVC()
        newSideMenu.modalPresentationStyle = .fullScreen
        present(newSideMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func signup(_ sender: Any) {
        //let storyboard = UIStoryboard(name: "Services", bundle: .main)
        //let vc = storyboard.instantiateViewController(withIdentifier: "donationVCID") as? TestDonationsVC
        //let vc = storyboard.instantiateViewController(identifier: "historyVCID") as? HistoryVC
        let vc = DonationDetailsVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
