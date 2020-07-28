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
    private lazy var verifyManager: VerifyManagerProtocol = VerifyManager()


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
        self.sendVerificationCodeToEmail()
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
        hideSuccessMessage()
        self.sendVerificationCodeToEmail()
    }
    
}

//MARK:- Configure Confirmation Code
extension ConfirmEmailVC: GetOPTValuesProtocol {
    
    // SEND VERIFICATION CODE
    private func sendVerificationCodeToEmail() {
        Hud.showLoadingHud(onView: view, withLabel: "Sending Code...")
        verifyManager.sendEmailVerifiCode { (result) in
            Hud.hide(after: 0)
            switch result {
                case .success(_):
                    self.hideSuccessMessage(hide: false)
                case .failure(let error):
                    self.presentDNAlertOnTheMainThread(title: "Failure", Message: error.localizedDescription)
            }
        }
    }
    
    // CHECK ENTERED CODE
    func getOpt(with value: String) {
        Hud.showLoadingHud(onView: view, withLabel: "Verifying...")
        verifyManager.verifyEmail(withCode: value) { (result) in
            Hud.hide(after: 0)
            switch result {
                case .success(_):
                    self.handleSendConfirmationCodeSuccessCase()
                case .failure(_):
                    self.invalidCodeTryAgain()
            }
        }
    }
    
    private func handleSendConfirmationCodeSuccessCase() {
        DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
    }
    
    private func invalidCodeTryAgain() {
        DispatchQueue.main.async {
            self.optContainerView.reset()
            self.optContainerView.errorMsg.isHidden = false
            self.wrongTrying += 1
            if self.wrongTrying > 2 {
                self.resendConfirmationCodeOutlet.isHidden = false
            }
        }
        
    }
}
