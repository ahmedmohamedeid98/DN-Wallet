//
//  SignUpConfirmEmailVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SignUpConfirmEmailVC: UIViewController {
    
    //MARK:- Properities
    var inputConfirmationCode: String!
    var registerData: User?
    //MARK:- Outlets
    @IBOutlet weak var signUpBtnOutlet: UIButton!
    @IBOutlet weak var steppedProgressBar: SteppedProgressBar!
    @IBOutlet weak var optContainerView: OPT!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .DnVcBackgroundColor
        optContainerView.delegate = self
        signUpBtnOutlet.layer.cornerRadius = 20.0
        signUpBtnOutlet.isEnabled = false
        steppedProgressBar.titles = ["", "", ""]
        steppedProgressBar.currentTab = 3
    }
    
    //MARK:- IBActions
        
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        UserPreference.setValue(true, withKey: UserPreference.firstLaunchKey)
        signUpBtnOutlet.isEnabled = false
        if self.inputConfirmationCode == "2211" {
            guard let data = registerData else {return}
            Auth.shared.createAccount(user: data, onView: view) { (success, error) in
                if success {
                    Auth.shared.pushHomeViewController(vc: self)
                }
            }
        } else {
            optContainerView.reset()
            optContainerView.errorMsg.isHidden = false
        }
        
    }
    
    @IBAction func termsAndServiceBtnPressed(_ sender: UIButton) {
        // presend view controller
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension SignUpConfirmEmailVC: GetOPTValuesProtocol {
    func getOpt(with value: String) {
        self.inputConfirmationCode = value
        self.signUpBtnOutlet.isEnabled = true
    }
}
