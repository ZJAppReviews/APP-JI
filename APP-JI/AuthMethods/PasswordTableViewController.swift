//
//  PasswordTableViewController.swift
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/26.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

import UIKit
import LocalAuthentication

@objc protocol PasswordTableViewDelegate {
    
    func pushDetailView() -> Void
    
}


class PasswordNavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

class PasswordViewController: UIViewController {
    
    @IBOutlet var passwordView: PasswordView!
    var delegateView: PasswordTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        passwordView.passwordTF.becomeFirstResponder()
        
        
    }

    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    open func setMode(mode:String){

        passwordView.mode = mode
        passwordView.delegate = self

        switch mode {
        case "add":
            self.title = "创建密码"
            passwordView.passwordTF.becomeFirstResponder()

        case "change":
            self.title = "请验证当前密码"
            passwordView.passwordTF.becomeFirstResponder()

        case "auth":
            self.title = "请验证密码"
            
            if UserDefaults.standard.bool(forKey: "TouchIDEnabled"){
                let myContext = LAContext()
                let myLocalizedReasonString = "验证以查看内容"
                var authError: NSError?
                if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                    myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                        if success {
                            UserDefaults.standard.set(true, forKey: "Authed")
                            self.navigationController?.dismiss(animated: true, completion: {self.delegateView?.pushDetailView()})
                        }else{
                            self.passwordView.passwordTF.becomeFirstResponder()
                        }
                    }
                }
            }else{
                self.passwordView.passwordTF.becomeFirstResponder()
            }
        default:
            self.title = "请验证密码"
            passwordView.passwordTF.becomeFirstResponder()
        }
        
    }
    
    open func setDelegate(delegate:PasswordTableViewDelegate){
        
        self.delegateView = delegate
        
    }



}

class PasswordView: UIView {
    
    @IBOutlet var firstLab: UILabel!
    @IBOutlet var secondLab: UILabel!
    @IBOutlet var thirdLab: UILabel!
    @IBOutlet var passwordTF: UITextField!
    var mode:String?
    var tempPassword:String?
    var delegate:PasswordViewController?
    
    @IBAction func editingChanged(_ sender: UITextField) {
        
        let length = sender.text?.lengthOfBytes(using: String.Encoding.utf8)
        var displayLength = length
        
        if length == 4{
            
            let wrongAleart = UIAlertController(title: "密码错误，请重试", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            wrongAleart.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
            
            switch mode{
            case "add":
                self.delegate!.title = "请再次输入验证"
                mode = "addAuth"
                tempPassword = sender.text!
            case "addAuth":
                if tempPassword == sender.text!{
                    UserDefaults.standard.set(sender.text!, forKey: "Password")
                    UserDefaults.standard.set(false, forKey: "TouchIDEnabled")
                    UserDefaults.standard.set(false, forKey: "FirstAuthEnabled")
                    UserDefaults.standard.set(true, forKey: "PasswordEnabled")
                    self.delegate!.navigationController?.dismiss(animated: true, completion: nil)
                }else{
                    let differentAleart = UIAlertController(title: "两次密码不一致，请重新输入", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    differentAleart.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
                    self.delegate?.navigationController?.present(differentAleart, animated: true, completion: nil)
                    self.delegate!.setMode(mode: "add")
                }
            case "delete":
                if sender.text == UserDefaults.standard.string(forKey: "Password"){
                    UserDefaults.standard.set("none", forKey: "Password")
                    UserDefaults.standard.set(false, forKey: "PasswordEnabled")
                    self.delegate!.navigationController?.dismiss(animated: true, completion: nil)
                }else{
                    self.delegate?.navigationController?.present(wrongAleart, animated: true, completion: nil)
                }
            case "change":
                if sender.text == UserDefaults.standard.string(forKey: "Password"){
                    self.delegate!.title = "创建新的密码"
                    mode = "add"
                }else{
                    self.delegate?.navigationController?.present(wrongAleart, animated: true, completion: nil)
                }
            case "auth":
                if sender.text == UserDefaults.standard.string(forKey: "Password"){
                    UserDefaults.standard.set(true, forKey: "Authed")
                    self.delegate?.navigationController?.dismiss(animated: true, completion: {self.delegate?.delegateView?.pushDetailView()})
                }else{
                    self.delegate?.navigationController?.present(wrongAleart, animated: true, completion: nil)
                }
            default:
                print("wrong happened")
            }
            
            sender.text = ""
            displayLength = 0
        }
        
        firstLab.isHidden = displayLength! < 1
        secondLab.isHidden = displayLength! < 2
        thirdLab.isHidden = displayLength! < 3
    }
    
    
    
    
    
}
