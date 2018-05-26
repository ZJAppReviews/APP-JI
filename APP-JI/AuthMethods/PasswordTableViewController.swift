//
//  PasswordTableViewController.swift
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/26.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

import UIKit

class PasswordTableViewController: UITableViewController {
    
    @IBOutlet var passwordView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordView.addConstraint(<#T##constraint: NSLayoutConstraint##NSLayoutConstraint#>)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = false
    }
    
}

class PasswordView: UIView {
    

    @IBOutlet var firstLab: UILabel!
    @IBOutlet var secondLab: UILabel!
    @IBOutlet var thirdLab: UILabel!
    @IBOutlet var fourthLab: UILabel!
    

    
    
    
}
