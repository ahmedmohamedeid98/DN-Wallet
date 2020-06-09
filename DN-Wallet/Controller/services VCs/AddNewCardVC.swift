//
//  AddNewCardVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/16/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit



class AddNewCardVC: UIViewController {
    
    
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    var previousTextFieldContent: String = ""
    var nextTextFieldContent:String = ""
    var previousLocation: Int!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        setupNavBar()
        initView()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func initView() {
        cardNameTextField.delegate = self
        cardNumberTextField.delegate = self
        expireDateTextField.delegate = self
        cardNumberTextField.addTarget(self, action: #selector(cardNumberFormate), for: .editingChanged)
        expireDateTextField.addTarget(self, action: #selector(expireDateFormate), for: .editingChanged)
        cardNumberTextField.stopSmartActions()
        expireDateTextField.stopSmartActions()
        cvvTextField.stopSmartActions()
    }
    
    @objc func cardNumberFormate() {
        if previousLocation == 3 || previousLocation == 10 || previousLocation == 17 {
            cardNumberTextField.text = "\(previousTextFieldContent)\(nextTextFieldContent) - "
        }
        if previousLocation == 24 {
            expireDateTextField.becomeFirstResponder()
        }
    }
    
    @objc func expireDateFormate() {
        if previousLocation == 1 {
            expireDateTextField.text = "\(previousTextFieldContent)\(nextTextFieldContent)  /  "
        }
        if previousLocation == 8 {
            cvvTextField.becomeFirstResponder()
        }
    }
    
    func setupNavBar() {
        self.configureNavigationBar(title: K.vc.addNewCardTitle)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add , target: self, action: #selector(addPaymentCardBtnPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: K.sysImage.leftArrow), style: .plain, target: self, action: #selector(dismissBtnWasPressed))
    }
    
    @objc func dismissBtnWasPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addPaymentCardBtnPressed() {
        
        //navBar.rightBtn.isEnabled = false
        let alert = UIAlertController(title: K.alert.success, message: K.vc.addNewCardAlertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: K.alert.ok, style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}


extension AddNewCardVC: UITextFieldDelegate, PopUpMenuDelegate {
    
    func selectedItem(title: String, code: String?) {
        cardNameTextField.text = "\(title)"
        cardNameTextField.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField == cardNameTextField {
            let vc = PopUpMenu()
            vc.menuDelegate = self
            vc.dataSource = .creditCard
            present(vc, animated: true, completion: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != cardNameTextField {
            previousLocation = range.location
            previousTextFieldContent = textField.text!
            nextTextFieldContent = string
            return true
        }
        return false
    }
}
