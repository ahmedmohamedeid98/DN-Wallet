//
//  SignUpVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    
    @IBOutlet weak var usernameContainer: userInput!
    @IBOutlet weak var emailContainer: userInput!
    @IBOutlet weak var passwordContainer: userInput!
    @IBOutlet weak var confirmPasswordContainer: userInput!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameContainer.configureInputField(imageName: "username", placeholder: "Username", isSecure: false)
        emailContainer.configureInputField(imageName: "mail", placeholder: "Email", isSecure: false)
        passwordContainer.configureInputField(imageName: "password", placeholder: "Password", isSecure: true)
        confirmPasswordContainer.configureInputField(imageName: "password", placeholder: "Confirm the password", isSecure: true)
    }
    

    

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
    }
}
