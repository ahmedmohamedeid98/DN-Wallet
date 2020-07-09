//
//  UserHistoryCell.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

protocol UserHistoryCellProtocol: class {
    func detailsAction(action: UserHistoryCellDetailsAction)
}

enum UserHistoryCellDetailsAction {
    case consumptionAction
    case recievedAction
    case dontationAction
}

enum UserHistoryCellColor {
    case recievedColor
    case consumptionColor
    case donationsColor
    
    var color: UIColor {
        switch self {
            case .consumptionColor: return .red
            case .recievedColor: return #colorLiteral(red: 0.2274509804, green: 0.6862745098, blue: 0.2666666667, alpha: 1)
            case .donationsColor: return #colorLiteral(red: 0.1782214642, green: 0.4982336164, blue: 0.757638514, alpha: 1)
        }
    }
}


class UserHistoryCell: UICollectionViewCell {
    @IBOutlet private weak var transactionAmountLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var detailsButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    weak var delegate:UserHistoryCellProtocol?
    
    static let identifier = "cell-identifier"
    var data: UserHistorySectionProtocol? {
        didSet {
            guard let safeData = data else { return }
            self.descriptionLabel.text       = safeData.description
            self.categoryLabel.text          = safeData.title
            self.categoryLabel.textColor     = safeData.category.color
            self.transactionAmountLabel.textColor = safeData.category.color
            self.containerView.layer.shadowColor = safeData.category.color.cgColor
        }
    }
    
    var transactionAmount: Double? = nil {
        didSet {
            guard let amount = transactionAmount else { return }
            self.transactionAmountLabel.text = "\(amount)$"//String(format: "%i.%02$", arguments: [amount])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    
    private func configureCell() {
        // container view
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowOffset = CGSize(width: 0.1, height: 0.1)
        containerView.layer.shadowRadius = 12.0
        containerView.layer.shadowOpacity = 0.16
        
        // details button
        detailsButton.layer.cornerRadius = detailsButton.frame.size.height / 2
        
    }
    
    @IBAction func detailsButtonAtction(_ sender: UIButton) {
        guard let currentData = data else { return }
        if let delegate  = delegate {
            delegate.detailsAction(action: currentData.action)
        }
    }
    
}
