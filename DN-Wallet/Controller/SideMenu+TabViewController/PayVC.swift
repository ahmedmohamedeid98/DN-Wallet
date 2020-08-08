//
//  PayVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 2/29/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class PayVC: UIViewController {

    //MARK:- Properities
    private lazy var auth: UserAuthProtocol = UserAuth()
    private var actualBalance: Balance?
    // this value come from ContainerVC
    var userBalance: [Balance] = []
    
    //MARK:- Outlets
    @IBOutlet weak var dropDown: UITextField!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var calculatedFeesLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var Step_one: UIStepper!
    @IBOutlet weak var Step_five: UIStepper!
    @IBOutlet weak var Step_ten: UIStepper!
    var amountValue: Double = 0.0 {
        didSet {
            if self.fromStepper {
            self.amountField.text = "\(self.amountValue)"
            }
            if self.amountValue > 10.0 {
                feesValue = self.amountValue * 1 / 100
            }
        }
    }
    var feesValue: Double = 0.0 {
        didSet {
            self.feesLabel.text = "\(self.feesValue)"
        }
    }
    var fromStepper: Bool = false
    var oldValue_one: Double = 0
    var oldValue_five: Double = 0
    var oldValue_ten: Double = 0
    //MARK:- Properities
    
    
    //MARK:- Initialization
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        amountField.delegate = self
        oldValue_one = Step_one.value
        oldValue_five = Step_five.value
        oldValue_ten = Step_ten.value
        handleNavigationBar()
        handelPopUpTextField()
        dropDown.doNotShowTheKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if auth.isAppInSafeMode {
            _ = auth.checkIfAppOutTheSafeMode()
            print("app in safe mode")
        }
    }
    
    func handleNavigationBar() {
        navigationItem.title = "Pay"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .DnColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let scanBarButton = UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(ScanButtonPressed))
        navigationItem.rightBarButtonItem = scanBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
            
    }
    
    @objc func ScanButtonPressed() {
        view.endEditing(true)
        if let amount = amountField.text, let currency = dropDown.text {
            let enteredBalance = Balance(amount: amount, currency_code: currency)
            if self.isValidAmount(balance: enteredBalance) {
                // if the app in safe mode the update allowed amount
                if auth.isAppInSafeMode {
                    auth.allowedAmountInSafeMode = auth.allowedAmountInSafeMode - (Int(enteredBalance.amount) ?? 0)
                }
                preformScanOperation(with: enteredBalance)
            } else {
                let message: String
                if auth.isAppInSafeMode {
                    message = "Entered amount (\(amount)) greater than remaining allowed amount in safeMode (\(auth.allowedAmountInSafeMode))"
                } else {
                    if let balance = actualBalance {
                        message = "Entered amount (\(amount)) greater than your balace amount (\(balance.amount)  \(balance.currency_code)"
                    } else {
                        message = "something was wrong please try again"
                    }
                }
                // alert
                self.presentDNAlertOnTheMainThread(title: K.alert.faild, Message: message)
            }
            amountValue = 0.0
            amountField.text = ""
            
        }
    }
    
    private func isValidAmount(balance: Balance) -> Bool {
        
        if auth.isAppInSafeMode {
            return Int(balance.amount) ?? 0 <= auth.allowedAmountInSafeMode
        } else {
            let actualBalances = userBalance.filter { $0.currency_code == balance.currency_code }
            actualBalance = actualBalances.first
            if let safeActualBalance = actualBalance {
                return balance.amount <= safeActualBalance.amount
            }
            return false
        }
    }
    
    private func preformScanOperation(with balance: Balance) {
        print("preform scan operation")
    }
    
    private func handelPopUpTextField() {
        dropDown.delegate = self
        dropDown.placeholder = "select currency"
        //dropDown.text = UserPreference.getStringValue(withKey: UserPreference.currencyKey)
    }
    
    @IBAction func Stepper_one(_ sender: UIStepper) {
        fromStepper = true
        if sender.value > oldValue_one {
            amountValue += 1
        } else {
            if amountValue >= 1 { amountValue -= 1}
        }
        oldValue_one = sender.value
         
    }
    @IBAction func Stepper_five(_ sender: UIStepper) {
        fromStepper = true
        if sender.value > oldValue_five {
            amountValue += 5
        } else {
            if amountValue >= 5 { amountValue -= 5}
        }
        oldValue_five = sender.value
        
    }
    @IBAction func Stepper_ten(_ sender: UIStepper) {
        fromStepper = true
        if sender.value > oldValue_ten {
            amountValue += 10
        } else {
            if amountValue >= 10 { amountValue -= 10}
        }
        oldValue_ten = sender.value
    }

}

extension PayVC: UITextFieldDelegate, PopUpMenuDelegate {
    func selectedItem(title: String, code: String?) {
        dropDown.text = title + "  [\(code ?? " ")]"
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dropDown {
            self.presentPopUpMenu(withCategory: .currency, to: self)
            textField.endEditing(true)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
         if textField == amountField {
            fromStepper = false
            guard let txt = textField.text else {return}
            if let num = Double(txt) {
                self.amountValue = num
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
       // key
    }
}
