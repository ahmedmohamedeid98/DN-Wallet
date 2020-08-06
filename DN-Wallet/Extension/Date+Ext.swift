//
//  Date+Ext.swift
//  DN-Wallet
//
//  Created by Mac OS on 8/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

extension Date {
    
    func convertDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd' 'HH:mm:ssZ"
        return dateFormatter.string(from: self)
    }
    
}
