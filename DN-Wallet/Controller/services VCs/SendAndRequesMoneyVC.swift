//
//  SendAndRequestMoney.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/11/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SendAndRequestMoney: UIViewController {

    //MARK:- Setup Properities
    var currentSegment: Int = 1
    var segmentController: UISegmentedControl!
    var currency: DropDown!
    var messageTextViewOriginY: CGFloat = 0.0
    var keyboardSize: CGRect = .zero
    var distanceFromBottom: CGFloat = 0.0
    var messageTextViewNewY: CGFloat = 0.0
    var flage: Bool = true
    var isRequest: Bool = false
    var sendToOrganization: Bool = false
    var messageTextViewFirstEditing: Bool = true
    
    //MARK:- Setup Labels
    var infoMessage: UILabel = {
        let lb = UILabel()
        lb.basicConfigure()
        lb.text = "Send or Request Money"
        return lb
    }()
    var requestOrSentLabel: UILabel = {
        let lb = UILabel()
        lb.basicConfigure()
        lb.text = "Email"
        return lb
    }()
    var amountLabel: UILabel = {
        let lb = UILabel()
        lb.basicConfigure()
        lb.text = "Amount"
        return lb
    }()
    var currencyLabel: UILabel = {
        let lb = UILabel()
        lb.basicConfigure()
        lb.text = "Currency"
        return lb
    }()
    var messageLabel: UILabel = {
        let lb = UILabel()
        lb.basicConfigure()
        lb.text = "Message"
        return lb
    }()
    //MARK:- Setup Text Feilds
    var email: UITextField = {
        let txt = UITextField()
        txt.placeholder = "user@example.com"
        txt.textColor = .gray
        txt.font = UIFont.DN.Regular.font(size: 14)
        txt.stopSmartActions()
        txt.setBottomBorder(color: UIColor.lightGray.cgColor)
        return txt
    }()
    var amount: UITextField = {
        let txt = UITextField()
        txt.placeholder = "195.4"
        txt.textColor = .gray
        txt.font = UIFont.DN.Regular.font(size: 14)
        txt.keyboardType = .decimalPad
        txt.setBottomBorder(color: UIColor.lightGray.cgColor)
        return txt
    }()
    var messageTextView: UITextView = {
        let txt = UITextView()
        txt.text = "(Optional) short message ..."
        txt.textColor = .gray
        txt.font = UIFont.DN.Regular.font(size: 14)
        txt.addBorder(color: UIColor.lightGray.cgColor, width: 0.5)
        return txt
    }()
    
    //MARK:- Buttons
    let addEmailToContact: UIButton = {
        let btn = UIButton(type: .system)
        btn.disable()
        btn.setImage(UIImage(systemName: "person.crop.circle.fill.badge.plus"), for: .normal)
        btn.tintColor = UIColor.DN.DarkBlue.color()
        btn.addTarget(self, action: #selector(addEmailToMyContacts(_:)), for: .touchUpInside)
        return btn
    }()
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initViewController()
    }
    
    fileprivate func initViewController() {
        setupNavBar()
        // setup segment controller to determine which service should use send or request money
        setupSegmentController()
        // setup drop down menu to select specific currency
        setupDropDown()
        setupLayout()
        // determine the title of viewController be a "send money" or being a "request money"
        toggleRequestSend(isRequest: isRequest)
        // use this delegate to determine if should enable addEmailToContact button or not
        email.delegate = self
        messageTextView.delegate = self
        // use gesture to hide keyboard when click anywhere in view
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        // setup notification to pop up any textView or textfield which may overlapped by keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // make status bar component white on dark background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.DN.DarkBlue.color()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done , target: self, action: #selector(sendMonyOrRequest))
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(dismissBtnWasPressed))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func setupSegmentController() {
        segmentController = UISegmentedControl(items: ["Send", "Request"])
        isRequest ? (segmentController.selectedSegmentIndex = 1) : (segmentController.selectedSegmentIndex = 0)
        segmentController.tintColor = .white
        segmentController.selectedSegmentTintColor = UIColor.DN.DarkBlue.color()
        segmentController.addTarget(self, action: #selector(valueWasChanged), for: .valueChanged)
    }
    
    func setupDropDown() {
        currency = DropDown()
        currency.setBottomBorder(color: UIColor.lightGray.cgColor)
        currency.optionArray = ["Egyption Pound", "USA", "Urss"]
        currency.optionIds = [1,2,3]
        currency.didSelect { (item, index, id) in
            print("item: \(item), index: \(index), id: \(id)")
        }
    }
    
    func toggleRequestSend(isRequest: Bool) {
        if isRequest {
            navigationItem.title = "Request Money"
            //requestOrSentLabel.text = "Request from"
        } else {
            navigationItem.title = "Send Money"
            //requestOrSentLabel.text = "Send to"
        }
        self.isRequest = isRequest
    }
   
    func setupLayout() {
        view.addSubview(infoMessage)
        view.addSubview(segmentController)
        view.addSubview(addEmailToContact)
        let labelStack = UIStackView(arrangedSubviews: [requestOrSentLabel, amountLabel, currencyLabel])
        labelStack.configureStack(axis: .vertical, distribution: .fillEqually, alignment: .fill, space: 8)
        labelStack.DNLayoutConstraint(size: CGSize(width: 85, height: 0))
        let txtStack = UIStackView(arrangedSubviews: [email, amount, currency])
        txtStack.configureStack(axis: .vertical, distribution: .fillEqually, alignment: .fill, space: 8)
        let Vstack = UIStackView(arrangedSubviews: [labelStack, txtStack])
        Vstack.configureStack(axis: .horizontal, distribution: .fill, alignment: .fill, space: 8)
        view.addSubview(Vstack)
        view.addSubview(messageLabel)
        view.addSubview(messageTextView)
        infoMessage.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), centerH: true)
        segmentController.DNLayoutConstraint(infoMessage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 30))
        addEmailToContact.DNLayoutConstraint(segmentController.bottomAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 16), size: CGSize(width: 30, height: 30))
        Vstack.DNLayoutConstraint(segmentController.bottomAnchor, left: view.leftAnchor, right: addEmailToContact.leftAnchor, margins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 106))
        messageLabel.DNLayoutConstraint(Vstack.bottomAnchor, left: labelStack.leftAnchor, right: labelStack.rightAnchor, margins: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 30))
        messageTextView.DNLayoutConstraint(messageLabel.topAnchor, left: txtStack.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 16), size: CGSize(width: 0, height: 60))
    }
    //MARK:- Objc function
    
    /// selector action: this method called when selected segment being changed
       @objc func valueWasChanged() {
           switch segmentController.selectedSegmentIndex {
           case 0: toggleRequestSend(isRequest: false)
           case 1: toggleRequestSend(isRequest: true)
           default: break
           }
       }
       
    // notification center function called when the keyboard pop up
    @objc func keyboardWillShow(notification: NSNotification) {
            if flage {
                guard let size = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue  else { return }
                keyboardSize = size
                distanceFromBottom = view.frame.height - (messageTextView.frame.origin.y + messageTextView.frame.height)
                messageTextViewOriginY = messageTextView.frame.origin.y
                messageTextViewNewY = keyboardSize.height - distanceFromBottom
                flage = false
            }
            if keyboardSize.height > distanceFromBottom {
                if self.messageTextView.frame.origin.y == messageTextViewOriginY {
                    UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                        self.messageTextView.frame.origin.y -= self.messageTextViewNewY
                    }, completion: nil)
                   
                }
            }
    }
    // notification center function called when the keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.messageTextView.frame.origin.y != messageTextViewOriginY {
            UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                self.messageTextView.frame.origin.y = self.messageTextViewOriginY
            }, completion: nil)
            
        }
    }
    
    @objc func dismissBtnWasPressed() {
        dismiss(animated: true, completion: nil)
    }

    // the important function which responsible to deal with the api
    @objc private func sendMonyOrRequest() {
        if isRequest {
            print("request sent successfully")
        } else {
            print("money send successfully")
        }
        
    }
    // pop down keyboard when tap anyplace in the view
    @objc func hideKeyboard() {
        messageTextView.resignFirstResponder()
    }
    
    // add email to my contacts (also deak with api)
    @objc func addEmailToMyContacts(_ sender: UIButton) {
        if email.text != "" && Auth.shared.isValidEmail(email.text!) {
            if ["ahmed@gmail.com"].contains(email.text!) {
                Auth.shared.buildAndPresentAlertWith("Email Exist", message: "this email is already exist in you contacts", viewController: self)
            } else {
                let alert = UIAlertController(title: "Add Username", message: "write a username for this email", preferredStyle: .alert)
                let add = UIAlertAction(title: "Add", style: .default) { (action) in
                    // Call Api to add 
                    self.addEmailToContact.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                }
                alert.addTextField { (txt) in
                    txt.placeholder = "\(self.email.text!.split(separator: "@")[0])"
                    txt.basicConfigure()
                }
                alert.addAction(add)
                present(alert, animated: true, completion: nil)
            }
            
            
            email.endEditing(true)
        } else {
            Auth.shared.buildAndPresentAlertWith("Invalid Email", message: "this email is invalid, Try Again.", viewController: self)
        }
        
    }
}

extension SendAndRequestMoney: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextViewFirstEditing {
            textView.text = ""
            messageTextViewFirstEditing = false
        }
        
    }
}
extension SendAndRequestMoney: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addEmailToContact.enable()
    }
}
