//
//  SettingNavigationController.swift
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/27.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

import UIKit

class SettingNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneBtnClicked(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

class PasswordSettingTableViewController: UITableViewController {
    

    @IBOutlet var passwordEnabledSwtich: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let password = UserDefaults.standard.string(forKey: "Password")
        if password == nil {
            let nonePassword = "none"
            UserDefaults.standard.set(nonePassword, forKey: "Password")
            passwordEnabledSwtich.setOn(false, animated: false)

        }else if password == "none" {
            passwordEnabledSwtich.setOn(false, animated: false)
        }
    }

    
}
