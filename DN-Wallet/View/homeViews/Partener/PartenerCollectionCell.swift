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
    var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.backgroundColor = .red
        return imgView
    }()
    
    var data: Partener? = nil {
        didSet {
            guard let partener = data else { return }
            self.imageView.image = UIImage(named: partener.imageName)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(imageView)
        imageView.DNLayoutConstraintFill()
    }
}
