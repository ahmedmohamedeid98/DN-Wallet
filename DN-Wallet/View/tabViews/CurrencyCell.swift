//
//  HomeCurrencyCell.swift
//  DN-Wallet
//
//  Created by Mac OS on 4/14/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class CurrencyCell: UICollectionViewCell {
    
    static let reuseIdentifier = "currency-cell-identifier"
    
    var data: Balance? {
        didSet {
            guard let balance = data else {return}
            currencyLabel.text = balance.currency//DNData.symboleFromString(str: balance.currency)
            amountLabel.text = String(format: "%.2f", balance.amount)
        }
    }
    
    let currencyLabel : UILabel = {
        let lb = UILabel()
        lb.basicConfigure(fontSize: 16)
        lb.textAlignment = .center
        return lb
    }()
    
    let seperatorLine: UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.DN.LightBlue.color()
        return vw
    }()
    
    let amountLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .DnDarkBlue
        lb.textAlignment = .center
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    func setupLayout() {
        addSubview(currencyLabel)
        addSubview(seperatorLine)
        addSubview(amountLabel)

        amountLabel.DNLayoutConstraint(topAnchor, left: leftAnchor , bottom: bottomAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 120, height: 0))
        seperatorLine.DNLayoutConstraint(topAnchor, left: amountLabel.rightAnchor, right: nil, bottom: bottomAnchor, margins: UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 0), size: CGSize(width: 1, height: 0))
        currencyLabel.DNLayoutConstraint(topAnchor, left: seperatorLine.rightAnchor, right: rightAnchor, bottom: bottomAnchor)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        self.backgroundColor = .white
        self.addShadow(color: UIColor.darkGray.cgColor, opacity: 0.6, offset: CGSize(width: 0.5, height: 1), redius: 0)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
