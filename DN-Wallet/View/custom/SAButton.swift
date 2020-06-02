//
//  SAButton.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 6/2/20.
//  Copyright © 2020 DN. All rights reserved.
//
protocol SAButtonDelegate: class {
    func sAButtonWasPressed(buttonId: Int)
}


final class SAButton: UIButton {
    
    var withTarget:(()->())?
    var setCornerRadiusWithHeight: CGFloat = 20.0 {
        didSet {
            self.layer.cornerRadius = setCornerRadiusWithHeight / 2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(backgroundColor: UIColor, title: String, systemTitle: String? = nil, assetsTitle: String? = nil) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.setSAImage(systemTitle: systemTitle, assestTitle: assetsTitle)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 20
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        setTitleColor(.white, for: .normal)
        tintColor = .white
        addTarget(self, action: #selector(SAButtonWasPressed), for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func setSAImage(systemTitle: String?, assestTitle: String?) {
        if let title = systemTitle {
            self.setImage(UIImage(systemName: title), for: .normal)
        }
        if let title = assestTitle {
            self.setImage(UIImage(named: title), for: .normal)
        }
    }
    
    @objc func SAButtonWasPressed() {
        UIView.animate(withDuration: 0.1, delay:0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (_) in
                self.withTarget?()
            }
        }
    }
    
    
    
    
    
}
