//
//  DNAvatarImageView.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNAvatarImageView: UIImageView {

    let placeholder = UIImage(named: "avatar-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    
    private func configure() {
        layer.cornerRadius  = 10.0
        clipsToBounds       = true
        image               = placeholder
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downlaodedImage(from urlString: String) {
        ImageLoader.shared.loadImageWithStrURL(str: urlString) { result in
            switch result {
                case .success(let img):
                    DispatchQueue.main.async { self.image = img }
                case .failure(_):
                    break
            }
        }
    }

}
