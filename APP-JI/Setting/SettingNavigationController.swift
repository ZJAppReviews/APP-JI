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
    
    
    var sectionNum = 4
    var passwordEnabledSwitch:UISwitch?
    var touchIDEnabledSwitch:UISwitch?
    var firstAuthEnabledSwitch:UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if !UserDefaults.standard.bool(forKey: "PasswordEnabled") {
            passwordEnabledSwitch?.isOn = false
            if sectionNum != 1{
                sectionNum = 1
                let set = IndexSet(arrayLiteral: 1,2,3)
                self.tableView.deleteSections(set, with: UITableViewRowAnimation.none)
            }
        }else{
            if sectionNum == 1{
                sectionNum = 4
                let set = IndexSet(arrayLiteral: 1,2,3)
                self.tableView.insertSections(set, with: UITableViewRowAnimation.none)
            }
            passwordEnabledSwitch?.isOn = true
            touchIDEnabledSwitch?.isOn = UserDefaults.standard.bool(forKey: "TouchIDEnabled")
            firstAuthEnabledSwitch?.isOn = UserDefaults.standard.bool(forKey: "FirstAuthEnabled")
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(indexPath.section))
        let cellTitle = [["启用密码"],["更改密码"],["使用触控 ID"],["启动时需要密码解锁"]]
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.default
                , reuseIdentifier: String(indexPath.section));
        }
        if indexPath.section != 1{
            let switchView = UISwitch(frame: .zero)
            cell?.accessoryView = switchView
            switchView.onTintColor = UIColor(red: 249/255.0, green: 204/255.0, blue: 60/255.0, alpha: 1)
            switchView.tag = indexPath.section
            switchView.addTarget(self, action: #selector(switchToggled(_:)), for: UIControlEvents.valueChanged)
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            switch indexPath.section{
            case 0:
                passwordEnabledSwitch = switchView
                passwordEnabledSwitch?.isOn = UserDefaults.standard.bool(forKey: "PasswordEnabled")
            case 1:
                cell!.selectionStyle = UITableViewCellSelectionStyle.default
            case 2:
                touchIDEnabledSwitch = switchView
                touchIDEnabledSwitch?.isOn = UserDefaults.standard.bool(forKey: "TouchIDEnabled")
            case 3:
                firstAuthEnabledSwitch = switchView
                firstAuthEnabledSwitch?.isOn = UserDefaults.standard.bool(forKey: "FirstAuthEnabled")
            default:
                print("some thing went wrong")
            }

        }
        
        cell?.textLabel?.text =  cellTitle[indexPath.section][indexPath.row]

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 3 {
            return "关闭时，查看当日记录与添加新的记录无需输入密码"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1

    }
    
    //MARK:行中的开关被触发
    func switchToggled(_ sender : UISwitch!){
        var sendMode:String?
        if sender.tag == 0{
            if sender.isOn == true {
                sendMode = "add"
            }else{
                sendMode = "delete"
            }
            let setPassword = UIStoryboard(name:"PasswordView", bundle:nil)
            let setPasswordNav:UINavigationController = setPassword.instantiateViewController(withIdentifier: "inputPassword") as! UINavigationController
            let setPasswordViewController = setPasswordNav.topViewController as? PasswordViewController
            self.navigationController?.present(setPasswordNav, animated: true, completion: {setPasswordViewController?.setMode(mode:sendMode!)})
        }else if sender.tag == 2{
            if sender.isOn == true {
                UserDefaults.standard.set(true, forKey: "TouchIDEnabled")
            }else{
                UserDefaults.standard.set(false, forKey: "TouchIDEnabled")
            }
        }else if sender.tag == 3{
            if sender.isOn == true {
                UserDefaults.standard.set(true, forKey: "FirstAuthEnabled")
            }else{
                UserDefaults.standard.set(false, forKey: "FirstAuthEnabled")
            }
        }

    }

    //MARK: 更改密码行被点击
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let changePassword = UIStoryboard(name: "PasswordView", bundle: nil)
            let changePasswordNav:UINavigationController = changePassword.instantiateViewController(withIdentifier: "inputPassword") as! UINavigationController
            let changePasswordViewController = changePasswordNav.topViewController as? PasswordViewController
            self.navigationController?.present(changePasswordNav, animated: true, completion: {changePasswordViewController?.setMode(mode: "change")})
        }
    }
    
}
