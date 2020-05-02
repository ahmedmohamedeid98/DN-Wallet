//
//  DNGradient.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/30/20.
//  Copyright © 2020 DN. All rights reserved.
//

class DNGradient: UIView {
    var topColor: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    var bottomColor: UIColor = #colorLiteral(red: 0.167981714, green: 0.6728672981, blue: 0.9886779189, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let layer = self.layer as? CAGradientLayer {
            self.translatesAutoresizingMaskIntoConstraints = false
            layer.colors = [topColor.cgColor, bottomColor.cgColor]
            layer.locations = [0.0, 1.2]
        }
        
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
