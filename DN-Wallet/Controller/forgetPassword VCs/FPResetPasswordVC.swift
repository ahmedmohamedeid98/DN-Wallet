//
//  FPResetPasswordVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/11/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class FPResetPasswordVC: UIViewController {
    
    //MARK:- Properities
    private var dismissBtn          = DNButton(backgroundColor: .clear, title: "", systemTitle: "multiply.circle.fill")
    private var checkYourInbox      = DNTitleLabel(textAlignment: .center, fontSize: 28)
    private var InfoMsg             = DNTextView(text: K.vc.fbInfoMsg, alignment: .center, fontSize: 16)
    private var opt                 = OPT()
    private var EnterNewPassLabel   = DNTitleLabel(textAlignment: .center, fontSize: 18)
    private var NewPassword         = DNPasswordContainer(placeholder: K.vc.fbNewPPlaceh)
    private var confirmNewPassword  = DNPasswordContainer(placeholder: K.vc.fbConfirmP)
    private var ResetPasswordBtn    = DNButton(backgroundColor: .DnColor, title: "Reset Password")
    private lazy var resetManager: ResetManagerProtocol = ResetManager()
    var email: String?
    private var code: String?
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        configureViewController()
    }
    
    
    //MARK:- Configure Views
    private func configureDismissButton() {
        dismissBtn.withTarget = { [weak self] in
            guard let self = self  else { return }
            self.dismiss(animated: true, completion: nil)
        }
        view.addSubview(dismissBtn)
        dismissBtn.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, margins: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
    }
    
    private func configureCheckYouInboxLabel() {
        checkYourInbox.text = K.vc.fbCheckInbox
        view.addSubview(checkYourInbox)
        checkYourInbox.DNLayoutConstraint(dismissBtn.bottomAnchor ,margins: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), centerH: true)
    }
    
    private func configureInfoMsgTextView() {
        view.addSubview(InfoMsg)
        InfoMsg.DNLayoutConstraint(checkYourInbox.bottomAnchor,margins: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 250, height: 60), centerH: true)
    }
    
    private func configureOPTView() {
        opt.delegate = self
        ResetPasswordBtn.withTarget = {
            self.resetPasswordBtnAction()
        }
        view.addSubview(opt)
        opt.DNLayoutConstraint(InfoMsg.bottomAnchor, margins: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), size: CGSize(width: 220, height: 60), centerH: true)
    }
    
    private func configureEnterNewPassLabel() {
        EnterNewPassLabel.isHidden  = true
        EnterNewPassLabel.text      = K.vc.fbEnterNewP
        view.addSubview(EnterNewPassLabel)
        EnterNewPassLabel.DNLayoutConstraint(opt.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0) ,centerH: true)
    }
    
    private func configureNewPasswordContainer() {
        NewPassword.isHidden = true
        view.addSubview(NewPassword)
        NewPassword.DNLayoutConstraint(EnterNewPassLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 50))
    }
    
    private func configureConfirmPasswordContainer() {
        confirmNewPassword.isHidden = true
        view.addSubview(confirmNewPassword)
        confirmNewPassword.DNLayoutConstraint(NewPassword.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 50))
    }
    
    private func configureDoneButton() {
        ResetPasswordBtn.isHidden = true
        ResetPasswordBtn.layer.cornerRadius = 20.0
        view.addSubview(ResetPasswordBtn)
        ResetPasswordBtn.DNLayoutConstraint(confirmNewPassword.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 30, left: 40, bottom: 0, right: 40), size: CGSize(width: 0, height: 40), centerH: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .DnVcBackgroundColor
        configureDismissButton()
        configureCheckYouInboxLabel()
        configureInfoMsgTextView()
        configureOPTView()
        configureEnterNewPassLabel()
        configureNewPasswordContainer()
        configureConfirmPasswordContainer()
        configureDoneButton()
    }
    
}

 //MARK:- Networking
extension FPResetPasswordVC: GetOPTValuesProtocol {
    // this function is executed when the last textfeild fill
    func getOpt(with value: String) {
        Hud.showLoadingHud(onView: view, withLabel: "Validate...")
        resetManager.forgetPasswordCheck(email: email!, code: value) { (result) in
            Hud.hide(after: 0.0)
            switch result {
                case .success(_):
                    self.handelCheckCodeSuccessCase(code: value)
                case .failure(_):
                    self.handelChechCodeFailureCase()
            }
        }
    }
    
    private func handelCheckCodeSuccessCase(code: String) {
        self.code = code
        DispatchQueue.main.async {
            self.EnterNewPassLabel.isHidden = false
            self.NewPassword.isHidden = false
            self.confirmNewPassword.isHidden = false
            self.ResetPasswordBtn.isHidden = false
            self.opt.errorMsg.isHidden = true
        }
    }
    
    private func handelChechCodeFailureCase() {
        DispatchQueue.main.async {
            self.opt.reset()
            self.opt.errorMsg.isHidden = false
        }
    }
    
    private func resetPasswordBtnAction() {
        // check if password failed are filled
        guard let password = NewPassword.textField.text, let passwordConfirm = confirmNewPassword.textField.text else {
            self.presentDNAlertOnTheMainThread(title: K.alert.faild, Message: ErrorMessage.passwordRequired)
            return
        }
        // check maching
        if password != passwordConfirm {
            self.presentDNAlertOnTheMainThread(title: K.alert.faild, Message: ErrorMessage.passwordRequired)
            return
        }
        
        // cast email and code
        if let _email = email, let _code = code {
            Hud.showLoadingHud(onView: view, withLabel: "Change Password...")
            resetManager.resetPassword(newPassword: password, code: _code, email: _email) { (result) in
                Hud.hide(after: 0.0)
                switch result {
                    case .success(_):
                        self.handelResetPasswordSuccessCase()
                    case .failure(let err):
                        self.presentDNAlertOnTheMainThread(title: K.alert.faild, Message: err.localizedDescription)
                }
            }
        }
    }
    
    private func handelResetPasswordSuccessCase() {
        DispatchQueue.main.async {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
