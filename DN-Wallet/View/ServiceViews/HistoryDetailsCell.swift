//
//  HistoryDetailsCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 6/8/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class HistoryDetailsCell: UITableViewCell {

    static let reuseIdentifier = "history-reuse-cell-id"
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configureCell(email: String, amount: String, date: String) {
        self.emailLabel.text = email
        self.amountLabel.text = amount
        self.dateLabel.text = date
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        lb.backgroundColor = .clear
        lb.textColor = color
        lb.font = UIFont.DN.Regular.font(size: fontSize)
        lb.textAlignment = align
        if withBorder {
            lb.layer.borderColor = UIColor.DnGrayColor.cgColor
            lb.layer.borderWidth = 0.5
        }
        return lb
    }
}

