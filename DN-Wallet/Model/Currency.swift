//
//  Currency.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/17/20.
//  Copyright © 2020 DN. All rights reserved.
//

/// Enum contain the supported currency in the the app
enum Currency: String, CaseIterable {

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
    var symbole: String {
        let code = "\(self)"
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code) ?? "\(self)"
    }
    
    var Code: String {
        return self.rawValue
    }
    
    var description: String {
        switch self {
            case .EGP: return "Egyptian Pound"
            case .EUR: return "Euro"
            case .USD: return "US Dollar"
            case .HKD: return "Hong Kong Dollar"
            case .INR: return "Indian Rupee"
            case .IDR: return "Rupiah"
            case .ISK: return "Iceland Krona"
            case .IQD: return "Iraqi Dinar"
            case .JPY: return "Yen"
            case .KWD: return "Kuwaiti Dinar"
            case .KRW: return "Won"
            case .AUD: return "Australian Dollar"
            case .LYD: return "Libyan Dinar"
            case .OMR: return "Rial Omani"
            case .PKR: return "Pakistan Rupee"
            case .QAR: return "Qatari Rial"
            case .RUB: return "Russian Ruble"
            case .SAR: return "Saudi Riyal"
            case .TRY: return "Turkish Lira"
            case .TND: return "Tunisian Dinar"
            case .YER: return "Yemeni Rial"
        }
    }
    
}
