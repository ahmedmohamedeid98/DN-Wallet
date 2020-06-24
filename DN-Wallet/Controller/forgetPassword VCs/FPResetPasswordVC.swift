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
    private var dismissBtn          = SAButton(backgroundColor: .clear, title: "", systemTitle: "multiply.circle.fill")
    private var checkYourInbox      = DNTitleLabel(title: K.vc.fbCheckInbox, alignment: .center)
    private var InfoMsg             = DNTextView(text: K.vc.fbInfoMsg, alignment: .center, fontSize: 16)
    private var opt                 = OPT()
    private var EnterNewPassLabel   = DNTitleLabel(title: K.vc.fbEnterNewP, alignment: .center)
    private var NewPassword         = passwordContainer(placeholder: K.vc.fbNewPPlaceh)
    private var confirmNewPassword  = passwordContainer(placeholder: K.vc.fbConfirmP)
    private var doneBtn             = SAButton(backgroundColor: .DnColor, title: "Done")
    
    
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
        view.addSubview(checkYourInbox)
        checkYourInbox.DNLayoutConstraint(dismissBtn.bottomAnchor ,margins: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), centerH: true)
    }
    
    private func configureInfoMsgTextView() {
        view.addSubview(InfoMsg)
        InfoMsg.DNLayoutConstraint(checkYourInbox.bottomAnchor,margins: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 250, height: 60), centerH: true)
    }
    
    private func configureOPTView() {
        opt.delegate = self
        doneBtn.withTarget = {
            self.doneBtnAction()
        }
        view.addSubview(opt)
        opt.DNLayoutConstraint(InfoMsg.bottomAnchor, margins: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), size: CGSize(width: 220, height: 60), centerH: true)
    }
    
    private func configureEnterNewPassLabel() {
        EnterNewPassLabel.isHidden = true
        view.addSubview(EnterNewPassLabel)
        EnterNewPassLabel.DNLayoutConstraint(opt.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0) ,centerH: true)
    }
    
    private func configureNewPasswordContainer() {
        NewPassword.isHidden = true
        view.addSubview(NewPassword)
        NewPassword.DNLayoutConstraint(EnterNewPassLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 30))
    }
    
    private func configureConfirmPasswordContainer() {
        confirmNewPassword.isHidden = true
        view.addSubview(confirmNewPassword)
        confirmNewPassword.DNLayoutConstraint(NewPassword.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 30))
    }
    
    private func configureDoneButton() {
        doneBtn.isHidden = true
        view.addSubview(doneBtn)
        doneBtn.DNLayoutConstraint(confirmNewPassword.bottomAnchor, margins: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), size: CGSize(width: 200, height: 40), centerH: true)
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
    
    
    private func doneBtnAction() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
extension FPResetPasswordVC: GetOPTValuesProtocol {
    // this function is executed when the last textfeild fill
    func getOpt(with value: String) {
        if value == "1212" {
            EnterNewPassLabel.isHidden = false
            NewPassword.isHidden = false
            confirmNewPassword.isHidden = false
            doneBtn.isHidden = false
            opt.errorMsg.isHidden = true
        }else {
            opt.reset()
            opt.errorMsg.isHidden = false
        }
    }
}
