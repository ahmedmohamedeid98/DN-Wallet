//
//  SignUpVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

@IBDesignable class SignUpVC: UIViewController {

    
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
        let st = UIStoryboard(name: "Authentication", bundle: .main)
        let vc = st.instantiateViewController(identifier: "SignUpPhoneVCID") as? SignUpPhoneVC
        
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)
    }
}
