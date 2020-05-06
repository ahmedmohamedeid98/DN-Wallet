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
    @IBOutlet weak var checkBox: UIButton!
    var credit_Id: String = ""
    var cellDelegate: SelectedCardDelegate?
    var currentIndexPath: IndexPath!
    var toggle: Bool = true
    
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
    
    @IBAction func checkBoxBtnPressed(_ sender: UIButton) {
        checkBoxToggle()
    }
    
    func checkBoxToggle() {
        if toggle {
           // checkBox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            //toggle = false
            cellDelegate?.selectedCreditCard(id: credit_Id, currentIndex: currentIndexPath)
            
        } else {
            checkBox.setImage(UIImage(systemName: "circle"), for: .normal)
            toggle = true
            cellDelegate?.freeLastSelectedIndexPath()
        }
    }
}
