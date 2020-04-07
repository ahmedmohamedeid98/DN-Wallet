//
//  DNDetailsView.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/18/20.
//  Copyright © 2020 DN. All rights reserved.
//

class DNDetailsView: UIView {
    
    var title :UILabel = {
        let lb = UILabel()
        lb.backgroundColor = UIColor.DN.DarkBlue.color()
        lb.textColor = .white//UIColor.DN.DarkBlue.color()
        lb.font = UIFont.DN.Regular.font(size: 18)
        lb.textAlignment = .center
        lb.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        lb.layer.shadowOpacity = 1.0
        lb.layer.shadowOffset = CGSize(width: 0, height: 1)
        lb.layer.shadowRadius = 0.0
        //lb.layer.borderColor = UIColor.DN.LightGray.color().cgColor
        //lb.layer.borderWidth = 0.5
        return lb
    }()
    var detailsView : UITextView = {
        let details = UITextView()
        details.isEditable = false
        details.font = UIFont.DN.Regular.font(size: 14)
        details.backgroundColor = .white
        details.textColor = .black
        //details.layer.borderColor = UIColor.DN.LightBlue.color().cgColor
        //details.layer.borderWidth = 0.5
        return details
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(detailsView)
        addSubview(title)
        detailsView.DNLayoutConstraint(title.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor)
        title.DNLayoutConstraint(topAnchor, left: leftAnchor, right: rightAnchor, size: CGSize(width: 0, height: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
