//
//  BalanceCollectionCell.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/16/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class BalanceCollectionCell: UICollectionViewCell {

    static let identifier = "BalanceCollectionCell"
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    
    var data: Balance? = nil {
        didSet {
            guard let balance = data else { return }
            amountLabel.text = balance.stringAmount(amount: balance.amount)
            currencyCodeLabel.text = balance.currency
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "BalanceCollectionCell", bundle: nil)
    }

}
