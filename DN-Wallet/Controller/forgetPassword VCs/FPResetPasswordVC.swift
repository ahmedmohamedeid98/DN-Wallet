//
//  FPResetPasswordVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/11/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class FPResetPasswordVC: UIViewController, GetOPTValuesProtocol {
    
    // this function is executed when the last textfeild fill
    func getOptValues(tf1: Int, tf2: Int, tf3: Int, tf4: Int) {
        if "\(tf1)\(tf2)\(tf3)\(tf4)" == "1212" {
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
    
    
    private var checkYourInbox: UILabel = {
           let lb = UILabel()
           lb.text = "Check Your Inbox"
           lb.textAlignment = .center
           lb.textColor = UIColor.DN.DarkBlue.color()
           lb.font = UIFont.DN.SemiBlod.font(size: 18)
           return lb
       }()
    private var InfoMsg: UITextView = {
        let Msg = UITextView()
        Msg.textAlignment = .center
        Msg.text = "A 4-digits has been sent to your emailaddress"
        Msg.isEditable = false
        Msg.textColor = UIColor.DN.DarkBlue.color()
        Msg.font = UIFont.DN.Regular.font(size: 16)
        return Msg
    }()
    
    private var opt: OTP!
    
    private var EnterNewPassLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Enter New Password"
        lb.textAlignment = .center
        lb.textColor = UIColor.DN.DarkBlue.color()
        lb.font = UIFont.DN.SemiBlod.font(size: 18)
        return lb
    }()
    
    private var NewPassword : passwordContainer!
    private var confirmNewPassword : passwordContainer!
    
    
    private var doneBtn: UIButton = {
        let Btn = UIButton(type: .system)
        Btn.setTitle("Done", for: .normal)
        Btn.setTitleColor(.white, for: .normal)
        Btn.backgroundColor = UIColor.DN.DarkBlue.color()
        Btn.layer.cornerRadius = 20
        return Btn
    }()
    
    fileprivate func setupLayout() {
        view.addSubview(checkYourInbox)
        view.addSubview(InfoMsg)
        view.addSubview(opt)
        view.addSubview(EnterNewPassLabel)
        view.addSubview(NewPassword)
        view.addSubview(confirmNewPassword)
        view.addSubview(doneBtn)
        
        checkYourInbox.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor,margins: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), centerH: true)
        InfoMsg.DNLayoutConstraint(checkYourInbox.bottomAnchor,margins: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 250, height: 60), centerH: true)
        opt.DNLayoutConstraint(InfoMsg.bottomAnchor, margins: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), size: CGSize(width: 184, height: 60), centerH: true)
        EnterNewPassLabel.DNLayoutConstraint(opt.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0) ,centerH: true)
        NewPassword.DNLayoutConstraint(EnterNewPassLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 30))
        confirmNewPassword.DNLayoutConstraint(NewPassword.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 30))
        doneBtn.DNLayoutConstraint(confirmNewPassword.bottomAnchor, margins: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), size: CGSize(width: 200, height: 40), centerH: true)
    }
    
    fileprivate func commonInit(){
        view.backgroundColor = .white
        opt = OTP()
        opt.delegate = self
        
        NewPassword = passwordContainer()
        NewPassword.configureTxtFeild(placeholder: "new password")
        confirmNewPassword = passwordContainer()
        confirmNewPassword.configureTxtFeild(placeholder: "confirm password")
        doneBtn.addTarget(self, action: #selector(doneBtnAction), for: .touchUpInside)
        EnterNewPassLabel.isHidden = true
        NewPassword.isHidden = true
        confirmNewPassword.isHidden = true
        doneBtn.isHidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        setupLayout()
    }
    
    @objc func doneBtnAction() {
        //let st = UIStoryboard(name: "Authentication", bundle: .main)
        //let vc = st.instantiateViewController(identifier: "signInVCID") as? SignInVC
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
