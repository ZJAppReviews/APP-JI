//
//  MainTableViewCell.swift
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/31.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

import Foundation
import UIKit
protocol MainTableViewCellDelegate {
    //这个方法名称需要检查
    func pushClicked(question:NSString)
    func reloadCell()
    func refreshUI()
}

class MainTableViewCell: UITableViewCell {
    
    var cellHeight:CGFloat?
    var mainModel:TextCellModel?
//    var delegate:MainTableViewCellDelegate
    
    var titleLab:UILabel?
    var bgLab:UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if bgLab == nil{
            bgLab = UILabel.init()
            self.contentView.addSubview(bgLab!)
            titleLab = UILabel.init()
            self.contentView.addSubview(titleLab!)
        }

        return
        
    }
    
    func settingText(){
        
        print("hi")
        
        bgLab?.backgroundColor = UIColor.init(red: 249/255, green: 204/255, blue: 60/255, alpha: 1)
        bgLab?.layer.cornerRadius = 10
        bgLab?.layer.masksToBounds = true
        titleLab?.font = UIFont.boldSystemFont(ofSize: 21)
        titleLab?.frame = CGRect.init(x: 28, y: 23, width: UIScreen.main.bounds.size.width-56, height: 26)
        titleLab?.numberOfLines = 1
        titleLab?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        titleLab?.textColor = UIColor.black
        titleLab?.text = mainModel?.question
        
    }
    
    static func id() -> NSString{
        let main:NSString = "Main"
        return main
    }
    

    
    

    
    
    
}

class MainViewPhotoCell: UITableViewCell {
    
    var cellHeight:CGFloat?
    
    
    
}
