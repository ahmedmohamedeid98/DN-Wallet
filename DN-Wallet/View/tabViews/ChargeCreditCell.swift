//
//  ChargeCreditCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 5/5/20.
//  Copyright © 2020 DN. All rights reserved.
//
protocol SelectedCardDelegate {
    func selectedCreditCard(id: String, currentIndex: IndexPath)
    func freeLastSelectedIndexPath()
}

class ChargeCreditCell: UITableViewCell {
    
    static let reuseIdentifier = "credit-cell-identifie"
    
    @IBOutlet weak var creditLogo: UIImageView!
    @IBOutlet weak var creditName: UILabel!
    @IBOutlet weak var creditNumber: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    var credit_Id: String = ""

    
    var data: CardInfo? {
        didSet {
            guard let mydata = data else {return}
            self.creditName.text = mydata.name
            self.creditNumber.text = "\(mydata.type) ****\(mydata.last4digits)"
            self.credit_Id = mydata.id
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    
    func checkBoxToggle(check: Bool = true) {
        if check {
            checkBox.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            checkBox.image = UIImage(systemName: "circle")
        }
    }
}
