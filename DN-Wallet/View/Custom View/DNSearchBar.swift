//
//  DNSearchBar.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNSearchBar: UISearchBar {

    var originDataSource: [AnyObject] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
    

}
