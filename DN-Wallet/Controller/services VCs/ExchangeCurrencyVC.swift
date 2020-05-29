//
//  ExchangeCurrencyVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/17/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit



class ExchangeCurrencyVC: UIViewController {


    //MARK:- Properities

    // static three label from - to - amount
    let fromLable = UILabel().DNLabel(text: K.from, fontSize: 18, color: keyColor)
    let ToLabel = UILabel().DNLabel(text: K.to, fontSize: 18, color: keyColor)
    let amountLabel = UILabel().DNLabel(text: K.amount, fontSize: 18, color: keyColor)

    // drop down menu to choose the currency which needed to exchange
    var fromDropDown: DropDown!
    // drop down menu to choose the target currency which need to exchange to it.
    var toDropDown: DropDown!
    
    // supported views created for setup the border for the both drop down menu
    var fromDropDownContainer: UIView = {
        let vw = UIView()
        vw.layer.borderColor = UIColor.DnGrayColor.cgColor
        vw.layer.borderWidth = 0.5
        return vw
    }()
    var toDropDownContainer: UIView = {
        let vw = UIView()
        vw.layer.borderColor = UIColor.DnGrayColor.cgColor
        vw.layer.borderWidth = 0.5
        return vw
    }()
    
    // textfield in which we write the amount we want to exchange
    var amountValue: UITextField = {
        let tf = UITextField()
        tf.placeholder = "eg: 195.65"
        tf.leftPadding()
        tf.keyboardType = .decimalPad
        tf.stopSmartActions()
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.DnGrayColor.cgColor
        return tf
    }()
    
    // 5 - hidden label view created to display the output amount appear whene calculate button pressed
    var resultLabel: UILabel = {
        let lb = UILabel()
        lb.isHidden = true
        lb.text = "result"
        lb.textAlignment = .center
        lb.textColor = .DnColor
        lb.font = UIFont.DN.Regular.font(size: 16)
        lb.layer.borderWidth = 0.5
        lb.layer.borderColor = UIColor.DnGrayColor.cgColor
        return lb
    }()
    
    // first button which calculate the amount that will be the exchange process's result
    var calculateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(K.vc.exchangeCurrCalculateBtnTitle, for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .DnColor
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    // second button which do the main job 'exchanges'
    var exchangeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(K.vc.exchangeCurrExchangeBtnTitle, for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .DnColor
        btn.layer.cornerRadius = 20
        return btn
    }()
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        setupNavBar() // setup navigation bar
        setupDropDownTf() // setup both drop down menu
        setupLayout() // setup layout constants of subviews
        
        // add two action function for the both button
        calculateButton.addTarget(self, action: #selector(currencyCalculator), for: .touchUpInside)
        exchangeButton.addTarget(self, action: #selector(exchangeCurrencyAction), for: .touchUpInside)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // selector action fired when the calculate button pressed
    @objc func currencyCalculator() {
        amountValue.resignFirstResponder()
        resultLabel.isHidden = false
        resultLabel.text = "25.5 $"
        
    }
    // selector action fired when the exchange button pressed
    @objc func exchangeCurrencyAction() {
        
    }
    
    
    /// init `from` and  `to` drop down menu
    func setupDropDownTf() {
        fromDropDown = DropDown()
        toDropDown = DropDown()
        fromDropDown.isSearchEnable = false
        toDropDown.isSearchEnable = false
        let currencyList = ["EGB", "USD", "YER", "EUR"]
        let currencyId = [1,2,3,4]
        fromDropDown.optionArray = currencyList
        fromDropDown.optionIds = currencyId
        
        toDropDown.optionArray = currencyList
        toDropDown.optionIds = currencyId
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
    
    private func setupLayout() {
        let HstackLabel = UIStackView(arrangedSubviews: [fromLable, ToLabel, amountLabel])
        let HstackValue = UIStackView(arrangedSubviews: [fromDropDownContainer, toDropDownContainer, amountValue])
        // 3 - vertical stack contain both horizental stack
        let Vstack = UIStackView(arrangedSubviews: [HstackLabel, HstackValue])
        // 4 - vertical stack contain both button `calculate` and `exchange`
        let btnStack = UIStackView(arrangedSubviews: [calculateButton, exchangeButton])
        
        HstackLabel.configureHstack()
        HstackLabel.DNLayoutConstraint(size: CGSize(width: 100, height: 0))
        HstackValue.configureHstack()
        Vstack.configureVstack()
        btnStack.axis = .horizontal
        btnStack.distribution = .fillEqually
        btnStack.alignment = .fill
        btnStack.spacing = 20
        
        view.addSubview(Vstack)
        view.addSubview(btnStack)
        view.addSubview(resultLabel)
        fromDropDownContainer.addSubview(fromDropDown)
        toDropDownContainer.addSubview(toDropDown)
       
        Vstack.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 120))
        fromDropDown.DNLayoutConstraint(fromDropDownContainer.topAnchor, left: fromDropDownContainer.leftAnchor, right: fromDropDownContainer.rightAnchor, bottom: fromDropDownContainer.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20))
        toDropDown.DNLayoutConstraint(toDropDownContainer.topAnchor, left: toDropDownContainer.leftAnchor, right: toDropDownContainer.rightAnchor, bottom: toDropDownContainer.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20))
        btnStack.DNLayoutConstraint(Vstack.bottomAnchor, margins: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), size: CGSize(width: 300, height: 40), centerH: true)
        resultLabel.DNLayoutConstraint(btnStack.bottomAnchor, margins: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0), centerH: true)
    }
}
