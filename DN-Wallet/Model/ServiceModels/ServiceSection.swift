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
            guard let vc = st.instantiateViewController(identifier: "historyVCID") as? HistoryVC else { return }
            self.present(viewController: vc, from: viewController)
        case .sendMoney:
            print("send money")
        case .sendRequest:
            print("send request")
        case .exchangeCurrency:
            let vc = ExchangeCurrencyVC()
            self.present(viewController: vc, from: viewController)
        case .myConcats:
            let vc = MyContactsVC()
            self.present(viewController: vc, from: viewController)
        case .addNewPaymentCard:
            let vc = AddNewCardVC()
            self.present(viewController: vc, from: viewController)
        case .donation:
            let vc = DonationVC()
            self.present(viewController: vc, from: viewController)
        }
    }
    
    var id: Int {
        return self.rawValue
    }
    
    func present(viewController: UIViewController, from: UIViewController) {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.modalPresentationStyle = .fullScreen
        from.present(navigation, animated: true, completion: nil)
    }
}
