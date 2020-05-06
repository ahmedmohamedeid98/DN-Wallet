//
//  PayVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 2/29/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class PayVC: UIViewController {

    
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
            print("amountValue: \(self.amountValue)")
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
        view.backgroundColor = .DnBackgroundColor
        amountField.delegate = self
        oldValue_one = Step_one.value
        oldValue_five = Step_five.value
        oldValue_ten = Step_ten.value
        handleNavigationBar()
        handelPopUpTextField()
    }
    
    func handleNavigationBar() {
        navigationItem.title = "Pay"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .DnDarkBlue
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let scanBarButton = UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(ScanButtonPressed))
        navigationItem.rightBarButtonItem = scanBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
            
    }
    
    @objc func ScanButtonPressed() {
        view.endEditing(true)
        print("scan Button Pressed")
    }
    
    private func handelPopUpTextField() {
        dropDown.delegate = self
        dropDown.placeholder = "select currency"
        dropDown.text = UserDefaults.standard.string(forKey: Defaults.Currency.key)
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
    func selectedItem(title: String) {
        dropDown.text = title
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dropDown {
            let vc = PopUpMenu()
            vc.menuDelegate = self
            vc.originalDataSource = [PopMenuItem(image: nil, title: "Egyption Pound"), PopMenuItem(image: nil, title: "UDS")]
            self.present(vc, animated: true, completion: nil)
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
