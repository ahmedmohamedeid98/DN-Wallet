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
//    var cellDelegate: SelectedCardDelegate?
//    var currentIndexPath: IndexPath!
//    var toggle: Bool = true
    
    var data: CardInfo? {
        didSet {
            guard let mydata = data else {return}
            print("mydata: \(mydata)")
            self.creditName.text = mydata.name
            self.creditNumber.text = "\(mydata.type) ****\(mydata.digits)"
            self.credit_Id = mydata.id
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("cell init coder")
    }
    
    
    func checkBoxToggle(check: Bool = true) {
        if check {
            checkBox.image = UIImage(systemName: "checkmark.fill.circle")
        } else {
            checkBox.image = UIImage(systemName: "checkmark.fill.circle")
        }
    }
}
