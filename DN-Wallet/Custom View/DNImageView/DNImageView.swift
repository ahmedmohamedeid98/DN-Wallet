//
//  SAImage.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 6/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

class DNImageView: UIImageView {
    
    var roundImageWithHeight: CGFloat = 20.0 {
        didSet {
            self.layer.cornerRadius = roundImageWithHeight / 2
        }
    }
    var systemTitle: String? {
        didSet {
            guard let title = systemTitle else { return }
            self.image = UIImage(systemName: title)
        }
    }
    var assetsTitle: String? {
        didSet {
            guard let title = assetsTitle else { return }
            self.image = UIImage(named: title)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(title: String? = nil, tintColor: UIColor = .white, contentMode: UIView.ContentMode = .scaleAspectFit, isSystemImage: Bool = true) {
        self.init(frame: .zero)
        self.contentMode = contentMode
        self.tintColor = tintColor
        if let imageTitle = title {
            self.image = isSystemImage ? UIImage(systemName: imageTitle) : UIImage(named: imageTitle)
        }

    }
    
    private func configure() {
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
