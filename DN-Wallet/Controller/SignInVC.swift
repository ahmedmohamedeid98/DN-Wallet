//
//  SignInVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit
@IBDesignable
class SignInVC: UIViewController {

    @IBOutlet weak var emailContainerView: userInput!
    @IBOutlet weak var passwordContainerView: userInput!
    @IBOutlet weak var signInOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailContainerView.configureInputField(imageName: "mail", placeholder: "Email", isSecure: false)
        passwordContainerView.configureInputField(imageName: "password", placeholder: "Password", isSecure: true)
    }
    

    @IBAction func haveNoAccountPressed(_ sender: Any) {
        let st = UIStoryboard(name: "Authentication", bundle: .main)
        let vc = st.instantiateViewController(identifier: "signUpVCID") as? SignUpVC
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)
    }
    
    @IBAction func forgetPasswordPressed(_ sender: Any) {
        
    }
    @IBAction func signInBtnPressed(_ sender: Any) {
        
    }
    
}
