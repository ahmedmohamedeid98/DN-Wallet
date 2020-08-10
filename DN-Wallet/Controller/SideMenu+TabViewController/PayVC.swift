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
    let documentFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Balance.plist")
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
    var currency_code: String?
    
    
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
        loadBalanceData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        auth.checkIfAppOutTheSafeMode()
    }
    
    func loadBalanceData() {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: documentFilePath!)
            let balance = try decoder.decode([Balance].self, from: data)
            self.userBalance = balance
        } catch {
            
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
        let balanceChecker = BalancePro(userBalance: self.userBalance)
        if balanceChecker.canMakeTransactionOn(amount: amountField.text, code: currency_code) {
            preformScanOperation(with: balanceChecker.balance)
        } else {
            presentAlertOnTheMainThread(title: "Failure", Message: balanceChecker.errorMessage!)
        }
        amountValue = 0.0
        amountField.text = ""
    }
    
    
    private func preformScanOperation(with balance: Balance) {
        let vc = QRScannerVC()
        vc.balance = balance
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handelPopUpTextField() {
        dropDown.delegate = self
        dropDown.placeholder = "select currency"
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
        self.currency_code = code
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
}
