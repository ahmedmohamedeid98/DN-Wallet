//
//  HomeCurrencyCell.swift
//  DN-Wallet
//
//  Created by Mac OS on 4/14/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class HomeCurrencyCell: UICollectionViewCell {
    
    var data: Balance? {
        didSet {
            guard let balance = data else {return}
            currencyLabel.text = DNData.symboleFromString(str: balance.currency)
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
        lb.basicConfigure(fontSize: 16)
        lb.textAlignment = .center
        return lb
    }()
    
    func setupLayout() {
        let width = self.frame.width
        let container = UIView()
        container.addSubview(currencyLabel)
        container.addSubview(seperatorLine)
        container.addSubview(amountLabel)
        currencyLabel.DNLayoutConstraint(container.topAnchor, left: container.leftAnchor, right: nil, bottom: container.bottomAnchor, size: CGSize(width: width / 3, height: 0))
        seperatorLine.DNLayoutConstraint(container.topAnchor, left: currencyLabel.rightAnchor, right: nil, bottom: container.bottomAnchor, margins: UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 0), size: CGSize(width: 1, height: 0))
        amountLabel.DNLayoutConstraint(container.topAnchor, left: seperatorLine.rightAnchor , right: container.rightAnchor, bottom: container.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0))
        addSubview(container)
        container.DNLayoutConstraintFill(top: 0, left: 4, right: 4, bottom: 0, withSafeArea: false)
        //container.addBorder()
        container.backgroundColor = .green
        container.addShadow(color: UIColor.lightGray.cgColor, opacity: 0.4, offset: CGSize(width: 1, height: 1), redius: 2)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        self.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
