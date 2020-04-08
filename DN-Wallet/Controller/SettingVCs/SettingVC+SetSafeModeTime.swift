//
//  SettingVC+SetSafeModeTime.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/8/20.
//  Copyright © 2020 DN. All rights reserved.
//

extension SettingVC {
    
    func setSafeModeTimeAlert() {
        let alert = UIAlertController(title: "Safe Mode Time", message: "Set safe mode time in (Hours) , we recommend you that time be at least 12 hours.", preferredStyle: .alert)
        let setAction = UIAlertAction(title: "Set", style: .default) { (action) in
            if let hours = alert.textFields![0].text {
                print("hours: \(hours) ")
                Auth.shared.setSafeModeTime(hours: hours)
                self.settingTable.updateRowWith(indexPaths: [SecurityOptions.safeModeTime.indexPath], animate: .fade)
            }
        }
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (txt) in
            txt.font = UIFont.DN.Regular.font(size: 16)
            txt.stopSmartActions()
            txt.keyboardType = .numberPad
            txt.placeholder = "e.g: 12"
        }
        
        alert.addAction(Cancel)
        alert.addAction(setAction)
        present(alert, animated: true, completion: nil)
    }
    
}
