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
    
    @IBOutlet var secondCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let password = UserDefaults.standard.string(forKey: "Password")
        if password == nil {
            let nonePassword = "none"
            UserDefaults.standard.set(nonePassword, forKey: "Password")
            passwordEnabledSwtich.setOn(false, animated: false)
           // let secondSection = NSIndexSet.init(index: 2)

            self.tableView.deleteSections(IndexSet(integersIn: 1...3), with: UITableViewRowAnimation.automatic)

        }else if password == "none" {
            passwordEnabledSwtich.setOn(false, animated: false)
            //let secondSection = NSIndexSet.init(index: 1)
            //self.tableView.deleteSections(secondSection as IndexSet, with: UITableViewRowAnimation.automatic)
            
            
            //改一下右边放的不应该是button而是label
        }
    }

    
}
