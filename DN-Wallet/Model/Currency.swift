//
//  Currency.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/17/20.
//  Copyright © 2020 DN. All rights reserved.
//

/// Enum contain the supported currency in the the app
enum Currency {

    case EGP // Egyptian Pound
    case EUR // Euro
    case USD // US Dollar
    case HKD // Hong Kong Dollar
    case INR // Indian Rupee
    case IDR // Rupiah
    case ISK // Iceland Krona
    case IQD // Iraqi Dinar
    case JPY // Yen
    case KWD // Kuwaiti Dinar
    case KRW // Won
    case AUD // Australian Dollar
    case LYD // Libyan Dinar
    case OMR // Rial Omani
    case PKR // Pakistan Rupee
    case QAR // Qatari Rial
    case RUB // Russian Ruble
    case SAR // Saudi Riyal
    case TRY // Turkish Lira
    case TND // Tunisian Dinar
    case YER // Yemeni Rial
    
    /// return the symbole of specific currency based on the code of currency
    func symbole() -> String? {
        let code = "\(self)"
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
    
    
}
