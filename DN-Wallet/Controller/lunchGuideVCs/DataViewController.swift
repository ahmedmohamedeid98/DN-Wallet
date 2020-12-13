//
//  DataViewController.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/29/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    let imageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    var text: String?
    
    let textView: UITextView = {
        let lb = UITextView()
        lb.isEditable = false
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        lb.textColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1)
        lb.backgroundColor = .clear
        return lb
    }()
    
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        textView.text = text
        setupView()
    }
    
    func setupView() {
        let stackView = UIStackView(arrangedSubviews: [imageView, textView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        view.addSubview(stackView)
        stackView.DNLayoutConstraintFill()
    }

}
