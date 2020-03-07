//
//  SignUpPhoneVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/6/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SignUpPhoneVC: UIViewController, UITextFieldDelegate {

    //MARK:- Outlets
    @IBOutlet weak var welcomeInfoMessage: UITextView!
    @IBOutlet weak var phoneNumberContainer: UIView!
    @IBOutlet weak var dropDownCountry: DropDown!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var confirmCodeInfoMessage: UITextView!
    @IBOutlet weak var optContainerView: OTP!
    
    @IBOutlet weak var sendConfirmatioCodeOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorContainer: UIView!
    
    //MARK:- Properities
    
    
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        optContainerView.isHidden = true
        confirmCodeInfoMessage.isHidden = true
        activityIndicatorContainer.isHidden = true
        
        phoneNumberContainer.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        phoneNumberContainer.layer.borderWidth = 0.5
        phoneNumberContainer.layer.cornerRadius = 20
        dropDownConfiguration()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetKeyboardState))
        self.view.addGestureRecognizer(tapGesture)
        
       
    }
    
    @objc func resetKeyboardState() {
        phoneNumber.resignFirstResponder()
    }
    
    fileprivate func dropDownConfiguration() {
    // The list of array to display. Can be changed dynamically
    dropDownCountry.optionArray = ["Egypt", "Canada", "USA"]
    //Its Id Values and its optional
    dropDownCountry.optionIds = [1,23,54]
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendConfirmationCodeBtnPressed(_ sender: UIButton) {
        activityIndicatorContainer.isHidden = false
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.activityIndicatorContainer.isHidden = true
            self.activityIndicator.stopAnimating()
            self.optContainerView.isHidden = false
            self.confirmCodeInfoMessage.isHidden = false
        }
        
        
    }
    
}
