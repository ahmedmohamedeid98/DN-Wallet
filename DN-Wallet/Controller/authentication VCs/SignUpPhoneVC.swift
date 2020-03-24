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
    @IBOutlet weak var welcomeInfoMessage: UITextView!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        opt.delegate = self
        opt.isHidden = true
        confirmCodeInfoMessage.isHidden = true
        activityIndicatorContainer.isHidden = true
        
        phoneNumberContainer.layer.borderColor = UIColor.DN.LightGray.color().cgColor
        phoneNumberContainer.layer.borderWidth = 1
        phoneNumberContainer.layer.cornerRadius = 4
        dropDownConfiguration()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetKeyboardState))
        self.view.addGestureRecognizer(tapGesture)
        
        steppedProgressBar.titles = ["", "", ""]
        steppedProgressBar.currentTab = 2
        
       
    }
    
    @objc func resetKeyboardState() {
        phoneNumber.resignFirstResponder()
    }
    
    fileprivate func dropDownConfiguration() {
        // The list of array to display. Can be changed dynamically
        dropDownCountry.optionArray = ["Egypt", "Canada", "USA"]
        //Its Id Values and its optional
        dropDownCountry.optionIds = [1,23,54]
        dropDownCountry.isSearchEnable = false
        dropDownCountry.didSelect { (selectedText, index, id) in
            print(selectedText)
        }
    }
    
    func getOptValues(tf1: Int, tf2: Int, tf3: Int, tf4: Int) {
        activityIndicatorContainer.isHidden = false
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.activityIndicator.stopAnimating()
            self.activityIndicatorContainer.isHidden = true
            if "\(tf1)\(tf2)\(tf3)\(tf4)" == "1122" {
                self.opt.errorMsg.isHidden = true
                let st = UIStoryboard(name: "Authentication", bundle: .main)
                let vc = st.instantiateViewController(identifier: "signUpConfirmEmailVCID") as? SignUpConfirmEmailVC
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true)
            }else {
                self.opt.reset()
                self.opt.errorMsg.isHidden = false
            }
        }
    }
    

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendConfirmationCodeBtnPressed(_ sender: UIButton) {
        activityIndicatorContainer.isHidden = false
        activityIndicator.startAnimating()
        sendConfirmatioCodeOutlet.setTitle("resend confirmation message", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.activityIndicatorContainer.isHidden = true
            self.activityIndicator.stopAnimating()
            self.opt.isHidden = false
            self.confirmCodeInfoMessage.isHidden = false
            
        }
        
        
    }
    
}
