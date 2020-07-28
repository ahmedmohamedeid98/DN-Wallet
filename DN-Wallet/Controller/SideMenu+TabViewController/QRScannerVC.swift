//
//  QRScannerVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 4/20/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class QRScannerVC: UIViewController {
    // get this data from payVC
    var amount: Double = 0.00
    var currency = "EGP"//: Currency = UserPreference.defaultCurrency
    var currendDate: String = ""
    
    var scannerView: QRScannerView!
    var qrData: String? = nil {
        didSet {
            guard let email = qrData else {return}
            // 2. show alert to infor user that he will transfer amount to this email.
            let msg = "transfer amount: \(amount) \(currency) to \nthe following email\n\(email)"
            transactionAmountAndShowAlert(amount: amount, email: email, title: nil, msg: msg)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
    }
    
    func setupScannerView(){
        scannerView = QRScannerView()
        view.addSubview(scannerView)
        scannerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scannerView.delegate = self
    }
    
    func transactionAmountAndShowAlert(amount: Double, email: String, title: String?, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let accept = UIAlertAction(title: "Accept", style: .default) { (action) in
            // try to send money to the user email
            /*
            NetworkManager.transactionAmount(amount, to: email) { (success, error) in
                if success {
                    Alert.asyncSuccessfullWith("Successful transaction process", dismissAfter: 1.0, viewController: self)
                    let detail = HistoryCategory(email: email,
                                                 amount: amount,
                                                 currency: "EGP",
                                                 date: Utile.currentDate,
                                                 category: Category.send.identifier,
                                                 innerCategory: InnerCategory.other.identitfer)
                    NetworkManager.addTransactionToHistoryWith(details: detail) { (success, error) in
                        if success {
                            // do nothing
                        }else {
                            Alert.asyncActionOkWith("Error", msg: "faild to add this transaction to the histoy.", viewController: self)
                        }
                    }
                }else {
                    Alert.asyncActionOkWith("Error", msg: "faild transaction process.", viewController: self)
                }
            }
 */
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(accept)
        present(alert, animated: true, completion: nil)
    }
}
extension QRScannerVC: QRScannerViewDelegate {
    
    func qrScanningDidFail() {
        self.presentDNAlertOnTheMainThread(title: "Failure", Message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = str
    }
    
    func qrScanningDidStop() {
        //code 
    }
    
    
}
