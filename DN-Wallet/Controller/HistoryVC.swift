//
//  HistoryVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/13/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {

    
    @IBOutlet weak var consumptionsAmount: UILabel!
    @IBOutlet weak var receivedAmount: UILabel!
    @IBOutlet weak var donationsAmount: UILabel!
    
    var CONPurachesData: [HCard] = [
    HCard(email: "ahmed21@gmail.com", amount: "25", currancy: 1),
    HCard(email: "yasser@yahoo.com", amount: "254", currancy: 0),
    HCard(email: "fouad@ama.eg.com", amount: "45", currancy: 0),
    HCard(email: "ddfa@gmail.com", amount: "48", currancy: 2)
    ]
    var CONIndividuals: [HCard] = [
    HCard(email: "Mohamed@gmail.com", amount: "25", currancy: 1),
    HCard(email: "Mohamed@yahoo.com", amount: "254", currancy: 0),
    HCard(email: "Mohamed@ama.eg.com", amount: "45", currancy: 0)
    ]
    var SENSales: [HCard] = [
    HCard(email: "EID@gmail.com", amount: "25", currancy: 1),
    HCard(email: "EID@yahoo.com", amount: "254", currancy: 0),
    HCard(email: "EID@ama.eg.com", amount: "45", currancy: 0),
    HCard(email: "EID@gmail.com", amount: "48", currancy: 2)
    ]
    var SENIndividals: [HCard] = [
    HCard(email: "ALI@gmail.com", amount: "25", currancy: 1),
    HCard(email: "ALI@yahoo.com", amount: "254", currancy: 0),
    HCard(email: "ALI@ama.eg.com", amount: "45", currancy: 0),
    HCard(email: "ALI@gmail.com", amount: "48", currancy: 2)
    ]
    var donationsData: [HCard] = [
    HCard(email: "OSama@gmail.com", amount: "25", currancy: 1),
    HCard(email: "OSama@yahoo.com", amount: "254", currancy: 0),
    HCard(email: "OSama@ama.eg.com", amount: "45", currancy: 0),
    HCard(email: "OSama@gmail.com", amount: "48", currancy: 2)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    /// IBAction method called when any category is beign selected
    /// - Parameter sender: use to access button properity like tag.
    @IBAction func detailsBtnWasPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            let vc = HistoryDetailsVC()
            vc.modalPresentationStyle = .fullScreen
            vc.configureController(title: HDetails.consumption.title() , segItems: HDetails.consumption.segItems() , firstData: CONPurachesData, secondData: CONIndividuals, infoLabel: HDetails.consumption.infoLabel())
            self.present(vc, animated: true, completion: nil)
        }else if sender.tag == 1 {
            let vc = HistoryDetailsVC()
            vc.modalPresentationStyle = .fullScreen
            vc.configureController(title: HDetails.received.title(), segItems: HDetails.received.segItems(), firstData: SENSales, secondData: SENIndividals, infoLabel: HDetails.received.infoLabel())
            self.present(vc, animated: true, completion: nil)
        }else {
            let vc = HistoryDetailsVC()
            vc.modalPresentationStyle = .fullScreen
            vc.configureController(title: HDetails.donations.title(), segItems: HDetails.donations.segItems(), firstData: donationsData, infoLabel: HDetails.donations.infoLabel(), withSeg: false)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func backBtnWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

}
