//
//  OTP.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/6/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class OPT: UIView {

    var delegate: GetOPTValuesProtocol!
    
    
    var errorMsg: UILabel = {
        let label = UILabel()
        label.text = "Invalid Code, Try Again"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    
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
        addSubview(errorMsg)
        stk.DNLayoutConstraint(topAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, margins: .zero, size: CGSize(width: 0, height: 40) )
        errorMsg.DNLayoutConstraint(stk.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, margins: .zero, size: .zero)
    }
    
    func reset() {
        tf1.text = ""
        tf2.text = ""
        tf3.text = ""
        tf4.text = ""
        tf1.becomeFirstResponder()
    }
    
    func sendOptValues() {
        let tf1_val = Int(tf1.text ?? "11")!
        let tf2_val = Int(tf2.text ?? "11")!
        let tf3_val = Int(tf3.text ?? "11")!
        let tf4_val = Int(tf4.text ?? "11")!
        delegate.getOptValues(tf1: tf1_val, tf2: tf2_val, tf3: tf3_val, tf4: tf4_val)
    }
    
    fileprivate func commonInit() {
        setupStackView()
        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        tf4.delegate = self
        //tf1.becomeFirstResponder()
        //tf1.layer.borderColor = #colorLiteral(red: 0.167981714, green: 0.6728672981, blue: 0.9886779189, alpha: 1)
    }
    
    
    // Init for UIView Design Programatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    // Init for UIView Design in Storyboard
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        commonInit()
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
        self.stopSmartActions()
        self.keyboardType = .numberPad
    }
}

extension OPT : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text
            if text?.utf16.count == 1 {
                switch textField {
                    case tf1:
                        tf2.becomeFirstResponder()
                    case tf2:
                        tf3.becomeFirstResponder()
                    case tf3:
                        tf4.becomeFirstResponder()
                    case tf4:
                        tf4.resignFirstResponder()
                        sendOptValues()
                    default:
                        break
                }
            }
    }

}
