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
    var balance: Balance!
    
    var scannerView: QRScannerView!
    var topView = UIView()
    var leftView = UIView()
    var rightView = UIView()
    var bottomView = UIView()
    
    var qrData: String? = nil {
        didSet {
            guard let email = qrData else {return}
            let msg = "You Accept transfer [ \(balance.amount) \(balance.currency_code) ] to the next email [\(email)]."
            transactionAmountAndShowAlert(data: balance, email: email, title: "Confirmation", msg: msg)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        navigationController?.navigationBar.tintColor = .white
        setupScannerView()
        setupAssetViews()
    }
    
    func setupScannerView(){
        scannerView = QRScannerView()
        view.addSubview(scannerView)
        scannerView.DNLayoutConstraintFill(withSafeArea: true)
        scannerView.delegate = self
    }
    
    func setupAssetViews() {
        let bgColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)
        topView.backgroundColor = bgColor
        leftView.backgroundColor = bgColor
        rightView.backgroundColor = bgColor
        bottomView.backgroundColor = bgColor
        
        scannerView.addSubview(topView)
        scannerView.addSubview(leftView)
        scannerView.addSubview(rightView)
        scannerView.addSubview(bottomView)
        
        topView.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: view.frame.size.height / 4))
        bottomView.DNLayoutConstraint(left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, size: CGSize(width: 0, height: view.frame.size.height / 4))
        leftView.DNLayoutConstraint(topView.bottomAnchor, left: view.leftAnchor, bottom: bottomView.topAnchor, size: CGSize(width: view.frame.size.width/5, height: 0))
        rightView.DNLayoutConstraint(topView.bottomAnchor, right: view.rightAnchor, bottom: bottomView.topAnchor, size: CGSize(width: view.frame.size.width/5, height: 0))
    }
    
    func transactionAmountAndShowAlert(data: Balance, email: String, title: String?, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let accept = UIAlertAction(title: "Accept", style: .default) { (action) in
            self.transfer(amount: data.amount, code: data.currency_code, to: email)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(accept)
        present(alert, animated: true, completion: nil)
    }
}
extension QRScannerVC: QRScannerViewDelegate {
    
    func qrScanningDidFail() {
        self.presentAlertOnTheMainThread(title: "Failure", Message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = str
    }
    
    func qrScanningDidStop() {
        self.presentAlertOnTheMainThread(title: "Stopped", Message: "Scanner was stopped. Please try again")
    }
}

 // Networking
extension QRScannerVC {
    
    func transfer(amount: String, code: String, to email: String) {
        Hud.showLoadingHud(onView: view, withLabel: "Paying...")
        TransferManager.shared.transfer(withData: Transfer(amount: amount, currency_code: code), email: email) { result in
            Hud.hide(after: 0)
            switch result {
                case .success(let res): self.transferSuccessCase(msg: res.success)
                case .failure(let err): self.transferFailureCase(msg: err.localizedDescription)
            }
        }
    }
    
    private func transferSuccessCase(msg: String) {
        self.presentAlertOnTheMainThread(title: "Success", Message: msg + ", your request may take from 10 - 30 seconds to confirmed.")
        NotificationCenter.default.post(name: NSNotification.Name("BALANCEWASUPDATED"), object: nil)
    }
    
    private func transferFailureCase(msg: String) {
        self.presentAlertOnTheMainThread(title: "Failure", Message: msg)
    }
    
}
