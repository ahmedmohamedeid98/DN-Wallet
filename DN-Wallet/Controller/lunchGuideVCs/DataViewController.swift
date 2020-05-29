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
        img.backgroundColor = .lightGray
        return img
    }()
    
    var text: String?
    
    let textView: UITextView = {
        let lb = UITextView()
        lb.isEditable = false
        lb.textAlignment = .center
        lb.font = UIFont.DN.Regular.font(size: 25)
        lb.textColor = .DnColor
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
