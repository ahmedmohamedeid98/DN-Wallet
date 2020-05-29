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
    
    var isSafe: Bool {
        switch self {
            case .history: return false
            case .sendMoney: return true
            case .sendRequest: return true
            case .exchangeCurrency: return false
            case .myConcats: return false
            case .addNewPaymentCard: return false
            case .donation: return true
        }
    }
    
    func pushVC(from rootVC: UIViewController) {
        let st = UIStoryboard(name: "Services", bundle: .main)
        switch self {
        case .history:
            guard let vc = st.instantiateViewController(identifier: "historyVCID") as? HistoryVC else { return }
            present(vc, from: rootVC)
        case .sendMoney:
            guard let vc = st.instantiateViewController(identifier: "sendAndRequestVC") as? SendAndRequestMoney else { return }
            present(vc, from: rootVC)
        case .sendRequest:
            guard let vc = st.instantiateViewController(identifier: "sendAndRequestVC") as? SendAndRequestMoney else { return }
            vc.isRequest = true
            present(vc, from: rootVC)
        case .exchangeCurrency:
            let vc = ExchangeCurrencyVC()
            present(vc, from: rootVC)
        case .myConcats:
            let vc = MyContactsVC()
            present(vc, from: rootVC)
        case .addNewPaymentCard:
            let vc = AddNewCardVC()
            present(vc, from: rootVC)
        case .donation:
            let vc = DonationVC()
            present(vc, from: rootVC)
        }
    }
    
    private func present(_ vc: UIViewController, from rootVC: UIViewController) {
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        rootVC.present(navController, animated: true, completion: nil)
    }
}
