//
//  ExchangeCurrencyVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/17/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit



class ExchangeCurrencyVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var toCurrencyTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var calculateBtnOutlet: UIButton!
    @IBOutlet weak var exchangeBtnOutlet: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    private var curr1: String?
    private var curr2: String?

    private var isDataForFromCurrencyTextField: Bool = false
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupNavBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
  
    private func initView() {
        fromCurrencyTextField.delegate = self
        fromCurrencyTextField.doNotShowTheKeyboard()
        toCurrencyTextField.delegate = self
        toCurrencyTextField.doNotShowTheKeyboard()
        resultLabel.isHidden = true
        exchangeBtnOutlet.layer.cornerRadius = 20.0
        calculateBtnOutlet.layer.cornerRadius = 20.0
    }
  
    /// inital navigation bar with custom nav bar `DNNavBar`
    func setupNavBar() {
        self.configureNavigationBar(title: K.vc.exchangeCurrTitle)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: K.sysImage.leftArrow), style: .plain, target: self, action: #selector(backBtnAction))
    }
    

    // left item buttom of nav bar, dismiss view controller
    @objc func backBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func calculateButtonAction(_ sender: UIButton) {
        amountTextField.resignFirstResponder()
        resultLabel.isHidden = false
        resultLabel.text = "25.5 $"
    }
    
    @IBAction func exchangeButtonAction(_ sender: UIButton) {
        exchange()
    }

}

extension ExchangeCurrencyVC: UITextFieldDelegate, PopUpMenuDelegate {
    
    
    func selectedItem(title: String, code: String?) {
        let value = "\(title) (\(code ?? " "))"
        if isDataForFromCurrencyTextField {
            fromCurrencyTextField.text = value
            fromCurrencyTextField.endEditing(true)
            isDataForFromCurrencyTextField = false
            curr1 = code
        } else {
            toCurrencyTextField.text = value
            toCurrencyTextField.endEditing(true)
            curr2 = code
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fromCurrencyTextField { isDataForFromCurrencyTextField = true }
        self.presentPopUpMenu(withCategory: .currency, to: self)
    }
}

//MARK:- Networking
extension ExchangeCurrencyVC {
    
    private func exchange() {
        validateInput()
        Hud.showLoadingHud(onView: view, withLabel: "exchanging...")
        TransferManager.shared.exchange(amount: Int(amountTextField.text!) ?? 0 , from: curr1!, to: curr2!) { result in
            Hud.hide(after: 0)
            switch result {
                case .success(let res):
                    self.exchangeSuccess(msg: res.success)
                case .failure(let err):
                    self.exchangeFailure(msg: err.localizedDescription)
            }
        }
    }
    
    private func exchangeSuccess(msg: String) {
        self.presentAlertOnTheMainThread(title: "Success", Message: msg + ", your request may take from 10 - 30 seconds to confirmed.")
        NotificationCenter.default.post(name: NSNotification.Name("BALANCEWASUPDATED"), object: nil)
    }
    private func exchangeFailure(msg: String) {
        self.presentAlertOnTheMainThread(title: "Failure", Message: msg)
    }
    
    func validateInput() {
        guard let code1 = curr1, !code1.isEmpty else {
            presentAlertOnTheMainThread(title: "Required", Message: "Enter the first currency. and Try again.")
            return
        }
        
        guard let code2 = curr2, !code2.isEmpty else {
            presentAlertOnTheMainThread(title: "Required", Message: "Enter the second currency. and Try again.")
            return
        }
        
        guard let amount = amountTextField.text, !amount.isEmpty else {
            presentAlertOnTheMainThread(title: "Required", Message: "Amount is required. Try again")
            return
        }
    }
}
