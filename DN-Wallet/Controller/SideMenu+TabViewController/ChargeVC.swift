//
//  ChargeVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 2/29/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class ChargeVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var viewControllerTitle: UILabel!
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    

    //MARK:- Properities
    
    
    
    
    //MARK:- Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNavigationBar()
        view.backgroundColor = .DnBackgroundColor
    }
    
    func handleNavigationBar() {
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: .DnDarkBlue, tintColor: .white, title: "Charge - Withdrew", preferredLargeTitle: false)
    //        leftBarButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(sideMenuButtonPressed))
    //        navigationItem.leftBarButtonItem = leftBarButton
            
        }
    
    
    
    //MARK:- Actions
    @IBAction func doneBtnPressed(_ sender: Any) {
    }
    

}
