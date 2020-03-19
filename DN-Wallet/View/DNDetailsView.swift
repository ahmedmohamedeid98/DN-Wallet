//
//  DNDetailsView.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/18/20.
//  Copyright © 2020 DN. All rights reserved.
//

class DNDetailsView: UIView {
    
    var title :UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.textColor = UIColor.DN.DarkBlue.color()
        lb.font = UIFont.DN.Regular.font(size: 16)
        lb.textAlignment = .left
        //lb.layer.borderColor = UIColor.DN.LightGray.color().cgColor
        //lb.layer.borderWidth = 0.5
        return lb
    }()
    var detailsView : UITextView = {
        let details = UITextView()
        details.isEditable = false
        details.font = UIFont.DN.Regular.font(size: 14)
        details.textColor = UIColor.DN.Black.color()
        details.layer.borderColor = UIColor.DN.LightBlue.color().cgColor
        details.layer.borderWidth = 0.5
        return details
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(detailsView)
        addSubview(title)
        detailsView.DNLayoutConstraintFill(top: 15, left: 0, right: 0, bottom: 0)
        title.DNLayoutConstraint(left: detailsView.leftAnchor,bottom: detailsView.topAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
