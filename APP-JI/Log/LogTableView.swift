//
//  PhotoLog.swift
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/6/3.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

import Foundation

class LogTableViewController: UITableViewController {
    
    var logs:Array<Log>?
    var themeTitle:String?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.init(named: "LightYellow")
        self.tableView.separatorStyle = .none
        self.title = themeTitle
        let dataMethod = CoreDataMethods.init()
        logs = dataMethod.getLog(themeTitle: themeTitle!)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (logs?.count)!
    }
    


}


class PhotoLogTableViewController: LogTableViewController {
    
    var currentCell:PhotoLogTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(PhotoLogTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        currentCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? PhotoLogTableViewCell
        currentCell!.logContent = logs![indexPath.row]
        currentCell!.setContent()
        return currentCell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentCell!.cellHeight!
    }
    
}

class TextLogTableViewController: LogTableViewController {
    
    var currentCell:TextLogTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(TextLogTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        currentCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TextLogTableViewCell
        currentCell!.logContent = logs![indexPath.row]
        currentCell!.setContent()
        return currentCell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentCell!.cellHeight!
    }
    
}

class SwitchLogTableViewController: LogTableViewController {
    
    var currentCell:SwitchLogTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SwitchLogTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        currentCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SwitchLogTableViewCell
        currentCell!.logContent = logs![indexPath.row]
        currentCell!.setContent()
        return currentCell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentCell!.cellHeight!
    }
    
}
