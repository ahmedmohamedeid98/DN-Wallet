//
//  FPEnterEmailVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/11/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class FPEnterEmailVC: UIViewController {
    
    //MARK:- Properities
    private var forgetPasswordMsg   = DNTitleLabel(title: K.vc.fbMsg, alignment: .center)
    private var EnterEmailMsg       = DNTextView(text: K.vc.fbEnterMailMsg, alignment: .center, fontSize: 16)
    private var emailField          = DNTextField(placeholder: K.vc.fbEnterMailPlaceh, stopSmartActions: true)
    private var sendResetCodeBtn    = DNButton(backgroundColor: .DnColor, title: "Send Reset Code", cornerRedii: 20.0)
    private var emailContainerView  = DNEmptyContainer(borderWidth: 2, borderColor: .systemGray4, backgroundColor: .DnCellColor, cornerRedii: 4)
    private lazy var resetManager: ResetManagerProtocol = ResetManager()
        
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sendResetCodeBtn.isEnabled = true
    }
    

    //MARK:- Configure Views
    private func configureViewController() {
        configureForgetPasswordMsg()
        configureEnterEmailMsg()
        configureEmailContainerView()
        configureEmailField()
        configureSendResetCodeButton()
    }
    
    private func configureForgetPasswordMsg() {
        view.addSubview(forgetPasswordMsg)
        forgetPasswordMsg.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, margins: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0), centerH: true)
    }
    private func configureEnterEmailMsg() {
        view.addSubview(EnterEmailMsg)
        EnterEmailMsg.DNLayoutConstraint(forgetPasswordMsg.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 10, left: 40, bottom: 0, right: 40), size: CGSize(width: 0, height: 60))
    }
    private func configureEmailContainerView() {
        view.addSubview(emailContainerView)
        emailContainerView.DNLayoutConstraint(EnterEmailMsg.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 40, left: 40, bottom: 0, right: 40), size: CGSize(width: 0, height: 40))
    }
    private func configureEmailField() {
        emailField.keyboardType = .emailAddress
        emailContainerView.addSubview(emailField)
        emailField.DNLayoutConstraint(emailContainerView.topAnchor, left: emailContainerView.leftAnchor, right: emailContainerView.rightAnchor, bottom: emailContainerView.bottomAnchor, margins: UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 4))
        
    }
    private func configureSendResetCodeButton() {
        sendResetCodeBtn.withTarget = { self.sendResetCode()  }
        view.addSubview(sendResetCodeBtn)
        sendResetCodeBtn.DNLayoutConstraint(emailField.bottomAnchor, margins: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0), size: CGSize(width: 250, height: 40), centerH: true)
    }
}

//Networking

extension FPEnterEmailVC {
    private func sendResetCode() {
        if let email = emailField.text, email.isValidEmail {
            Hud.showLoadingHud(onView: view)
            sendResetCodeBtn.isEnabled = false
            resetManager.forgetPassword(forEmail: email) { (result) in
                Hud.hide(after: 0.0)
                switch result {
                    case .success(_):
                        self.handleSendingCodeSuccessCase(email: email)
                    case .failure(let err):
                        self.handleSuccessCodeFailureCase(error: err.localizedDescription)
                }
            }
            
        } else {
            self.asyncDismissableAlert(title: "invalid email", Message: "Please enter a valid email.")
        }
        
    }
    
    private func handleSendingCodeSuccessCase(email: String) {
        DispatchQueue.main.async {
            let forgetPassVC = FPResetPasswordVC()
            forgetPassVC.email = email
            self.present(forgetPassVC, animated: true, completion: nil)
        }
    }
    
    private func handleSuccessCodeFailureCase(error: String) {
        self.asyncDismissableAlert(title: "Failure", Message: error)
        DispatchQueue.main.async {
            self.sendResetCodeBtn.setTitle("Resend Reset Code.", for: .normal)
            self.sendResetCodeBtn.isEnabled = true
        }
    }
}
