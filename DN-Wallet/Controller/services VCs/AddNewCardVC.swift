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
        cardNameTextField.doNotShowTheKeyboard()
        cardNumberTextField.delegate = self
        expireDateTextField.delegate = self
        cardNumberTextField.addTarget(self, action: #selector(cardNumberFormate), for: .editingChanged)
        expireDateTextField.addTarget(self, action: #selector(expireDateFormate), for: .editingChanged)
        cardNumberTextField.stopSmartActions()
        expireDateTextField.stopSmartActions()
        cvvTextField.stopSmartActions()
    }
    
    @objc func cardNumberFormate() {
        if previousLocation == 3 || previousLocation == 8 || previousLocation == 13 {
            cardNumberTextField.text = "\(previousTextFieldContent)\(nextTextFieldContent) "
        }
        if previousLocation == 18 {
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
        
        let card = createCard()
        Hud.showLoadingHud(onView: view, withLabel: "Adding...")
        TransferManager.shared.addPaymentCard(withData: card) { result in
            Hud.hide(after: 0)
            switch result {
                case .success(let res):
                    self.handelAddPaymentCardSuccessCase(message: res.success)
                case .failure(let err):
                    self.handelAddPaymentCardFailureCase(withError: err.localizedDescription)
            }
        }
    }
    
    private func handelAddPaymentCardSuccessCase(message: String) {
        self.presentDNAlertOnTheMainThread(title: "Success", Message: message)
    }
    
    private func handelAddPaymentCardFailureCase(withError err: String) {
        self.presentDNAlertOnTheMainThread(title: K.alert.faild, Message: err)
    }
    
    private func createCard() -> PostPaymentCard {
        let expireDate  = expireDateTextField.text ?? "02 / 22"
        let parts       = expireDate.split(separator: "/")
        let expM        = String(parts[0]).replacingOccurrences(of: " ", with: "")
        let expY        = "20\(String(parts[1]))".replacingOccurrences(of: " ", with: "")
        let cardType    = cardNameTextField.text ?? ""
        let cvc         = cvvTextField.text ?? ""
        let cardNumber  = cardNumberTextField.text ?? ""
        return PostPaymentCard(cardType: cardType.lowercased() , cardNumber: cardNumber.replacingOccurrences(of: " ", with: ""), cvc: cvc, expYear: expY, expMonth: expM)
    }
}


extension AddNewCardVC: UITextFieldDelegate, PopUpMenuDelegate {
    
    func selectedItem(title: String, code: String?) {
        cardNameTextField.text = "\(title)"
        cardNameTextField.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField == cardNameTextField {
            self.presentPopUpMenu(withCategory: .creditCard, to: self)
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
