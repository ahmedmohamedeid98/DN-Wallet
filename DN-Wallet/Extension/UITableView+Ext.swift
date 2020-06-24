//
//  UITableView+Ext.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

extension UITableView {
    func updateRowWith(indexPaths: [IndexPath], animate: UITableView.RowAnimation) {
            self.beginUpdates()
            self.reloadRows(at: indexPaths, with: animate)
            self.endUpdates()
    }
}
