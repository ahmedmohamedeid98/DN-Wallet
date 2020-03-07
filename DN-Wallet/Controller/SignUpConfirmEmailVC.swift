//
//  SignUpConfirmEmailVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SignUpConfirmEmailVC: UIViewController {

    @IBOutlet weak var signUpBtnOutlet: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtnOutlet.layer.cornerRadius = 25.0
        
    }
    

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
    }
    
}
