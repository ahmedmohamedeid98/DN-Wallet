//
//  SignUpVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

@IBDesignable class SignUpVC: UIViewController {

    var validInput: Bool = true
    @IBOutlet weak var usernameContainer: userInput!
    @IBOutlet weak var emailContainer: userInput!
    @IBOutlet weak var passwordContainer: userInput!
    @IBOutlet weak var confirmPasswordContainer: userInput!
    @IBOutlet weak var steppedProgressBar: SteppedProgressBar!
    
    @IBOutlet weak var nextBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameContainer.configureInputField(imageName: "person",systemImage: true, placeholder: "Username", isSecure: false)
        emailContainer.configureInputField(imageName: "envelope",systemImage: true,  placeholder: "Email", isSecure: false)
        passwordContainer.configureInputField(imageName: "lock",systemImage: true, placeholder: "Password", isSecure: true)
        confirmPasswordContainer.configureInputField(imageName: "lock",systemImage: true, placeholder: "Confirm the password", isSecure: true)
        nextBtnOutlet.layer.cornerRadius = 20.0
        
        steppedProgressBar.titles = ["", "", ""]
        steppedProgressBar.currentTab = 1
    }
    

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        
        
        if isValid() {
            let username = usernameContainer.textField.text!
            let email = emailContainer.textField.text!
            let password = passwordContainer.textField.text!
        
            let st = UIStoryboard(name: "Authentication", bundle: .main)
            let vc = st.instantiateViewController(identifier: "SignUpPhoneVCID") as? SignUpPhoneVC
            vc?.user = User(username: username, email: email, password: password, phone: "", country: "")
            vc?.modalPresentationStyle = .fullScreen
            present(vc!, animated: true)
        }
    }
    
}

extension SignUpVC {
    
    func isValid() -> Bool{
        
        var userValid: Bool = true
        var emailValid:Bool = true
        var pass1Valid:Bool = true
        var pass2Valid:Bool = true
        
        if usernameContainer.textField.text == "" {
            usernameContainer.layer.borderColor = UIColor.red.cgColor
            userValid = false
        } else {
            usernameContainer.layer.borderColor = UIColor.DN.LightGray.color().cgColor
        }
        
        if emailContainer.textField.text == "" || !Auth.shared.isValidEmail(emailContainer.textField.text!) {
            emailContainer.layer.borderColor = UIColor.red.cgColor
            emailValid = false
        }else {
            emailContainer.layer.borderColor = UIColor.DN.LightGray.color().cgColor
        }
        
        if passwordContainer.textField.text == "" {
            passwordContainer.layer.borderColor = UIColor.red.cgColor
            pass1Valid = false
        } else {
            passwordContainer.layer.borderColor = UIColor.DN.LightGray.color().cgColor
        }
        
        if !pass1Valid || confirmPasswordContainer.textField.text == "" || !matchedPassword(passW1: passwordContainer.textField.text!, passW2: confirmPasswordContainer.textField.text!) {
            confirmPasswordContainer.layer.borderColor = UIColor.red.cgColor
            pass2Valid = false
        }else {
            confirmPasswordContainer.layer.borderColor = UIColor.DN.LightGray.color().cgColor
        }
        
        return userValid && emailValid && pass1Valid && pass2Valid
    }
    
    func matchedPassword(passW1: String, passW2: String) -> Bool {
        return passW1 == passW2
    }
}
