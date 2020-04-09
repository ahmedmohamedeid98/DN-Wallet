//
//  ServiceSection.swift
//  DN-Wallet
//
//  Created by Ahemd Eid on 4/9/20.
//  Copyright © 2020 DN. All rights reserved.
//

enum ServiceSection: Int, CaseIterable, CustomStringConvertible {
    case history
    case sendMoney
    case sendRequest
    case exchangeCurrency
    //case withdrawMoney
    case myConcats
    case addNewPaymentCard
    case donation
    
    var description: String {
        switch self {
        case .history: return "History"
        case .sendMoney: return "Send Money"
        case .sendRequest: return "Send Request"
        case .exchangeCurrency: return "Exchange Currency"
        //case .withdrawMoney: return "Withdraw Money"
        case .myConcats: return "My Contacts"
        case .addNewPaymentCard: return "Add new Payment Card"
        case .donation: return "Donation"
        }
    }
    
    var image: String {
        switch self {
        case .history: return "history"
        case .sendMoney: return "send"
        case .sendRequest: return "send_request"
        case .exchangeCurrency: return "exchange_currency"
        //case .withdrawMoney: return "withdraw"
        case .myConcats: return "My Contacts"
        case .addNewPaymentCard: return "Add new Payment Card"
        case .donation: return "Donation"
        }
    }
    
    var sysImage: Bool {
        switch self {
        case .history: return false
        case .sendMoney: return false
        case .sendRequest: return false
        case .exchangeCurrency: return false
        //case .withdrawMoney: return false
        case .myConcats: return false
        case .addNewPaymentCard: return false
        case .donation: return false
        }
    }
    
    func presentViewController(from viewController: UIViewController) {
        switch self {
        case .history:
            let st = UIStoryboard(name: "Services", bundle: .main)
            let historyVC = st.instantiateViewController(identifier: "historyVCID") as? HistoryVC
            guard let vc = historyVC else { return }
            vc.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: true, completion: nil)
        case .sendMoney:
            print("send money")
        case .sendRequest:
            print("send request")
        case .exchangeCurrency:
            let vc = ExchangeCurrencyVC()
            vc.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: true, completion: nil)
        //case .withdrawMoney:  print("withdraw")
        case .myConcats:
            let vc = MyContactsVC()
            vc.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: true, completion: nil)
        case .addNewPaymentCard:
            let vc = AddNewCardVC()
            vc.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: true, completion: nil)
        case .donation:
            let vc = DonationVC()
            vc.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: true, completion: nil)
        }
    }
    
    var id: Int {
        return self.rawValue
    }
}
