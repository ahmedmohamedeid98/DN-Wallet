//
//  NotificationCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 5/26/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    
    //MARK:- Properities
    static let reuseIdentifier = "notification-cell-identifier"
    var data: Message? {
        didSet {
            guard  let safeData = data else { return }
            self.senderLabel.text = safeData.sender
            self.contentMsg.text = safeData.body
            self.dateLabel.text = "Data: \(safeData.date)"
            self.notificationType.text = safeData.type
            if isFirstTime {
                self.newLabel.isHidden = !safeData.isnew
                self.isNew = safeData.isnew
                isFirstTime = false
            }
            
        }
    }
    private var isFirstTime: Bool = true
    var isNew: Bool = false
    //MARK:- Outlets
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var contentMsg: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notificationType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newLabel.layer.cornerRadius = 11
        newLabel.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
