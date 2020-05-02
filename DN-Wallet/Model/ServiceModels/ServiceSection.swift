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
    case myConcats
    case addNewPaymentCard
    case donation
    
    var description: String {
        switch self {
        case .history: return "History"
        case .sendMoney: return "Send Money"
        case .sendRequest: return "Send Request"
        case .exchangeCurrency: return "Exchange Currency"
        case .myConcats: return "My Contacts"
        case .addNewPaymentCard: return "Add new creditcard"
        case .donation: return "Donation"
        }
    }
    
    var image: String {
        switch self {
        case .history: return "history_white_24"
        case .sendMoney: return "send_white_24"
        case .sendRequest: return "square.and.pencil"
        case .exchangeCurrency: return "arrow.2.circlepath"
        case .myConcats: return "person.2.fill"
        case .addNewPaymentCard: return "creditcard.fill"
        case .donation: return "heart.fill"
        }
    }
    
    var sysImage: Bool {
        switch self {
        case .history: return false
        case .sendMoney: return false
        case .sendRequest: return true
        case .exchangeCurrency: return true
        case .myConcats: return true
        case .addNewPaymentCard: return true
        case .donation: return true
        }
    }
    
    func presentViewController(from viewController: UIViewController) {
        switch self {
        case .history:
            let st = UIStoryboard(name: "Services", bundle: .main)
            guard let vc = st.instantiateViewController(identifier: "historyVCID") as? HistoryVC else { return }
            self.present(viewController: vc, from: viewController)
        case .sendMoney:
            let vc = SendAndRequestMoney()
            self.present(viewController: vc, from: viewController)
        case .sendRequest:
            let vc = SendAndRequestMoney()
            vc.isRequest = true
            self.present(viewController: vc, from: viewController)
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
    
    func present(viewController: UIViewController, from: UIViewController) {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.modalPresentationStyle = .fullScreen
        from.present(navigation, animated: true, completion: nil)
    }
}
