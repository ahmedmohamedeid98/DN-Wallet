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
    //MARK:- Outlets
    
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
        dropDownCountry.delegate = self
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
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = .text
                hud.detailsLabel.text = "phone number or country is missing, try again"
                hud.offset = CGPoint(x: 0.0, y: MBProgressMaxOffset)
                hud.hide(animated: true, afterDelay: 3)
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
            NetworkManager.verifyPhone(number: completePhoneNumber!) { (result) in
                self.showIndicator(false)
                switch result {
                    case .success(_):
                        self.showHud(withMessage: "code send successfully", imgName: "checkmark")
                    case .failure(let error):
                        self.showHud(withMessage: error.rawValue, imgName: "xmark")
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

extension AddPhoneNumberVC: UITextFieldDelegate, PopUpMenuDelegate {
    func selectedItem(title: String, code: String?) {
        dropDownCountry.text = "(\(code ?? " "))\t" + title
        countryCode = code
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = PopUpMenu()
        vc.menuDelegate = self
        vc.dataSource = .country
        self.present(vc, animated: true, completion: nil)
        textField.endEditing(true)
    }
}

extension AddPhoneNumberVC: GetOPTValuesProtocol {
    /// this function called after user enter the opt code
    func getOpt(with value: String) {
        showIndicator(true)
        NetworkManager.checkPhoneCode(number: completePhoneNumber ?? "wrongNumber" , code: value) { (result) in
            self.showIndicator(false)
            switch result {
                case .success(_):
                    self.opt.hideErrorMessgae()
                    self.backToEditAccountVC(with: self.phoneNumber.text!, country: self.dropDownCountry.text!)
                case .failure(_):
                    DispatchQueue.main.async {
                        self.opt.reset()
                        self.opt.showErrorMessgae()
                }
            }
        }
    }
}
