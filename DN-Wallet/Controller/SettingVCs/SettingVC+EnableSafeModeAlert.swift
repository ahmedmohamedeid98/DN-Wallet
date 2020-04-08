//
//  SettingVC+EnableSafeModeAlert.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/8/20.
//  Copyright © 2020 DN. All rights reserved.
//
extension SettingVC: SafeModeAlert {
    
    func showSafeModeAlert(completion: @escaping (Bool) -> ()) {
            
            let alert = UIAlertController(title: "By Activate \"Safe Mode\" You Accept to Stop Some Service For Specific Time.", message: "Send Money, Send Request, Withdraw Money will be Stopped. Pay From Purchases Will be Limited.", preferredStyle: .alert)
            let Cancle = UIAlertAction(title: "Cancle", style: .cancel) { (action) in
                completion(false)
            }
            let Continue = UIAlertAction(title: "Continue", style: .default) { (action) in
                completion(true)
            }
            
            alert.addAction(Cancle)
            alert.addAction(Continue)
            self.present(alert, animated: true, completion: nil)
    }
}
