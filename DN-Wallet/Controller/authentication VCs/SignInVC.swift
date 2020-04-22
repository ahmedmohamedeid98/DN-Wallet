//
//  SignInVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var emailContainerView: userInput!
    @IBOutlet weak var passwordContainerView: userInput!
    @IBOutlet weak var signInOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "haveAccount") {
            Auth.shared.loginWithBiometric(viewController: self)
        }
        signInButtonIsEnabled(false)
        signInOutlet.layer.cornerRadius = 20.0
        emailContainerView.configureInputField(imageName: "envelope", systemImage: true, placeholder: "Email", isSecure: false)
        passwordContainerView.configureInputField(imageName: "lock", systemImage: true, placeholder: "Password", isSecure: true)
        passwordContainerView.textField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailContainerView.textField.text = Auth.shared.getUserEmail()
        if UserDefaults.standard.bool(forKey: Defaults.LoginWithBiometric.key) {
            Auth.shared.loginWithBiometric(viewController: self)
        }
        
    }

    @IBAction func haveNoAccountPressed(_ sender: Any) {
        let st = UIStoryboard(name: "Authentication", bundle: .main)
        let vc = st.instantiateViewController(identifier: "signUpVCID") as? SignUpVC
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)
    }
    
    @IBAction func forgetPasswordPressed(_ sender: Any) {
        let forgetPassVC = FPEnterEmailVC()
        forgetPassVC.modalPresentationStyle = .fullScreen
        self.present(forgetPassVC, animated: true, completion: nil)
    }
    @IBAction func signInBtnPressed(_ sender: Any) {
    
        if emailContainerView.textField.text != "" && passwordContainerView.textField.text != "" {
            let email = emailContainerView.textField.text!
            let password = passwordContainerView.textField.text!
            Auth.shared.authWithUserCredential(credintial: Login(email: email, password: password)) { (success, error) in
                if success {
                    Auth.shared.pushHomeViewController(vc: self)
                } else {
                    Auth.shared.faildLoginAlert(viewController: self)
                }
            }
        }

    }
    
    func signInButtonIsEnabled(_ enable: Bool) {
        signInOutlet.isHighlighted = !enable
        signInOutlet.isEnabled = enable
    }
    
}

extension SignInVC : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let len = textField.text?.count, len >= 8 {
            signInButtonIsEnabled(true)
        }
    }
}
