//
//  BalancePro.swift
//  DN-Wallet
//
//  Created by Mac OS on 8/10/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

class BalancePro {
    
    var auth: UserAuthProtocol = UserAuth()
    var userBalance: [Balance] = []
    var errorMessage: String?
    var balance: Balance!
    
    init(userBalance: [Balance]) {
        self.userBalance = userBalance
    }
    
    private func getActualBalance(currencyCode: String) -> Balance {
        let balance = userBalance.filter { $0.currency_code == currencyCode }
        return balance.first ?? Balance(amount: "0", currency_code: currencyCode)
        
        
    }
    
    private func updateAllowedAmountInSafeMode(enteredBalance: Balance) {
        if auth.isAppInSafeMode {
            auth.allowedAmountInSafeMode = auth.allowedAmountInSafeMode - (Int(enteredBalance.amount) ?? 0)
        }
    }
    
    private func vaildBalance(balance: Balance)-> Bool {
        if auth.isAppInSafeMode {
            return Int(balance.amount) ?? 0 <= auth.allowedAmountInSafeMode
        } else {
            let actualBalance = getActualBalance(currencyCode: balance.currency_code)
            return balance.amount <= actualBalance.amount
        }
    }
    
    // Method We Concerned
    func canMakeTransactionOn(amount: String?, code: String?) -> Bool {
        
        guard let balance = validInput(amount, code: code) else { return false }
        self.balance = balance

        if vaildBalance(balance: balance) {
            updateAllowedAmountInSafeMode(enteredBalance: balance)
            return true
        }
        else {
            
            if auth.isAppInSafeMode {
                self.errorMessage = "Enter amount [ \(balance.amount) \(balance.currency_code) ] greater than your balance amount which allowed in safe mode."
                return false
            }
            let actBalance = getActualBalance(currencyCode: balance.currency_code)
            self.errorMessage = "Entered amount is [ \(balance.amount) \(balance.currency_code) ] greate than your current balance [ \(actBalance.amount) \(actBalance.currency_code)]."
            return false
            
        }
    }
    
    private func validInput(_ amount: String?, code: String?) -> Balance? {
        
        guard let safeAmount = amount, !safeAmount.isEmpty else {
            self.errorMessage = "Please enter an amount. and Try again."
            return nil
        }
        
        guard let safeCode = code, !safeCode.isEmpty else {
            self.errorMessage = "Please choose a currency. and Try again"
            return nil
        }
        
        return Balance(amount: safeAmount, currency_code: safeCode)
    }
    
}
