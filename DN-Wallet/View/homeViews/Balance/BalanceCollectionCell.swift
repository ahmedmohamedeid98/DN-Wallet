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
    @IBOutlet weak var containerView: UIView!
    
    var data: Balance? = nil {
        didSet {
            guard let balance = data else { return }
            amountLabel.text = String(format: "%i.%02i", arguments: [Int(balance.amount) ?? 0, 0])//amount*100.truncatingRemainder(dividingBy: 100)
            currencyCodeLabel.text = balance.currency_code
        }
    }
    
    fileprivate func configureContainerView() {
        containerView.layer.cornerRadius    = 4
        containerView.layer.shadowColor     = UIColor.label.cgColor
        containerView.layer.shadowOffset    = CGSize(width: 0.26, height: 0.26)
        containerView.layer.shadowOpacity   = 0.26
        containerView.layer.shadowRadius    = 4
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //configureContainerView()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "BalanceCollectionCell", bundle: nil)
    }

}
