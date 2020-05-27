//
//  SignUpVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

@IBDesignable class SignUpVC: UIViewController {
    
     //MARK:- Outlets
    @IBOutlet weak var usernameContainer: userInput!
    @IBOutlet weak var emailContainer: userInput!
    @IBOutlet weak var passwordContainer: userInput!
    @IBOutlet weak var confirmPasswordContainer: userInput!
    @IBOutlet weak var steppedProgressBar: SteppedProgressBar!
    @IBOutlet weak var nextBtnOutlet: UIButton!
    
     //MARK:- Properities
    private var name : UITextField!
    private var email: UITextField!
    private var pass1: UITextField!
    private var pass2: UITextField!
    
     //MARK:- Init ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameContainer.configureInputField(imageName: "person",systemImage: true, placeholder: "Username", isSecure: false)
        emailContainer.configureInputField(imageName: "envelope",systemImage: true,  placeholder: "Email", isSecure: false)
        passwordContainer.configureInputField(imageName: "lock",systemImage: true, placeholder: "Password", isSecure: true)
        confirmPasswordContainer.configureInputField(imageName: "lock",systemImage: true, placeholder: "Confirm the password", isSecure: true)
        nextBtnOutlet.layer.cornerRadius = 20.0
        
        steppedProgressBar.titles = ["", "", ""]
        steppedProgressBar.currentTab = 1
        
        name = usernameContainer.textField
        email = emailContainer.textField
        pass1 = passwordContainer.textField
        pass2 = confirmPasswordContainer.textField
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
        // why not one flage not enough? beacause we not gaurenteed that user will
        // enter the inputs in sorted way
        var userValid: Bool = true
        var emailValid:Bool = true
        var pass1Valid:Bool = true
        var pass2Valid:Bool = true
        
        let wrongColor = UIColor.red.cgColor
        let validColor = UIColor.DN.LightGray.color().cgColor
        // check name validation (1 layer)
        if name.text == "" {
            usernameContainer.layer.borderColor = wrongColor
            Alert.syncActionOkWith(nil, msg: K.auth.nameIsNull, viewController: self)
            return false
        } else {
            usernameContainer.layer.borderColor = validColor
        }
        // check email validation (2 layer)
        if email.text == "" || !Auth.shared.isValidEmail(email.text!) {
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
        if !pass1Valid || pass2.text == "" || !matchedPassword(pass1.text!, pass2.text!) {
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
