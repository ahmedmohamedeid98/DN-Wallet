//
//  PayVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 2/29/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class PayVC: UIViewController {

    
    //MARK:- Outlets
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var calculatedFeesLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var scanBtnLabel: UIButton!
    
    //MARK:- Properities
    
    
    //MARK:- Initialization
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownConfiguration()
        scanBtnLabel.layer.cornerRadius = 8.0
        handleNavigationBar()
    }
    
    func handleNavigationBar() {
            let titleColor = UIColor.white
            let backgroundColor = UIColor.DN.DarkBlue.color()
            self.configureNavigationBar(largeTitleColor: titleColor, backgoundColor: backgroundColor, tintColor: titleColor, title: "Pay", preferredLargeTitle: false)
    //        leftBarButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(sideMenuButtonPressed))
    //        navigationItem.leftBarButtonItem = leftBarButton
            
        }
    
    fileprivate func dropDownConfiguration() {
        // The list of array to display. Can be changed dynamically
        dropDown.optionArray = ["Egyption Pound", "Dollar", "Uouro"]
        //Its Id Values and its optional
        dropDown.optionIds = [1,23,54,22]
        //dropDown.searchText = "Egyption Pound"
        // The the Closure returns Selected Index and String
        dropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
        }
    }

}
