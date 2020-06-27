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
    private var generatedCode: String?
    @IBOutlet weak var resendConfirmationCodeOutlet: UIButton!
    @IBOutlet weak var optContainerView: OPT!
    @IBOutlet weak var infoLabelOne: UILabel!
    @IBOutlet weak var infoLabelTwo: UILabel!
    


    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        optContainerView.delegate = self
        resendConfirmationCodeOutlet.layer.cornerRadius = 20
        hideSuccessMessage()
    }
    
    func hideSuccessMessage(hide: Bool = true) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.infoLabelOne.isHidden = hide
                self.infoLabelTwo.isHidden = hide
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendConfirmationCode()
    }
    
    //MARK:- Methods
    // send Confirmation Code
    private func sendConfirmationCode() {
        generatedCode  = AuthManager.shared.generateConfirmationCode()
        guard let mail = AuthManager.shared.getUserEmail(), let code = generatedCode else {
            return
        }
        print("userEmail: \(mail)")
        print("userCode : \(code)")
        
        Hud.showLoadingHud(onView: view, withLabel: "Sending...")
        NetworkManager.confirmEmail(email: mail, code: code) { (result) in
            switch result {
                case .success(_):
                    self.handleSendConfirmationCodeSuccessCase()
                case .failure(let err):
                    self.handleSendConfirmationCodeFailureCase(withError: err.rawValue)
            }
        }
        
    }
    
    private func handleSendConfirmationCodeSuccessCase() {
        Hud.hide(after: 0.0)
        hideSuccessMessage(hide: false)
    }
    
    private func handleSendConfirmationCodeFailureCase(withError error: String) {
        Hud.faildAndHide(withMessage: error)
        hideSuccessMessage()
    }
    
    
    // back to login page
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // ask api to resent confirmation code
    @IBAction func resendConfirmationCode(_ sender: UIButton) {
        wrongTrying = 0
        resendConfirmationCodeOutlet.isHidden = true
        hideSuccessMessage()
        sendConfirmationCode()
    }
    
}

//MARK:- Configure Confirmation Code
extension ConfirmEmailVC: GetOPTValuesProtocol {
    func getOpt(with value: String) {
        guard let code = generatedCode else {
            invalidCodeTryAgain()
            return
        }
        if value == code {
            updateProfileToBeVerified()
        } else {
            invalidCodeTryAgain()
        }
    }
    
    
    
    private func updateProfileToBeVerified() {
        Hud.showLoadingHud(onView: view, withLabel: "Validate...")
        NetworkManager.editAccount(withObject: ["userIsValidate": true]) { (result) in
            switch result {
                case .success(_):
                    Hud.successAndHide(withMessage: DNSuccessMessage.accountValidate.rawValue)
                    DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
                case .failure(let err):
                    Hud.faildAndHide(withMessage: err.rawValue)
            }
        }
    }
    
    private func invalidCodeTryAgain() {
        optContainerView.reset()
        optContainerView.errorMsg.isHidden = false
        wrongTrying += 1
        if wrongTrying > 2 {
            resendConfirmationCodeOutlet.isHidden = false
        }
    }
}
