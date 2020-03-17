//
//  consumptionCell.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/13/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class HistoryDetailsCell: UITableViewCell {
    

    private let to: UILabel = {
       let lb = UILabel()
        lb.text = "Email"
        lb.configureLabel()
        return lb
    }()
    
    private let amount: UILabel = {
       let lb = UILabel()
        lb.text = "Amount"
        lb.configureLabel()
        return lb
    }()
    
    private let date: UILabel = {
       let lb = UILabel()
        lb.text = "Date"
        lb.configureLabel()
        return lb
    }()
    
    var toEmail: UILabel = {
       let lb = UILabel()
        lb.text = "alg2154@gmail.com"
        lb.configureLabel()
        return lb
    }()
    
    
    var amountNumber: UILabel = {
       let lb = UILabel()
        lb.text = "25$"
        lb.configureLabel()
        return lb
    }()
    
    var dateValue: UILabel = {
       let lb = UILabel()
        lb.text = "21/7/2020"
        lb.configureLabel()
        return lb
    }()
    var stackContrainer = UIView()
    
    func setupStackContainerShadow() {
        stackContrainer.layer.cornerRadius = 5.0
        stackContrainer.layer.shadowOpacity = 1.0
        stackContrainer.layer.shadowColor = UIColor.black.cgColor
        stackContrainer.layer.shadowOffset = CGSize(width: -1, height: 1)
        stackContrainer.layer.masksToBounds = false
        stackContrainer.layer.shadowRadius = 3.0
        stackContrainer.layer.shouldRasterize = true
    }
    
    
    func setupStackView() {
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
    
    func configureCell(email: String, amount: String, date: String) {
        self.toEmail.text = email
        self.amountNumber.text = amount
        self.dateValue.text = date
    }
    
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

extension UILabel {
    func configureLabel() {
        self.textColor = .black
        self.font = UIFont.DN.Regular.font(size: 14)
        self.textAlignment = .left
        self.layer.borderColor = UIColor.DN.LightGray.color().cgColor
        self.layer.borderWidth = 0.5
    }
}

extension UIStackView {
    func configureHstack() {
        self.axis = .vertical
        self.distribution = .fillEqually
        self.alignment = .fill
        self.spacing = 8
    }
    
    func configureVstack() {
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = 10
    }
}
