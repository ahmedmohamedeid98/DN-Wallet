//
//  FPResetPasswordVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/11/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class FPResetPasswordVC: UIViewController {
    
    
    private var checkYourInbox: UILabel = {
           let lb = UILabel()
        lb.text = K.vc.fbCheckInbox
           lb.textAlignment = .center
        lb.textColor = .DnColor
           lb.font = UIFont.DN.SemiBlod.font(size: 18)
           return lb
       }()
    private var InfoMsg: UITextView = {
        let Msg = UITextView()
        Msg.textAlignment = .center
        Msg.text = K.vc.fbInfoMsg
        Msg.isEditable = false
        Msg.textColor = .DnColor
        Msg.backgroundColor = .clear
        Msg.font = UIFont.DN.Regular.font(size: 16)
        return Msg
    }()
    
    private var opt: OPT!
    
    private var EnterNewPassLabel: UILabel = {
        let lb = UILabel()
        lb.text = K.vc.fbEnterNewP
        lb.textAlignment = .center
        lb.textColor = .DnColor
        lb.font = UIFont.DN.SemiBlod.font(size: 18)
        return lb
    }()
    private var NewPassword : passwordContainer!
    private var confirmNewPassword : passwordContainer!
    
    
    private var doneBtn = SAButton(backgroundColor: .DnColor, title: "Done")
    private var dismissBtn = SAButton(backgroundColor: .clear, title: "", systemTitle: "multiply.circle.fill")
    
    fileprivate func setupLayout() {
        view.addSubview(dismissBtn)
        view.addSubview(checkYourInbox)
        view.addSubview(InfoMsg)
        view.addSubview(opt)
        view.addSubview(EnterNewPassLabel)
        view.addSubview(NewPassword)
        view.addSubview(confirmNewPassword)
        view.addSubview(doneBtn)
        dismissBtn.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, margins: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
        dismissBtn.setCornerRadiusWithHeight = 0
        checkYourInbox.DNLayoutConstraint(dismissBtn.bottomAnchor ,margins: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), centerH: true)
        InfoMsg.DNLayoutConstraint(checkYourInbox.bottomAnchor,margins: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 250, height: 60), centerH: true)
        opt.DNLayoutConstraint(InfoMsg.bottomAnchor, margins: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), size: CGSize(width: 220, height: 60), centerH: true)
        EnterNewPassLabel.DNLayoutConstraint(opt.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0) ,centerH: true)
        NewPassword.DNLayoutConstraint(EnterNewPassLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 30))
        confirmNewPassword.DNLayoutConstraint(NewPassword.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 30))
        doneBtn.DNLayoutConstraint(confirmNewPassword.bottomAnchor, margins: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), size: CGSize(width: 200, height: 40), centerH: true)
    }
    
    fileprivate func commonInit(){
        view.backgroundColor = .DnVcBackgroundColor
        opt = OPT()
        opt.delegate = self
        
        NewPassword = passwordContainer()
        NewPassword.configureTxtFeild(placeholder: K.vc.fbNewPPlaceh)
        confirmNewPassword = passwordContainer()
        confirmNewPassword.configureTxtFeild(placeholder: K.vc.fbConfirmP)
        doneBtn.withTarget = {
            self.doneBtnAction()
        }
        dismissBtn.withTarget = { [weak self] in
            guard let self = self  else { return }
            self.dismiss(animated: true, completion: nil)
        }
        EnterNewPassLabel.isHidden = true
        NewPassword.isHidden = true
        confirmNewPassword.isHidden = true
        doneBtn.isHidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        commonInit()
        setupLayout()
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
