//
//  AddNewCardVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/16/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class AddNewCardVC: UIViewController {

    
    
    
    var navBar: DNNavBar!
    
    var cardName: DropDown!
    
    let CardHolderName: UITextField = {
        let tf = UITextField()
        tf.placeholder = "CARDHOLDER NAME"
        tf.configureTf()
        return tf
    }()
    let CardNumber: UITextField = {
        let tf = UITextField()
        tf.placeholder = "CARDHOLDER NAME"
        tf.configureTf()
        return tf
    }()
    //let expireDate
    
    let cvv: UITextField = {
        let tf = UITextField()
        tf.placeholder = "CARDHOLDER NAME"
        tf.configureTf()
        return tf
    }()
    let address: UITextField = {
        let tf = UITextField()
        tf.placeholder = "CARDHOLDER NAME"
        tf.configureTf()
        return tf
    }()
    
    
    let cardHolderNameContainer: UILabel = {
        let lb = UILabel()
        lb.text = "CARDHOLDER NAME"
        lb.configureCardInfoLabel()
        return lb
    }()
    let cardNumberContainer: UILabel = {
        let lb = UILabel()
        lb.text = "CARD NUMBER"
        lb.configureCardInfoLabel()
        return lb
    }()
    let expireDateContainer: UILabel = {
        let lb = UILabel()
        lb.text = "EXPIRE DATE"
        lb.configureCardInfoLabel()
        return lb
    }()
    let cvvContainer: UILabel = {
        let lb = UILabel()
        lb.text = "CVV"
        lb.configureCardInfoLabel()
        return lb
    }()
    let addressContainer: UILabel = {
        let lb = UILabel()
        lb.text = "ADDRESS"
        lb.configureCardInfoLabel()
        return lb
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    
    func setupNavBar() {
        navBar = DNNavBar()
        navBar.title.text = "Add Payment Card"
        navBar.addLeftItem(imageName: "arrow.left")
        navBar.addRightItem(imageName: "plus")
        navBar.leftBtn.addTarget(self, action: #selector(dismissBtnWasPressed), for: .touchUpInside)
        navBar.rightBtn.addTarget(self, action: #selector(addPaymentCardBtnPressed), for: .touchUpInside)
    }
    
    @objc func dismissBtnWasPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addPaymentCardBtnPressed() {
        
        navBar.rightBtn.isEnabled = false
        
        
        
        let alert = UIAlertController(title: "Success", message: "Adding Payment Card done Successfully", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    


}

extension UILabel {
    func configureCardInfoLabel() {
        self.textColor = #colorLiteral(red: 0.4244702483, green: 0.8972335188, blue: 0.9657534247, alpha: 0.6574539812)
        self.font = UIFont.DN.SemiBlod.font(size: 16)
        self.textAlignment = .right
    }
}

extension UITextField {
    func configureCardTF() {
        self.font = UIFont.DN.Bold.font(size: 14)
        self.textColor = UIColor.DN.DarkBlue.color()
        self.textAlignment = .left
    }
}
