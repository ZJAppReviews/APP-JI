//
//  MainView.swift
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/6/4.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

import Foundation

class MianViewController: UITableViewController,MainViewCellDelegate,PasswordTableViewDelegate {

    var noDataBtn:UIButton?
    var themeArray:Array<Theme>?
    var currentCell:MainTableViewCell?
    var themeToPush:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //分类注册Cell
        self.tableView.register(MainTableViewTextCell.self, forCellReuseIdentifier: "text")
        self.tableView.register(MainTableViewPhotoCell.self, forCellReuseIdentifier: "photo")
        self.tableView.register(MainTableViewSwitchCell.self, forCellReuseIdentifier: "switch")
        
        //如果打开了验证，在此进行验证
        if UserDefaults.standard.bool(forKey: "PasswordEnabled") && UserDefaults.standard.bool(forKey: "FirstAuthEnabled") && !UserDefaults.standard.bool(forKey: "Authed"){
            let authView = UIStoryboard.init(name: "PasswordView", bundle: nil)
            let authNav:UINavigationController = authView.instantiateViewController(withIdentifier: "inputPassword") as! UINavigationController
            let passwordVC:PasswordViewController = authNav.topViewController as! PasswordViewController
            self.present(authNav, animated: true, completion: {
                passwordVC.setMode(mode: "firstAuth")
                })
        }
        
        noDataBtn = UIButton.init()
        noDataBtn!.frame = CGRect.init(x: UIScreen.main.bounds.size.width/2-136.5, y: 150, width: 273, height: 174)
        noDataBtn!.setBackgroundImage(UIImage.init(named: "MainView_NoDataButton"), for: .normal)
        noDataBtn?.addTarget(self, action: #selector(addBtnClicked(_:)), for: .touchUpInside)
        self.tableView.addSubview(noDataBtn!)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dataMethod = CoreDataMethods.init()
        themeArray = dataMethod.getThemeList()
        if (themeArray?.first == nil){
            noDataBtn!.isHidden = false
        }else{
            noDataBtn!.isHidden = true
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (themeArray?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        currentCell = tableView.dequeueReusableCell(withIdentifier: themeArray![indexPath.row].type!) as? MainTableViewCell
        currentCell?.theme = themeArray![indexPath.row]
        currentCell?.delegate = self
        currentCell?.settingText()
        return currentCell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //print(currentCell?.cellHeight)
        //print(indexPath.row)
        //print((tableView.cellForRow(at: indexPath) as! MainTableViewCell).cellHeight)
        return (currentCell?.cellHeight)!
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: "删除", handler: {_,_ in
            let aleartController = UIAlertController.init(title: nil, message: "确认删除该项目下所有记录吗？", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "确定", style: .default, handler: {_ in
                let dataMethod = CoreDataMethods.init()
                dataMethod.deleteTheme(title: self.themeArray![indexPath.row].title!)
                print("why?")
                //let notifiMethod = NotificationsMethods.init()
                //notifiMethod.cancelNotification(self.themeArray![indexPath.row].title)
                self.themeArray?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                if (self.themeArray?.first == nil){
                    self.noDataBtn!.isHidden = false
                }
                return
            })
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            aleartController.addAction(okAction)
            aleartController.addAction(cancelAction)
            self.present(aleartController, animated: true, completion: nil)
        })
        let editAction = UITableViewRowAction.init(style: .normal, title: "编辑", handler: {_,_ in
        })
        return [deleteAction,editAction]
    }
    
    @IBAction func settingBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Setting", bundle: nil)
        let settingView = storyboard.instantiateViewController(withIdentifier: "SettingNavigationController")
        self.present(settingView, animated: true, completion: nil)
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "NewTheme", bundle: nil)
        let newThemeView = storyboard.instantiateViewController(withIdentifier: "newTheme")
        self.present(newThemeView, animated: true, completion: nil)
    }
    
    func pushClicked(theme: String) {
        themeToPush = theme
        if (UserDefaults.standard.bool(forKey: "PasswordEnabled") && !UserDefaults.standard.bool(forKey: "FirstAuthEnabled") && !UserDefaults.standard.bool(forKey: "Authed")){
            let authView = UIStoryboard.init(name: "PasswordView", bundle: nil)
            let authNav:UINavigationController = authView.instantiateViewController(withIdentifier: "inputPassword") as! UINavigationController
            let passwordVC:PasswordViewController = authNav.topViewController as! PasswordViewController
            self.present(authNav, animated: true, completion: {
                passwordVC.setMode(mode: "auth")
                passwordVC.setDelegate(delegate: self)
                return
            })
        } else {
           pushDetailView()
        }
    }
    
    func pushDetailView() {
        OperationQueue.main.addOperation {
            let dataMethod = CoreDataMethods.init()
            var logTVC:LogTableViewController?
            switch dataMethod.getType(title: self.themeToPush!){
            case "text":
                logTVC = TextLogTableViewController.init(style: .plain)
            case "switch":
                logTVC = SwitchLogTableViewController.init(style: .plain)
            case "photo":
                logTVC = PhotoLogTableViewController.init(style: .plain)
            default:
                logTVC = TextLogTableViewController.init(style: .plain)
            }
            logTVC?.themeTitle = self.themeToPush
            self.navigationController?.pushViewController(logTVC!, animated: true)
        }
    }
}
