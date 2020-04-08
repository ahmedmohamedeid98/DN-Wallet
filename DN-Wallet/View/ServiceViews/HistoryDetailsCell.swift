//
//  consumptionCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/13/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

let keyColor = UIColor.DN.DarkBlue.color()
let valueColor = UIColor.DN.Black.color()

class HistoryDetailsCell: UITableViewCell {
    
    
    //MARK:- key label
    private let to = UILabel().DNLabel(text: "Email", color: keyColor)
    private let amount = UILabel().DNLabel(text: "Amount", color: keyColor)
    private let date = UILabel().DNLabel(text: "Date", color: keyColor)
    
    //MARK:- value label
    private(set) var toEmail = UILabel().DNLabel(text: "aa@gmail.com", color: valueColor)
    private(set) var amountNumber = UILabel().DNLabel(text: "25 $", color: valueColor)
    private(set) var dateValue = UILabel().DNLabel(text: "2/1/2020", color: valueColor)
    
    // setup layout constraint
    private var stackContrainer = UIView()
    private func setupStackView() {
        let HstackLabel = UIStackView(arrangedSubviews: [to, amount, date])
        let HstackValue = UIStackView(arrangedSubviews: [toEmail, amountNumber, dateValue])
        let Vstack = UIStackView(arrangedSubviews: [HstackLabel, HstackValue])
        
        HstackLabel.configureHstack()
        HstackLabel.DNLayoutConstraint(size: CGSize(width: 60, height: 0))
        HstackValue.configureHstack()
        Vstack.configureVstack()
        
        
        addSubview(stackContrainer)
        stackContrainer.addSubview(Vstack)
        stackContrainer.DNLayoutConstraint(topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, margins: UIEdgeInsets(top: 10, left: 8, bottom: 8, right: 10))
        Vstack.DNLayoutConstraint(stackContrainer.topAnchor, left: stackContrainer.leftAnchor, right: stackContrainer.rightAnchor, bottom: stackContrainer.bottomAnchor)
    }
    
    /// set history details cell's values
    /// - parameters
    ///     - email : your organization or individuals email
    ///     - amount: the amount which is transaction
    ///     - date : the date in which this transaction happen
    func configureCell(email: String, amount: String, date: String) {
        self.toEmail.text = email
        self.amountNumber.text = amount
        self.dateValue.text = date
    }
    
    /// Cell : setup the view and all the internal subviews for the tableView cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.backgroundColor = .white
        //self.layer.borderColor = UIColor.DN.DarkBlue.color().cgColor
        //self.layer.borderWidth = 1
        //self.layer.cornerRadius = 8
        
        setupStackView()
    }
    
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension UIStackView {
    /// initialization for horizental stack 'axis -> horizental', 'distribution -> fillEq', 'alignment -> fill' and spacing -> 8
    func configureHstack() {
        self.axis = .vertical
        self.distribution = .fillEqually
        self.alignment = .fill
        self.spacing = 8
    }
    
    /// initialization for vertical stack 'axis -> vertical', 'distribution -> fill', 'alignment -> fill' and spacing -> 10
    func configureVstack() {
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = 10
    }
}

extension UILabel {
    /// create custom Lable
    /// - Parameters:
    ///   - text: set initiale text, this value change latter
    ///   - color: set the textColor, not change latter
    func DNLabel(text: String, fontSize: CGFloat = 14, color: UIColor, align: NSTextAlignment = .left, withBorder: Bool = true) -> UILabel {
        let lb = UILabel()
        lb.text = text
        lb.backgroundColor = .white
        lb.textColor = color
        lb.font = UIFont.DN.Regular.font(size: fontSize)
        lb.textAlignment = align
        if withBorder {
            lb.layer.borderColor = UIColor.DN.LightGray.color().cgColor
            lb.layer.borderWidth = 0.5
        }
        return lb
    }
}
