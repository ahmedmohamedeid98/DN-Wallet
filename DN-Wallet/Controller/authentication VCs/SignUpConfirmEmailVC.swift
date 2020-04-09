//
//  SignUpConfirmEmailVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SignUpConfirmEmailVC: UIViewController, GetOPTValuesProtocol {
    
    
    
    
    func getOptValues(tf1: Int, tf2: Int, tf3: Int, tf4: Int) {
        self.inputConfirmationCode = "\(tf1)\(tf2)\(tf3)\(tf4)"
        print("our amzing code: \(tf1)\(tf2)\(tf3)\(tf4)")
        self.signUpBtnOutlet.isEnabled = true
    }
    

    //MARK:- Outlets
    @IBOutlet weak var signUpBtnOutlet: UIButton!
    @IBOutlet weak var steppedProgressBar: SteppedProgressBar!
    @IBOutlet weak var optContainerView: OPT!
    
    
    
    //MARK:- Properities
    var inputConfirmationCode: String!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        optContainerView.delegate = self
        signUpBtnOutlet.layer.cornerRadius = 20.0
        signUpBtnOutlet.isEnabled = false
        steppedProgressBar.titles = ["", "", ""]
        steppedProgressBar.currentTab = 3
    }
    
    //MARK:- Methods

    
    
    
    
    
    //MARK:- IBActions
        
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "haveAccount")
        signUpBtnOutlet.isEnabled = false
        if self.inputConfirmationCode == "2211" {
//            let st = UIStoryboard(name: "Main", bundle: .main)
//            let vc = st.instantiateViewController(identifier: "startScreanID") as? SWRevealViewController
//            vc?.modalPresentationStyle = .fullScreen
//            present(vc!, animated: true)
        } else {
            optContainerView.reset()
            optContainerView.errorMsg.isHidden = false
        }
        
    }
    
}
