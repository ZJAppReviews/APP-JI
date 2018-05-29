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
        passwordView.delegate = self
        
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    open func setMode(mode:String){
        if mode == "add"{
            self.title = "创建密码"
        }else if mode == "delete"{
            self.title = "请验证密码"
        }
        passwordView.mode = mode
    }
    

}

class PasswordView: UIView {
    
    @IBOutlet var firstLab: UILabel!
    @IBOutlet var secondLab: UILabel!
    @IBOutlet var thirdLab: UILabel!
    @IBOutlet var fourthLab: UILabel!
    @IBOutlet var passwordTF: UITextField!
    var mode = "nil"
    var tempPassword = "nil"
    var delegate:PasswordViewController? = nil
    
    @IBAction func editingChanged(_ sender: UITextField) {
        
        switch sender.text?.lengthOfBytes(using: String.Encoding.utf8) {
        case 1:
            firstLab.isHidden = !firstLab.isHidden
        case 2:
            secondLab.isHidden = !secondLab.isHidden
        case 3:
            thirdLab.isHidden = !thirdLab.isHidden
        case 4:
            fourthLab.isHidden = !fourthLab.isHidden
            if mode == "add"{
                self.delegate!.title = "请再次输入验证"
                mode = "addAuth"
                tempPassword = sender.text!
            }else if mode == "addAuth"{
                if tempPassword == sender.text!{
                    UserDefaults.standard.set(sender.text!, forKey: "Password")
                    self.delegate!.navigationController?.dismiss(animated: true, completion: nil)
                }else{
                    let wrongAleart = UIAlertController(title: "两次密码不一致，请重新输入", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    wrongAleart.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
                    self.delegate?.navigationController?.present(wrongAleart, animated: true, completion: nil)
                    self.delegate!.setMode(mode: "add")
                }
            }else if mode == "delete"{
                if sender.text == UserDefaults.standard.string(forKey: "Password"){
                    UserDefaults.standard.set("none", forKey: "Password")
                    self.delegate!.navigationController?.dismiss(animated: true, completion: nil)
                }else{
                    let wrongAleart = UIAlertController(title: "密码错误，请重试", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    wrongAleart.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
                    self.delegate?.navigationController?.present(wrongAleart, animated: true, completion: nil)
                }
            }
            sender.text = ""

        default:
            print("some thing went wrong")
        }
        
    }
    
    
    
    
    
}
