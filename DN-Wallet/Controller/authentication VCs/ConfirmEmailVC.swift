//
//  SignUpConfirmEmailVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class ConfirmEmailVC: UIViewController {
    
    //MARK:- Properities
    var wrongTrying: Int = 0
    @IBOutlet weak var resendConfirmationCodeOutlet: UIButton!
    @IBOutlet weak var optContainerView: OPT!
    
    
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        optContainerView.delegate = self
    }
    
    
    
    //MARK:- Methods
    // back to login page
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // ask api to resent confirmation code
    @IBAction func resendConfirmationCode(_ sender: UIButton) {
        wrongTrying = 0
        resendConfirmationCodeOutlet.isHidden = true
        Hud.successAndHide(withMessage: "Confirmation Code Send Successfully.")
    }
    
}

//MARK:- Configure Confirmation Code
extension ConfirmEmailVC: GetOPTValuesProtocol {
    func getOpt(with value: String) {
        if value == "2211" {
            self.dismiss(animated: true, completion: nil)
            // update profile to be verified
        } else {
            optContainerView.reset()
            optContainerView.errorMsg.isHidden = false
            wrongTrying += 1
            if wrongTrying > 2 {
                resendConfirmationCodeOutlet.isHidden = false
            }
        }
    }
}
