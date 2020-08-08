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
    var charityId: String?
    // true if this viewController presented by Contact VC
    var presentedFromMyContact: Bool = false
    // if this view Controller present by DonationVC or MyContactVC  these VCs will send an email of person or charity
    var presentedEmail: String = "skjdklsd@ci.go.io"
    // if this is the first time user start to edit the textView then remove 'placeholder'
    var messageTextViewFirstEditing: Bool = true
    // this properity just for prevent call this method everytime the email textField Change delegate function "textFieldDidChangeSelection"
    // and this delegate function call another function
    var startCheckForAnyChange: Bool = false
    private lazy var myContactManager: MyContactManagerProtocol = MyContactManager()
    // this delegate handel add contact from this page to my contact list
    weak var delegate: MyContactDelegate?
    var selectedCurrencyCode: String = "EGP"
    
    @IBOutlet weak var segmentController: DNSegmentControl!
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
            if presentFromDonationVC { segmentController.disableSegmentAt(index: 1) } // disable request segment
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
        segmentController.firstSegmentTitle = "Send"
        segmentController.secondSegmentTitle = "Request"
        segmentController.delegate = self
        isRequest ? (segmentController.selectSegmentAt(index: 1)) : (segmentController.selectSegmentAt(index: 0))
    }
    
    
    func toggleRequestSend(isRequest: Bool) {
        if isRequest {
            navigationItem.title = K.vc.sORrRequestMoneyTitle
        } else {
            presentFromDonationVC ? (navigationItem.title = K.vc.donateDetailtsTitle) : (navigationItem.title = K.vc.sORrSendMoneyTitle)
        }
        self.isRequest = isRequest
    }
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
    
    // check if all the faild is filled and if the email is valid
    private func isValidInputs() -> Bool {
        return emailTextField.text != "" && amountTextField.text != "" && dropDown.text != ""
    }
    
    // pop down keyboard when tap anyplace in the view
    @objc func hideKeyboard() {
        messageTextView.resignFirstResponder()
    }
    
    /// change button image from addPerson to rightCheckMark and disable/enable it.
    func toggleAddContactButton(toDone: Bool) {
        if toDone {
            DispatchQueue.main.async {
            self.addContactBtnOutlet.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            self.addContactBtnOutlet.isUserInteractionEnabled = false
            emailTextField.endEditing(true)
            startCheckForAnyChange = true
            }
        }else {
            Dispatch.main.async {
            self.addContactBtnOutlet.setImage(UIImage(systemName: "person.crop.circle.fill.badge.plus"), for: .normal)
            self.addContactBtnOutlet.isUserInteractionEnabled = true
            startCheckForAnyChange = false
            }
        }
        
    }
}

 //MARK:- TextView Delegate
extension SendAndRequestMoney: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextViewFirstEditing {
            textView.text = ""
            textView.textColor = .DnTextColor
            messageTextViewFirstEditing = false
        }
    }
}

//MARK:- TextField Delegate
extension SendAndRequestMoney: UITextFieldDelegate, PopUpMenuDelegate{
    func selectedItem(title: String, code: String?) {
        dropDown.text = title + "  [\(code ?? " ")]"
        selectedCurrencyCode = code ?? "EGP"
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
            self.presentPopUpMenu(withCategory: .currency, to: self)
            textField.endEditing(true)
        }
    }
}

extension SendAndRequestMoney: DNSegmentControlDelegate {
    func segmentValueChanged(to index: Int) {
        isRequest = index == 1 ? true: false
    }
}

//MARK:- Networking
extension SendAndRequestMoney {
    // Button
    @objc private func sendMonyOrRequest() {
        if  isValidInputs() {
            // start indicator loading...
            Hud.showLoadingHud(onView: view, withLabel: "In Process...")
            if isRequest {
                // request money
                // end indicator loading...
            }
            else {
                if presentFromDonationVC { donate() }
                else { send() }
            }
        }
        else { self.presentDNAlertOnTheMainThread(title: "Failure", Message: "missing inputs, try again.") }
    }
    
    // Donate method
    func donate() {
        let amount = amountTextField.text!
        let code   = selectedCurrencyCode
        TransferManager.shared.donate(withData: Transfer(amount: amount, currency_code: code), id: charityId!) { (result) in
            Hud.hide(after: 0)
            switch result {
                case .success(let res):
                    self.donateSuccessCase(msg: res.success)
                case .failure(let err):
                    self.donateFailureCase(msg: err.localizedDescription)
            }
        }
    }
    
    private func donateSuccessCase(msg: String) {
        self.presentDNAlertOnTheMainThread(title: "Success", Message: msg + ", your request may take from 10 - 30 seconds to confirmed.")
        NotificationCenter.default.post(name: NSNotification.Name("BALANCEWASUPDATED"), object: nil)
    }
    
    private func donateFailureCase(msg: String) {
        self.presentDNAlertOnTheMainThread(title: "Failure", Message: msg)
    }
    
    // Send Method
    func send() {
        let amount = amountTextField.text!
        let code   = selectedCurrencyCode
        let email  = emailTextField.text!
        
        TransferManager.shared.transfer(withData: Transfer(amount: amount, currency_code: code), email: email) { (result) in
            Hud.hide(after: 0)
            switch result {
                case .success(let res):
                    self.sendSuccessCase(msg: res.success)
                case .failure(let err):
                    self.sendFailureCase(msg: err.localizedDescription)
            }
        }
    }
    
    private func sendSuccessCase(msg: String) {
        self.presentDNAlertOnTheMainThread(title: "Success", Message: msg + ", your request may take from 10 - 30 seconds to confirmed.")
        NotificationCenter.default.post(name: NSNotification.Name("BALANCEWASUPDATED"), object: nil)
    }
    
    private func sendFailureCase(msg: String) {
        self.presentDNAlertOnTheMainThread(title: "Failure", Message: msg)
    }
    
    // add email to my contacts (also deak with api)
    @IBAction func addEmailToMyContacts(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            self.presentDNAlertOnTheMainThread(title: "Failure", Message: "Email is Required.")
            return
        }
        Hud.showLoadingHud(onView: self.view, withLabel: "Add Contact...")
        self.myContactManager.addNewContact(withEmail: email) { result in
            Hud.hide(after: 0)
            switch result {
                case .success(let contact):
                    self.configureAddingContactSuccessCase(withContact: contact)
                case .failure(let err):
                    self.configureAddingContactFailureCase(withError: err.localizedDescription)
            }
                
        }
    }
    
    private func configureAddingContactSuccessCase(withContact contact: CreateContactResponse) {
        self.delegate?.didAddNewContact(contact: contact)
        self.presentDNAlertOnTheMainThread(title: "Success", Message: "Contact Added Successfully.")
        self.toggleAddContactButton(toDone: true)
    }
    private func configureAddingContactFailureCase(withError err: String) {
        self.presentDNAlertOnTheMainThread(title: "Failure", Message: err)
    }
}
