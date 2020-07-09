//
//  SendAndRequestMoney.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/11/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit
// note that this viewController will present by four ViewControllers
// 1- sendMoney option in service viewController
// 2- requestMoney option in service viewController
// 3- donation viewController when user want to donate to a charity
// 4- MyContacts viewController
class SendAndRequestMoney: UIViewController {
    
    //MARK:- Setup Properities
    //segment 0 stand for "send", segment 1 stand for "request"
    var currentSegment: Int = 1
    // determine the current segment when we present this viewController from another viewController
    var isRequest: Bool = false
    // true if this viewController presented by Donation VC
    var presentFromDonationVC: Bool = false
    // true if this viewController presented by Contact VC
    var presentedFromMyContact: Bool = false
    // if this view Controller present by DonationVC or MyContactVC  these VCs will send an email of person or charity
    var presentedEmail: String = "skjdklsd@ci.go.io"
    // if this is the first time user start to edit the textView then remove 'placeholder'
    var messageTextViewFirstEditing: Bool = true
    // this properity just for prevent call this method everytime the email textField Change delegate function "textFieldDidChangeSelection"
    // and this delegate function call another function
    var startCheckForAnyChange: Bool = false
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var addContactBtnOutlet: UIButton!
    @IBOutlet weak var dropDown: UITextField!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .DnVcBackgroundColor
        //presentFromDonationVC = true
        initViewController()
    }
    
    private func setUserPreference() {
        if let currency = UserPreference.getStringValue(withKey: UserPreference.currencyKey) {
            dropDown.text = currency
        }
    }
    
    fileprivate func initViewController() {
        setupNavBar()
        // setup segment controller to determine which service should use send or request money
        setupSegmentController()
        configureMessageTextView()
        dropDown.delegate = self
        dropDown.doNotShowTheKeyboard()
        
        // determine the title of viewController be a "send money" or being a "request money"
        toggleRequestSend(isRequest: isRequest)
        if presentFromDonationVC || presentedFromMyContact {
            if presentFromDonationVC { segmentController.setEnabled(false, forSegmentAt: 1) } // disable request segment
            addContactBtnOutlet.isHidden = true
            emailTextField.text = presentedEmail
            emailTextField.isUserInteractionEnabled = false // don't allow to user to edit organization email
        } else {
            // use this delegate to determine if should enable addEmailToContact button or not
            print("delegate done")
            emailTextField.delegate = self
            messageTextView.delegate = self
        }
        
    }
    
    // make status bar component white on dark background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureMessageTextView() {
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.cornerRadius = 8.0
        messageTextView.textColor = .lightGray
        messageTextView.text = "Optional. write short message..."
    }
    
    func setupNavBar() {
        self.configureNavigationBar(title: K.vc.sORrTitle)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done , target: self, action: #selector(sendMonyOrRequest))
        if !presentFromDonationVC && !presentedFromMyContact {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: K.sysImage.leftArrow), style: .plain, target: self, action: #selector(dismissBtnWasPressed))
        }
        
    }
    
    func setupSegmentController() {
        isRequest ? (segmentController.selectedSegmentIndex = 1) : (segmentController.selectedSegmentIndex = 0)
        segmentController.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        segmentController.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentController.selectedSegmentTintColor = .DnColor
    }
    
    
    func toggleRequestSend(isRequest: Bool) {
        if isRequest {
            navigationItem.title = K.vc.sORrRequestMoneyTitle
        } else {
            presentFromDonationVC ? (navigationItem.title = K.vc.donateDetailtsTitle) : (navigationItem.title = K.vc.sORrSendMoneyTitle)
        }
        self.isRequest = isRequest
    }
    
    //MARK:- Objc function
    
    /// selector action: this method called when selected segment being changed
    @IBAction func segmentControllerValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0: toggleRequestSend(isRequest: false)
            case 1: toggleRequestSend(isRequest: true)
            default: break
        }
    }
    
    @objc func dismissBtnWasPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    // the important function which responsible to deal with the api
    @objc private func sendMonyOrRequest() {
        if  isValidInputs() {
            // start indicator loading...
            if isRequest {
                // request money
                // end indicator loading...
            } else {
                // send money
                // end indicator loading...
            }
        } else {
            Alert.asyncActionOkWith(nil, msg: "missing input, try again", viewController: self)
        }
    }
    // check if all the faild is filled and if the email is valid
    private func isValidInputs() -> Bool {
        return emailTextField.text != "" && emailTextField.text!.isValidEmail && amountTextField.text != "" && dropDown.text != ""
    }
    
    // pop down keyboard when tap anyplace in the view
    @objc func hideKeyboard() {
        messageTextView.resignFirstResponder()
    }
    
    // add email to my contacts (also deak with api)
    @IBAction func addEmailToMyContacts(_ sender: UIButton) {
        if emailTextField.text != "" && emailTextField.text!.isValidEmail {
            // if email is already exist in the user contact list >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> need to edit in future
            if ["ahmed@gmail.com"].contains(emailTextField.text!) {
                self.syncDismissableAlert(title: K.vc.myContactAlertEmailExist, Message: K.vc.myContactAlertEmailExistMsg)
                self.toggleAddContactButton(toDone: true)
            }
                // if the email don't exist then add it and toggle addButton to done
            else {
                let alert = UIAlertController(title: K.vc.sORrAlertAddUsTitle, message: K.vc.sORrAlertAddUsMsg, preferredStyle: .alert)
                let add = UIAlertAction(title: K.alert.add, style: .default) { (action) in
                    // >>>>>>>>> Call Api to add >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> need to edit in future
                    self.toggleAddContactButton(toDone: true)
                    
                }
                let cancel = UIAlertAction(title: K.alert.cancel, style: .cancel, handler: nil)
                alert.addTextField { (txt) in
                    txt.placeholder = "\(self.emailTextField.text!.split(separator: "@")[0])"
                    txt.basicConfigure()
                }
                alert.addAction(cancel)
                alert.addAction(add)
                present(alert, animated: true, completion: nil)
            }
            
            
            emailTextField.endEditing(true)
        } else {
            self.syncDismissableAlert(title: K.vc.sORrAlertInvalidEmail, Message: K.vc.sORrAlertInvalidEmailMsg)
        }
    }
    /// change button image from addPerson to rightCheckMark and disable/enable it.
    func toggleAddContactButton(toDone: Bool) {
        if toDone {
            self.addContactBtnOutlet.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            self.addContactBtnOutlet.isUserInteractionEnabled = false
            emailTextField.endEditing(true)
            startCheckForAnyChange = true
        }else {
            self.addContactBtnOutlet.setImage(UIImage(systemName: "person.crop.circle.fill.badge.plus"), for: .normal)
            self.addContactBtnOutlet.isUserInteractionEnabled = true
            startCheckForAnyChange = false
        }
        
    }
    
}

extension SendAndRequestMoney: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextViewFirstEditing {
            textView.text = ""
            textView.textColor = .DnTextColor
            messageTextViewFirstEditing = false
        }
    }
}
extension SendAndRequestMoney: UITextFieldDelegate, PopUpMenuDelegate{
    func selectedItem(title: String, code: String?) {
        dropDown.text = title + "\t\t(\(code ?? " "))"
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if textField.text != "" && textField.text!.isValidEmail {
                UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
                    DispatchQueue.main.async {
                        self.addContactBtnOutlet.isHidden = false
                        // and if email not exist toggle to add image
                    }
                })
            }else {
                if !self.addContactBtnOutlet.isHidden {
                    UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                        DispatchQueue.main.async {
                            self.addContactBtnOutlet.isHidden = true
                        }
                    })
                }
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dropDown {
            let vc = PopUpMenu()
            vc.menuDelegate = self
            vc.dataSource = .currency
            self.present(vc, animated: true, completion: nil)
            textField.endEditing(true)
        }
        
    }
}

