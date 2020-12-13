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
    var currentPassword     = DNPasswordContainer(placeholder: "Enter Your Current Password")
    var newPassword         = DNPasswordContainer(placeholder: "New Password")
    var confirmNewPassword  = DNPasswordContainer(placeholder: "Confirm New Password")
    var EnterBtn            = DNButton(backgroundColor: .DnColor, title: "Enter", cornerRedii: 4.0)
    var rightBarBtn: UIBarButtonItem!
    private lazy var resetManager: ResetManagerProtocol = ResetManager()
    private lazy var auth: UserAuthProtocol = UserAuth()
    private var oldPassword: String?
    
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
    
    //handle status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    private func configureEnterButton() {
        EnterBtn.withTarget = { self.EnterBtnPressed() }
        EnterBtn.DNLayoutConstraint(size: CGSize(width: 70, height: 0))
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
        
        Hstack.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 40, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 50))
        
        
        Vstack = UIStackView(arrangedSubviews: [newPassword, confirmNewPassword])
        Vstack.configureStack(axis: .vertical, distribution: .fillEqually, alignment: .fill, space: 10)
        Vstack.isHidden = true

        view.addSubview(Vstack)
        Vstack.DNLayoutConstraint(Hstack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 40, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 110))
        
        
        
    }
    
    @objc func EnterBtnPressed() {
        guard let currentPass = currentPassword.textField.text else { return }
        self.oldPassword = currentPass
        if auth.validate(currentPassword: currentPass) {
            UIView.animate(withDuration: 0.5) {
                self.Vstack.isHidden = false
                self.rightBarBtn.isEnabled = true
            }
        }
    }
    
    @objc func DoneBtnPressed() {
        if let newPass = newPassword.textField.text, let confirmPass = confirmNewPassword.textField.text, newPass == confirmPass {
            rightBarBtn.isEnabled = false
            newPassword.textField.resignFirstResponder()
            confirmNewPassword.textField.resignFirstResponder()
            activityIndicatorView.startAnimating()
            resetManager.updatePassword(oldPassword: oldPassword!, newPassword: newPass) { (result) in
                DispatchQueue.main.async { self.activityIndicatorView.stopAnimating() }
                switch result {
                    case .success(let res):
                        self.presentDNAlertOnTheMainThread(title: "Success", Message: res.success)
                    case .failure(let err):
                        self.presentDNAlertOnTheMainThread(title: "Failure", Message: err.localizedDescription)
                }
            }
        }
        else {
            self.presentDNAlertOnTheMainThread(title: "Invalid", Message: "not mached password, Try Again.")
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
