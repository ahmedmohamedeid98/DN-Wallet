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
       
        signInOutlet.layer.cornerRadius = 20.0
        emailContainerView.configureInputField(imageName: "envelope", systemImage: true, placeholder: "Email", isSecure: false)
        passwordContainerView.configureInputField(imageName: "lock", systemImage: true, placeholder: "Password", isSecure: true)
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
        
    }
    
}
