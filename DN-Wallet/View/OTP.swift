//
//  OTP.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/6/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class OTP: UIView {

    
    var tf1 : UITextField = {
        let txtfeild = UITextField()
        txtfeild.configureTf()
        return txtfeild
    }()
    
    var tf2 : UITextField = {
        let txtfeild = UITextField()
        txtfeild.configureTf()
        return txtfeild
    }()
    
    var tf3 : UITextField = {
        let txtfeild = UITextField()
        txtfeild.configureTf()
        return txtfeild
    }()
    
    var tf4 : UITextField = {
        let txtfeild = UITextField()
        txtfeild.configureTf()
        return txtfeild
    }()
    
    
    func setupStackView() {
        let stk  = UIStackView(arrangedSubviews: [tf1 , tf2, tf3, tf4])
        stk.alignment = .fill
        stk.distribution = .fillEqually
        stk.spacing = 16.0
        stk.axis = .horizontal
        addSubview(stk)
        stk.constraints(topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, margins: .zero, size: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupStackView()
        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        tf4.delegate = self
        tf1.becomeFirstResponder()
        tf1.layer.borderColor = #colorLiteral(red: 0.167981714, green: 0.6728672981, blue: 0.9886779189, alpha: 1)
        

    }
}


extension UITextField {
    func configureTf() {
        self.frame = CGRect(x: 0, y: 0, width: 40.0, height: 40.0)
        self.textAlignment = .center
        self.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        //self.backgroundColor = .red
        //self.font = UIFont(name: "Menlo Regular", size: 18)
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 0.5
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.smartDashesType = .no
        self.smartInsertDeleteType = .no
        self.smartQuotesType = .no
        self.spellCheckingType = .no
        self.keyboardType = .numberPad
    }
}

extension OTP : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text
            if text?.utf16.count == 1 {
                switch textField {
                    case tf1:
                        tf2.becomeFirstResponder()
                        tf2.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                        tf1.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    case tf2:
                        tf3.becomeFirstResponder()
                        tf3.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                        tf2.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    
                    case tf3:
                        tf4.becomeFirstResponder()
                        tf4.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                        tf3.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    case tf4:
                        tf4.resignFirstResponder()
                        tf4.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    default:
                        break
                }
            }
    }

}
