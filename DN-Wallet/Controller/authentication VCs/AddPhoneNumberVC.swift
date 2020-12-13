//
//  SignUpPhoneVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/6/20.
//  Copyright © 2020 DN. All rights reserved.
//
import MBProgressHUD
import UIKit

protocol UpdatePhoneDelegate: class {
    func newPhoneAndCountryInfo(phone: String, country: String)
}

class AddPhoneNumberVC: UIViewController {
    
    //MARK:- Properities
    weak var updatePhoneDelegate : UpdatePhoneDelegate?
    private var countryCode: String?
    private var completePhoneNumber: String?
    private lazy var verifyManager: VerifyManagerProtocol = VerifyManager()
    @IBOutlet weak var vcTitle: UILabel!
    @IBOutlet weak var dropDownCountry: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var confirmCodeInfoMessage: UITextView!
    @IBOutlet weak var opt: OPT!
    @IBOutlet weak var sendConfirmatioCodeOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorContainer: UIView!
    
    
    // MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK:- Configure Views
    private func configureViewController() {
        dropDownCountry.delegate = self
        dropDownCountry.doNotShowTheKeyboard()
        // specify opt delegation to this vc and hide this part for latter
        opt.delegate = self
        opt.isHidden = true
        confirmCodeInfoMessage.isHidden = true
        activityIndicatorContainer.isHidden = true
            
        // pop keyboard down when user tapped any place except the phone textField
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetKeyboardState))
        self.view.addGestureRecognizer(tapGesture)

    }
    
    @objc func resetKeyboardState() {
        phoneNumber.resignFirstResponder()
    }
    
    private func backToEditAccountVC(with phone: String, country: String) {
        UserPreference.setValue(phone, withKey: UserPreference.phone)
        UserPreference.setValue(country, withKey: UserPreference.country)
        updatePhoneDelegate?.newPhoneAndCountryInfo(phone: phone, country: country)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showIndicator(_ hidden: Bool) {
        DispatchQueue.main.async {
            if self.dropDownCountry.text != "" && self.phoneNumber.text != "" {
                self.activityIndicatorContainer.isHidden = !hidden
                hidden ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
                self.opt.isHidden = hidden
                self.confirmCodeInfoMessage.isHidden = hidden
            } else {
                self.presentDNAlertOnForground(title: "Failure", Message: "phone number or country is missing, try again")
            }
        }
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    /// user ask api to send him confirmation code on his phone number
    @IBAction func sendConfirmationCodeBtnPressed(_ sender: UIButton) {
        if let code = countryCode {
            showIndicator(true)
            sendConfirmatioCodeOutlet.setTitle("resend confirmation message", for: .normal)
            completePhoneNumber = code + phoneNumber.text!
            verifyManager.sendPhoneVerifiCode(toPhone: completePhoneNumber!) { (result) in
                self.showIndicator(false)
                switch result {
                    case .success(let res):
                        self.presentDNAlertOnTheMainThread(title: "Success", Message: res.success)
                    case .failure(let error):
                        self.presentDNAlertOnTheMainThread(title: "Failure", Message: error.localizedDescription)
                }
            }
        }
    }
    
    func showHud(withMessage msg: String, imgName: String) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .customView
            let img = UIImageView(image: UIImage(systemName: imgName))
            img.tintColor = .label
            hud.customView = img
            hud.hide(animated: true, afterDelay: 3)
        }
    }
    
}

//MARK:- Configure PopUp Menu
extension AddPhoneNumberVC: UITextFieldDelegate, PopUpMenuDelegate {
    func selectedItem(title: String, code: String?) {
        dropDownCountry.text = "[\(code ?? " ")]  " + title
        countryCode = code
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.presentPopUpMenu(withCategory: .country, to: self)
        textField.endEditing(true)
    }
}

//MARK:- Check Confirmation Code validaty
extension AddPhoneNumberVC: GetOPTValuesProtocol {
    /// this function called after user enter the opt code
    func getOpt(with value: String) {
        showIndicator(true)
        verifyManager.verifyPhone(withCode: value, andPhone: completePhoneNumber!) { (result) in
            self.showIndicator(false)
            switch result {
                case .success(_):
                    self.configureCheckPhoneCodeSuccessCase()
                case .failure(_):
                    self.configureCheckPhoneCodeFailureCase()
            }
        }
    }
    
    private func configureCheckPhoneCodeSuccessCase() {
        DispatchQueue.main.async {
            self.opt.hideErrorMessgae()
            self.backToEditAccountVC(with: self.phoneNumber.text!, country: self.dropDownCountry.text!)
        }
    }
    private func configureCheckPhoneCodeFailureCase() {
        DispatchQueue.main.async {
                self.opt.reset()
                self.opt.showErrorMessgae()
        }
    }
}
