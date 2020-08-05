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
        toCurrencyTextField.delegate = self
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
    }
}

extension ExchangeCurrencyVC: UITextFieldDelegate, PopUpMenuDelegate {
    
    
    func selectedItem(title: String, code: String?) {
        let value = "\(title) (\(code ?? " "))"
        if isDataForFromCurrencyTextField {
            fromCurrencyTextField.text = value
            fromCurrencyTextField.endEditing(true)
            isDataForFromCurrencyTextField = false
        } else {
            toCurrencyTextField.text = value
            toCurrencyTextField.endEditing(true)
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fromCurrencyTextField { isDataForFromCurrencyTextField = true }
        self.presentPopUpMenu(withCategory: .creditCard, to: self)
    }
}
