//
//  SliderCell.swift
//  DN-Wallet
//
//  Created by Mac OS on 4/15/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SliderCell: UICollectionViewCell {
 
    static let reuseIdentifier = "slider-cell-identifier"
    
    let image: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    var data: String? {
        didSet{
            guard let imageName = data else {return}
            self.image.image = UIImage(named: imageName)
        }
    }
    
    func setupLayout() {
        addSubview(image)
        image.DNLayoutConstraint(topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
