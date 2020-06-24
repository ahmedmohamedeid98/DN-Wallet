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
    var currentPassword     = passwordContainer(placeholder: "Enter Your Current Password")
    var newPassword         = passwordContainer(placeholder: "New Password")
    var confirmNewPassword  = passwordContainer(placeholder: "Confirm New Password")
    var EnterBtn            = SAButton(backgroundColor: .DnColor, title: "Enter", cornerRedii: 8.0)
    var rightBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        confirmNewPassword.textField.delegate = self
        rightBarBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneBtnPressed))
        rightBarBtn.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarBtn
        configureEnterButton()
        setupLayout()
        setupIndicatorView()
    }
    
    private func configureEnterButton() {
        EnterBtn.withTarget = { self.EnterBtnPressed() }
        EnterBtn.DNLayoutConstraint(size: CGSize(width: 60, height: 0))
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
        
        Hstack.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 40, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 30))
        
        
        Vstack = UIStackView(arrangedSubviews: [newPassword, confirmNewPassword])
        Vstack.configureStack(axis: .vertical, distribution: .fillEqually, alignment: .fill, space: 10)
        Vstack.isHidden = true

        view.addSubview(Vstack)
        Vstack.DNLayoutConstraint(Hstack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 40, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 90))
        
        
        
    }
    
    @objc func EnterBtnPressed() {
        if let currentPass = currentPassword.textField.text {
            if AuthManager.shared.validateCurrentPassword(currentPassword: currentPass) {
                Vstack.isHidden = false
            } else {
                AuthManager.shared.buildAndPresentAlertWith("Invalid", message: "Invalid Password, Try Again.", viewController: self)
            }
        } else {
            AuthManager.shared.buildAndPresentAlertWith("Invalid", message: "Please Enter your password.", viewController: self)
        }
        
    }
    
    @objc func DoneBtnPressed() {
        if let newPass = newPassword.textField.text, let confirmPass = confirmNewPassword.textField.text, newPass == confirmPass {
            rightBarBtn.isEnabled = false
            newPassword.textField.resignFirstResponder()
            confirmNewPassword.textField.resignFirstResponder()
            activityIndicatorView.startAnimating()
            AuthManager.shared.updateCurrentPassword(newPassword: newPass) { (success, error) in
                if success {
                    self.activityIndicatorView.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }else {
                    self.activityIndicatorView.stopAnimating()
                    AuthManager.shared.buildAndPresentAlertWith("Faild Update", message: "Faild Updating your password, please try again in another time.", viewController: self)
                }
            }
        } else {
            AuthManager.shared.buildAndPresentAlertWith("Invalid", message: "not mached password, Try Again.", viewController: self)
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
