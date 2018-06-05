//
//  PhotoLog.swift
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/6/3.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

import Foundation

class LogNavigationController: UINavigationController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var themeTitle:String?
    
/*    init(rootViewController: UIViewController, themeTitleToPush:String) {
        let dataMethod = CoreDataMethods.init()
        themeTitle = themeTitleToPush
        let type = dataMethod.getType(title: themeTitle!)
        switch type {
        case "Text":
            let textTVC = TextLogTableViewController.init(style: .plain)
            super.init(rootViewController: textTVC)
        case "Switch":
            let switchTVC = SwitchLogTableViewController.init(style: .plain)
            super.init(rootViewController: switchTVC)
        case "Photo":
            let photoTVC = PhotoLogTableViewController.init(style: .plain)
            super.init(rootViewController: photoTVC)
        default:
            super.init(rootViewController: rootViewController)
            print("wrong type send to LogNav")
        }
        self.title = themeTitle
    }*/
    
    override init(rootViewController: UIViewController) {
        let textTVC = TextLogTableViewController.init(style: .plain)
        super.init(rootViewController: textTVC)
    }
    

}

class LogTableViewController: UITableViewController {
    
    var logs:Array<Log>?
    var currentCell:LogTableViewCell?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataMethod = CoreDataMethods.init()
        logs = dataMethod.getLog(themeTitle: (self.navigationController as! LogNavigationController).themeTitle!)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (logs?.count)!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentCell!.cellHeight!
    }

}


class PhotoLogTableViewController: LogTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(PhotoLogTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        currentCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PhotoLogTableViewCell
        currentCell!.logContent = logs![indexPath.row]
        return currentCell!
    }
    
}

class TextLogTableViewController: LogTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(TextLogTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        currentCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TextLogTableViewCell
        currentCell!.logContent = logs![indexPath.row]
        return currentCell!
    }
    
}

class SwitchLogTableViewController: LogTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SwitchLogTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        currentCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwitchLogTableViewCell
        currentCell!.logContent = logs![indexPath.row]
        return currentCell!
    }
    
}
