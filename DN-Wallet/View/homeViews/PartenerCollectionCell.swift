//
//  PartenerCollectionCell.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/16/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class PartenerCollectionCell: UICollectionViewCell {

    static let identifier = "PartenerCollectionCell"
    @IBOutlet weak var imageView: UIImageView!
    
    var data: Partener? = nil {
        didSet {
            guard let partener = data else { return }
            self.imageView.image = UIImage(named: partener.imageName)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PartenerCollectionCell", bundle: nil)
    }

}
