//
//  DonationDetailsCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 5/29/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DonationDetailsCell: UITableViewCell {

    static let reuseIdentifier = "donation-details-cell-identifier"
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
