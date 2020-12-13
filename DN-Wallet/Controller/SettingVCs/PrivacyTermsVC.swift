//
//  PrivacyTermsVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 8/4/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

struct PrivacySection {
    var title: String
    var description: String
}

class PrivacyTermsVC: UIViewController {
    
    private var privacyTable: UITableView!
    var items : [PrivacySection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        setupTableView()
        setupLayout()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupTableView() {
        privacyTable                    = UITableView(frame: .zero, style: .grouped)
        privacyTable.delegate           = self
        privacyTable.dataSource         = self
        privacyTable.backgroundColor    = .clear
        privacyTable.register(PrivacyCell.self, forCellReuseIdentifier: "privcecellid")
        
    }
    
    private func setupLayout() {
        view.addSubview(privacyTable)
        privacyTable.DNLayoutConstraintFill()
    }
    
}

extension PrivacyTermsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = privacyTable.dequeueReusableCell(withIdentifier: "privcecellid", for: indexPath) as? PrivacyCell else { return UITableViewCell() }
        cell.configureCell(text: items[indexPath.section].description)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel                   = DNTitleLabel(textAlignment: .left, fontSize: 18)
        titleLabel.text                  = " \(items[section].title)"
        let bottomPaddingView            = UIView()
        bottomPaddingView.translatesAutoresizingMaskIntoConstraints = false
        bottomPaddingView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        let stack                        = UIStackView(arrangedSubviews: [UIView(), titleLabel, bottomPaddingView])
        stack.configureStack(axis: .vertical, distribution: .fill, alignment: .fill, space: 0)
        return stack
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return items[indexPath.section].description.textHeight() + 20
    }
}
