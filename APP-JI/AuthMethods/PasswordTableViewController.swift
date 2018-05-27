//
//  PasswordTableViewController.swift
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/26.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

import UIKit


class PasswordNavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

class PasswordViewController: UIViewController {
    
    @IBOutlet var passwordView: PasswordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordView.passwordTF.becomeFirstResponder()
        
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

}

class PasswordView: UIView {
    
    @IBOutlet var firstLab: UILabel!
    @IBOutlet var secondLab: UILabel!
    @IBOutlet var thirdLab: UILabel!
    @IBOutlet var fourthLab: UILabel!
    @IBOutlet var passwordTF: UITextField!
    
    @IBAction func editingChanged(_ sender: UITextField) {
        
        switch sender.text?.lengthOfBytes(using: String.Encoding.utf8) {
        case 1:
            firstLab.isHidden = false
        case 2:
            secondLab.isHidden = false
        case 3:
            thirdLab.isHidden = false
        case 4:
            fourthLab.isHidden = false
            if sender.text == "1234"{
                self.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
            }
        case 5:
            sender.text = ""
            firstLab.isHidden = true
            secondLab.isHidden = true
            thirdLab.isHidden = true
            fourthLab.isHidden = true
        default:
            print("some thing went wrong")
        }
        
    }
    
    
    
    
    
}
