//
//  SignUpPhoneVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/6/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SignUpPhoneVC: UIViewController, GetOPTValuesProtocol {
    
    
    //MARK:- Properities
    var user:User?
    
    //MARK:- Outlets
    @IBOutlet weak var phoneNumberContainer: UIView!
    @IBOutlet weak var dropDownCountry: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var confirmCodeInfoMessage: UITextView!
    @IBOutlet weak var opt: OPT!
    @IBOutlet weak var sendConfirmatioCodeOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var steppedProgressBar: SteppedProgressBar!
    
    // MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        // configure the container layer which hold country dropDown and phone txtField
        phoneNumberContainer.layer.borderColor = UIColor.DnGrayColor.cgColor
        phoneNumberContainer.layer.borderWidth = 1
        phoneNumberContainer.layer.cornerRadius = 4
        
        dropDownCountry.delegate = self
        
        // specify opt delegation to this vc and hide this part for latter
        opt.delegate = self
        opt.isHidden = true
        confirmCodeInfoMessage.isHidden = true
        activityIndicatorContainer.isHidden = true
        
        
        // pop keyboard down when user tapped any place except the phone textField
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetKeyboardState))
        self.view.addGestureRecognizer(tapGesture)
        
        // setup stepProgressBar
        steppedProgressBar.titles = ["", "", ""]
        steppedProgressBar.currentTab = 2
        
        dropDownCountry.text = "Egypt"
        phoneNumber.text = "01035486578"

    }
    
    @objc func resetKeyboardState() {
        phoneNumber.resignFirstResponder()
    }
    
    /// this function called after user enter the opt code
    func getOptValues(tf1: Int, tf2: Int, tf3: Int, tf4: Int) {
        showIndicator(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showIndicator(false)
            if "\(tf1)\(tf2)\(tf3)\(tf4)" == "1122" {
                self.opt.hideErrorMessgae()
                let st = UIStoryboard(name: "Authentication", bundle: .main)
                let vc = st.instantiateViewController(identifier: "signUpConfirmEmailVCID") as? SignUpConfirmEmailVC
                vc?.modalPresentationStyle = .fullScreen
                self.user?.country = self.dropDownCountry.text!
                self.user?.phone = self.phoneNumber.text!
                vc?.registerData = self.user
                self.present(vc!, animated: true)
            }else {
                self.opt.reset()
                self.opt.showErrorMessgae()
            }
        }
    }
    
    func showIndicator(_ hidden: Bool) {
        if dropDownCountry.text != "" && phoneNumber.text != "" {
            activityIndicatorContainer.isHidden = !hidden
            hidden ? activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            self.opt.isHidden = hidden
            self.confirmCodeInfoMessage.isHidden = hidden
        } else {
            Alert.syncActionOkWith(nil, msg: "you must choose your country and enter your phone number", viewController: self)
        }
        
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    /// user ask api to send him confirmation code on his phone number
    @IBAction func sendConfirmationCodeBtnPressed(_ sender: UIButton) {
        showIndicator(true)
        sendConfirmatioCodeOutlet.setTitle("resend confirmation message", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showIndicator(false)
        }
        
        
    }
    
}

extension SignUpPhoneVC: UITextFieldDelegate, PopUpMenuDelegate {
    
    func selectedItem(title: String) {
        print("selected Country : \(title)")
        dropDownCountry.text = title
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = PopUpMenu()
        vc.menuDelegate = self
        vc.originalDataSource = [PopMenuItem(image: nil, title: "Egypt"), PopMenuItem(image: nil, title: "Landon"), PopMenuItem(image: nil, title: "America")]
        self.present(vc, animated: true, completion: nil)
        textField.endEditing(true)
    }
}
