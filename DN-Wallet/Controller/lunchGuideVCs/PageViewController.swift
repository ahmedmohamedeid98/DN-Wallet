//
//  PageViewController.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/29/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        let pageControl = UIPageControl.appearance()
        pageControl.currentPageIndicatorTintColor = .DnColor
        pageControl.pageIndicatorTintColor = .lightGray
    }

}
