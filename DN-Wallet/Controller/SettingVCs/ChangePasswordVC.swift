//
//  ChangePasswordVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 4/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    
    var Vstack: UIStackView!
    var activityIndicatorView: UIActivityIndicatorView!
    
    var currentPassword: passwordContainer = {
        let vw = passwordContainer()
        vw.configureTxtFeild(placeholder: "Enter Your Current Password")
        return vw
    }()
    
    
    var newPassword: passwordContainer = {
        let vw = passwordContainer()
        vw.configureTxtFeild(placeholder: "New Password")
        return vw
    }()
    
    var confirmNewPassword: passwordContainer = {
        let vw = passwordContainer()
        vw.configureTxtFeild(placeholder: "Confirm New Password")
        return vw
    }()
    
    var EnterBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.DN.DarkBlue.color()
        btn.tintColor = .white
        btn.titleLabel?.font = UIFont.DN.Regular.font(size: 14)
        btn.setTitle("Enter", for: .normal)
        btn.layer.cornerRadius = 8.0
        btn.addTarget(self, action: #selector(EnterBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    var rightBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        confirmNewPassword.textField.delegate = self
        rightBarBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneBtnPressed))
        rightBarBtn.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarBtn
        setupLayout()
        setupIndicatorView()
    }
    
    func setupIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
    }
    
    func setupLayout() {
        let Hstack = UIStackView(arrangedSubviews: [currentPassword, EnterBtn])
        Hstack.configureStack(axis: .horizontal, distribution: .fill, alignment: .fill, space: 8)
        
        view.addSubview(Hstack)
        EnterBtn.DNLayoutConstraint(size: CGSize(width: 60, height: 0))
        Hstack.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 40, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 30))
        
        
        Vstack = UIStackView(arrangedSubviews: [newPassword, confirmNewPassword])
        Vstack.configureStack(axis: .vertical, distribution: .fillEqually, alignment: .fill, space: 10)
        Vstack.isHidden = true

        view.addSubview(Vstack)
        Vstack.DNLayoutConstraint(Hstack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 40, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 90))
        
        
        
    }
    
    @objc func EnterBtnPressed() {
        if let currentPass = currentPassword.textField.text {
            if Auth.shared.validateCurrentPassword(currentPassword: currentPass) {
                Vstack.isHidden = false
            } else {
                Auth.shared.buildAndPresentAlertWith("Invalid", message: "Invalid Password, Try Again.", viewController: self)
            }
        } else {
            Auth.shared.buildAndPresentAlertWith("Invalid", message: "Please Enter your password.", viewController: self)
        }
        
    }
    
    @objc func DoneBtnPressed() {
        if let newPass = newPassword.textField.text, let confirmPass = confirmNewPassword.textField.text, newPass == confirmPass {
            rightBarBtn.isEnabled = false
            newPassword.textField.resignFirstResponder()
            confirmNewPassword.textField.resignFirstResponder()
            activityIndicatorView.startAnimating()
            Auth.shared.updateCurrentPassword(newPassword: newPass) { (success, error) in
                if success {
                    self.activityIndicatorView.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }else {
                    self.activityIndicatorView.stopAnimating()
                    Auth.shared.buildAndPresentAlertWith("Faild Update", message: "Faild Updating your password, please try again in another time.", viewController: self)
                }
            }
        } else {
            Auth.shared.buildAndPresentAlertWith("Invalid", message: "not mached password, Try Again.", viewController: self)
        }
    }
    
    
    

}

extension ChangePasswordVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let count = textField.text?.count, count >= 8 {
            self.rightBarBtn.isEnabled = true
        }
    }
}
