//
//  SignUpConfirmEmailVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SignUpConfirmEmailVC: UIViewController, GetOPTValuesProtocol {
    
    
    func getOptValues(tf1: Int, tf2: Int, tf3: Int, tf4: Int) {
        self.inputConfirmationCode = "\(tf1)\(tf2)\(tf3)\(tf4)"
        self.signUpBtnOutlet.isEnabled = true
    }
    
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
        view.backgroundColor = .DnVcBackgroundColor
        optContainerView.delegate = self
        signUpBtnOutlet.layer.cornerRadius = 20.0
        signUpBtnOutlet.isEnabled = false
        steppedProgressBar.titles = ["", "", ""]
        steppedProgressBar.currentTab = 3
    }
    
    //MARK:- IBActions
        
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: Defaults.FirstLaunch.key)
        signUpBtnOutlet.isEnabled = false
        if self.inputConfirmationCode == "2211" {
            guard let data = registerData else {return}
            print("data: \(data)")
            Auth.shared.createAccount(user: data) { (success, error) in
                if success {
                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                        Auth.shared.pushHomeViewController(vc: self)
                    })
                } else {
                    Alert.asyncActionOkWith(nil, msg: "faild register, \(error!)", viewController: self)
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
