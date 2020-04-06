//
//  SignUpPhoneVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/6/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SignUpPhoneVC: UIViewController, UITextFieldDelegate, GetOPTValuesProtocol {
    
    var user:User?
    
    //MARK:- Outlets
    @IBOutlet weak var phoneNumberContainer: UIView!
    @IBOutlet weak var dropDownCountry: DropDown!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var confirmCodeInfoMessage: UITextView!
    @IBOutlet weak var opt: OPT!
    @IBOutlet weak var sendConfirmatioCodeOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var steppedProgressBar: SteppedProgressBar!
    
    
    
    //MARK:- Properities
    
    
    
    //MARK:- Init
    fileprivate func commonInit() {
        
        // configure the container layer which hold country dropDown and phone txtField
        phoneNumberContainer.layer.borderColor = UIColor.DN.LightGray.color().cgColor
        phoneNumberContainer.layer.borderWidth = 1
        phoneNumberContainer.layer.cornerRadius = 4
        
        dropDownConfiguration()
        
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
    }
    // MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
        
       
    }
    
    @objc func resetKeyboardState() {
        phoneNumber.resignFirstResponder()
    }
    
    fileprivate func dropDownConfiguration() {
        // The list of array to display. Can be changed dynamically
        dropDownCountry.optionArray = ["Egyption Pound", "Dollar", "Uouro"]
        //Its Id Values and its optional
        dropDownCountry.optionIds = [40,41,42,43]
        dropDownCountry.checkMarkEnabled = true
        dropDownCountry.isSearchEnable = false
        //dropDown.searchText = "Egyption Pound"
        // The the Closure returns Selected Index and String
        dropDownCountry.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
        }
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
                self.present(vc!, animated: true)
            }else {
                self.opt.reset()
                self.opt.showErrorMessgae()
            }
        }
    }
    
    func showIndicator(_ hidden: Bool) {
        activityIndicatorContainer.isHidden = !hidden
        hidden ? activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        self.opt.isHidden = hidden
        self.confirmCodeInfoMessage.isHidden = hidden
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
