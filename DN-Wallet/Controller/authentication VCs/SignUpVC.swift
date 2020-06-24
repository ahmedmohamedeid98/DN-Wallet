//
//  SignUpVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

final class SignUpVC: UIViewController {
    
    //MARK:- Properities
    @IBOutlet weak var usernameContainer: userInput!
    @IBOutlet weak var emailContainer: userInput!
    @IBOutlet weak var passwordContainer: userInput!
    @IBOutlet weak var confirmPasswordContainer: userInput!
    @IBOutlet weak var createAccountOutlet: UIButton!
    private var name : UITextField!
    private var email: UITextField!
    private var pass1: UITextField!
    private var pass2: UITextField!
    
    
    
     //MARK:- Init ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .DnVcBackgroundColor
        usernameContainer.configureInputField(imageName: "person",systemImage: true, placeholder: "Username", isSecure: false)
        emailContainer.configureInputField(imageName: "envelope",systemImage: true,  placeholder: "Email", isSecure: false)
        passwordContainer.configureInputField(imageName: "lock",systemImage: true, placeholder: "Password", isSecure: true)
        confirmPasswordContainer.configureInputField(imageName: "lock",systemImage: true, placeholder: "Confirm the password", isSecure: true)
        createAccountOutlet.layer.cornerRadius = 20.0
    
        name = usernameContainer.textField
        email = emailContainer.textField
        pass1 = passwordContainer.textField
        pass2 = confirmPasswordContainer.textField
    }
    

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        if isValid() {
            let username = usernameContainer.textField.text!
            let email = emailContainer.textField.text!
            let password = passwordContainer.textField.text!
            let user = User(username: username, email: email, password: password)
            AuthManager.shared.createAccount(user: user, onView: view) { (success, error) in
                if success {
                    AuthManager.shared.pushHomeViewController(vc: self)
                }
            }
        }
    }
    @IBAction func showTermAndServices(_ sender: UIButton) {
        
    }
    
}

extension SignUpVC {
    
    func isValid() -> Bool{

        let wrongColor = UIColor.red.cgColor
        let validColor = UIColor.DnGrayColor.cgColor
        // check name validation (1 layer)
        if name.text == "" {
            usernameContainer.layer.borderColor = wrongColor
            Alert.syncActionOkWith(nil, msg: K.auth.nameIsNull, viewController: self)
            return false
        } else {
            usernameContainer.layer.borderColor = validColor
        }
        // check email validation (2 layer)
        if email.text == "" || !AuthManager.shared.isValidEmail(email.text!) {
            emailContainer.layer.borderColor = wrongColor
            Alert.syncActionOkWith(nil, msg: K.auth.emailNotvalid, viewController: self)
            return false
        }else {
            emailContainer.layer.borderColor = validColor
        }
        // check password validation (3 layer)
        if pass1.text == "" || pass1.text!.count < 8 {
            passwordContainer.layer.borderColor = wrongColor
            Alert.syncActionOkWith(nil, msg: K.auth.passwordNotValid, viewController: self)
            return false
        } else {
            passwordContainer.layer.borderColor = validColor
        }
        if pass2.text == "" || !matchedPassword(pass1.text!, pass2.text!) {
            confirmPasswordContainer.layer.borderColor = wrongColor
            Alert.syncActionOkWith(nil, msg: K.auth.passwordNotMatch, viewController: self)
            return false
        }else {
            confirmPasswordContainer.layer.borderColor = validColor
        }
        
        return true//userValid && emailValid && pass1Valid && pass2Valid
    }
    
    func matchedPassword(_ passW1: String, _ passW2: String) -> Bool {
        return passW1 == passW2
    }
}
