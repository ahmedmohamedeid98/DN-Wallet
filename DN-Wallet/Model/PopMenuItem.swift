//
//  PopMenuItem.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 5/2/20.
//  Copyright © 2020 DN. All rights reserved.
//


struct PopMenuItem: Hashable {
    let image: UIImage?
    let title: String
    let code: String?
    
    let identifier: UUID = UUID()
    static func == (lhs: PopMenuItem, rhs: PopMenuItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
}
