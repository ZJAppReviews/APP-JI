//
//  CoreDataMethods.swift
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/6/2.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

import Foundation
import CoreData


class CoreDataMethods:NSObject {
    
    // MARK: 主题操作
    func addTheme(title:String,type:String,notificationTime:String?) {
        
        // 获取总代理和托管对象总管
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        //建立一个entity
        let entity = NSEntityDescription.entity(forEntityName: "Theme", in: managedObjectContext)
        let theme = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        
        //保存
        theme.setValue(type, forKey: "type")
        theme.setValue(title, forKey: "title")
        theme.setValue(notificationTime, forKey: "notificationTime")
        
        //保存entity到托管对象中。如果保存失败，进行处理
        do {
            try managedObjectContext.save()
        } catch  {
            fatalError("无法保存")
        }
    }
    
    func getThemeList() -> Array<Theme>? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Theme>(entityName: "Theme")
        
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        return nil
    }
    
    func deleteTheme(title:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext

        //建立获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Theme")
        let predicate = NSPredicate(format: "title ==  %@",title)
        fetchRequest.predicate = predicate
        var deleteTheme:Theme?
        
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            deleteTheme = results.first as? Theme
            managedObjectContext.delete(deleteTheme!)
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            debugPrint("context save error:\(error),description:\(error.userInfo)")
        }
    }
    
    func refreshTodayContent() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        //建立获取的请求
        let fetchRequest = NSFetchRequest<Theme>(entityName: "Theme")
        let predicate = NSPredicate(format: "todayContent !=  nil")
        fetchRequest.predicate = predicate
        
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            for theme in results {
                theme.todayContent = nil
            }
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            debugPrint("context save error:\(error),description:\(error.userInfo)")
        }
        
    }
    
    func getType(title:String) -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Theme>(entityName: "Theme")
        let predicate = NSPredicate(format: "title ==  %@",title)
        fetchRequest.predicate = predicate
        
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            return results.first!.type!
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        
        return "None"
    }
    
    func isThemeRepeated(title:String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Theme")
        let predicate = NSPredicate(format: "title ==  %@",title)
        fetchRequest.predicate = predicate
        
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count > 0{
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        return true
    }
    
    // MARK: 记录操作
    func addLog(title:String, content:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchTitleRequest = NSFetchRequest<Theme>(entityName: "Theme")
        let predicate = NSPredicate(format: "title ==  %@",title)
        fetchTitleRequest.predicate = predicate
        
        do{
            let results = try managedObectContext.fetch(fetchTitleRequest)
            let addlog = Log(context: managedObectContext)
            addlog.themeTitle = title
            addlog.content = content
            addlog.time = NSDate()
            addlog.themes = results.first!
            results.first?.addToLogs(addlog)
            results.first?.todayContent = content
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        

        do{
            try managedObectContext.save()
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")

        }
        
    }
    
    func getLog(themeTitle:String) -> Array<Log>? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Log>(entityName: "Log")
        let predicate = NSPredicate(format: "themeTitle ==  %@",themeTitle)
        fetchRequest.predicate = predicate
        
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            debugPrint("ViewController Fetch error:\(error), description:\(error.userInfo)")
        }
        return nil
    }
    
}
