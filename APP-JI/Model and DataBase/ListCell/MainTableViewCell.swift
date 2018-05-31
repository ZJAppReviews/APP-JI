//
//  MainTableViewCell.swift
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/31.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

import Foundation
import UIKit

@objc protocol MainTableViewCellDelegate {
    //这个方法名称需要检查
    func pushClicked(question:String)
    func reloadCell()
    func refreshUI()
}

class MainTableViewCell: UITableViewCell {
    
    var mainModel:TextCellModel?
    var delegate:MainTableViewCellDelegate?
    var cellID:NSString = "Main"
    var cellHeight = CGFloat()
    
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
                
        cellHeight = 242
        bgLab?.backgroundColor = UIColor.init(red: 249/255, green: 204/255, blue: 60/255, alpha: 1)
        bgLab?.layer.cornerRadius = 10
        bgLab?.layer.masksToBounds = true
        bgLab?.frame = CGRect.init(x: 16, y: 10, width: UIScreen.main.bounds.size.width-32, height: cellHeight-20)
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

class MainTableViewTextCell: MainTableViewCell,UITextViewDelegate {
    
    var contentLab = UILabel.init()
    var contentTV = UITextView.init()
    var contentBG = UILabel.init()
    var pushBtn = UIButton.init()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(contentBG)
        self.contentView.addSubview(contentLab)
        self.contentView.addSubview(contentTV)
        self.contentView.addSubview(pushBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func settingText() {
        
        super.settingText()
        
        contentBG.layer.cornerRadius = 7
        contentBG.layer.masksToBounds = true
        
        if ((mainModel?.answer) != nil) {
            
            contentLab.isHidden = false
            contentTV.isHidden = true
            pushBtn.isHidden = false
            
            let answerSize = mainModel?.answer!.boundingRect(with: CGSize.init(width: UIScreen.main.bounds.size.width-76, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 17)], context: nil).size
            contentBG.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: answerSize!.height+27)
            contentBG.backgroundColor = UIColor.init(red: 168/255, green: 135/255, blue: 0, alpha: 1)
            
            contentLab.frame = CGRect.init(x: 38, y: 71, width: UIScreen.main.bounds.size.width-76, height: answerSize!.height)
            contentLab.text = mainModel?.answer
            contentLab.numberOfLines = 0
            contentLab.font = UIFont.systemFont(ofSize: 17)
            contentLab.textColor = UIColor.white
            
            cellHeight = answerSize!.height+107
            
            pushBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: answerSize!.height+27)
            pushBtn.addTarget(self, action:#selector(MainTableViewTextCell.pushBtnClicked), for: UIControlEvents.touchUpInside)
            
        }else{
            
            contentTV.isHidden = false
            contentLab.isHidden = true
            pushBtn.isHidden = true
            
            contentBG.backgroundColor = UIColor.init(red: 254/255, green: 226/255, blue: 122/255, alpha: 1)
            contentBG.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: 162)
            
            contentTV.font = UIFont.systemFont(ofSize: 17)
            contentTV.frame = CGRect.init(x: 38, y: 66, width: UIScreen.main.bounds.size.width-76, height: 140)
            contentTV.layer.cornerRadius = 7
            contentTV.backgroundColor = UIColor.init(red: 254/255, green: 226/255, blue: 122/255, alpha: 1)
            contentTV.delegate = self
            
            let keyboardDoneButtonView = UIToolbar.init()
            keyboardDoneButtonView.barStyle = UIBarStyle.default
            keyboardDoneButtonView.tintColor = UIColor.clear
            keyboardDoneButtonView.isTranslucent = true
            keyboardDoneButtonView.sizeToFit()
            let cancelBtn = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainTableViewTextCell.cancelBtnClicked))
            cancelBtn.tintColor = UIColor.red
            let spaceBtn = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action:nil)
            let doneBtn = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.done, target: self, action:#selector(MainTableViewTextCell.doneBtnClicked))
            doneBtn.tintColor = UIColor.init(red: 0.098, green: 0.512, blue: 1, alpha: 1)
            keyboardDoneButtonView.setItems([cancelBtn,spaceBtn,doneBtn], animated: false)
            contentTV.inputAccessoryView = keyboardDoneButtonView
        }
        
        bgLab!.frame = CGRect.init(x: 16, y: 10, width: UIScreen.main.bounds.size.width-32, height: cellHeight-20)
        
    }
    
    func cancelBtnClicked() {

        contentTV.resignFirstResponder()
        contentTV.text = ""
        
    }
    
    func doneBtnClicked() {
        
        mainModel!.answer = contentTV.text
        contentTV.resignFirstResponder()
        contentTV.isHidden = true
        settingText()
        let dbMethod = DatabaseMethods.init()
        dbMethod.addAnswer(contentTV.text, withQuestion: mainModel?.question)
        
    }
    
    func pushBtnClicked() {
        
        self.delegate!.pushClicked(question: mainModel!.question)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentTV.layer.contents = nil
    }
    
}

class MainTableViewSwitchCell: MainTableViewCell {
    
    var yesBtn = UIButton.init()
    var noBtn = UIButton.init()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(yesBtn)
        self.contentView.addSubview(noBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func settingText() {
        
        super.settingText()
        
        yesBtn.addTarget(self, action:#selector(MainTableViewSwitchCell.yesBtnClicked), for: UIControlEvents.touchUpInside)
        yesBtn.setTitle("是", for: UIControlState.normal)
        yesBtn.titleLabel?.textAlignment = NSTextAlignment.center
        yesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 53)
        yesBtn.layer.cornerRadius = 7
        noBtn.addTarget(self, action:#selector(MainTableViewSwitchCell.noBtnClicked), for: UIControlEvents.touchUpInside)
        noBtn.setTitle("不是", for: UIControlState.normal)
        noBtn.titleLabel?.textAlignment = NSTextAlignment.center
        noBtn.titleLabel?.font = UIFont.systemFont(ofSize: 53)
        noBtn.layer.cornerRadius = 7
        
        if mainModel?.answer == nil{
            
            yesBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width/2-33.5, height: 162)
            yesBtn.backgroundColor = UIColor.init(red: 254/255, green: 226/255, blue: 122/255, alpha: 1)
            yesBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            yesBtn.isHidden = false
            noBtn.frame = CGRect.init(x: UIScreen.main.bounds.size.width/2+5.5, y: 57, width: UIScreen.main.bounds.size.width/2-33.5, height: 162)
            noBtn.backgroundColor = UIColor.init(red: 254/255, green: 226/255, blue: 122/255, alpha: 1)
            noBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            noBtn.isHidden = false
            
        }else if mainModel?.answer == "yes"{
            
            noBtn.isHidden = true
            yesBtn.isHidden = false
            yesBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: 162)
            yesBtn.backgroundColor = UIColor.init(red: 168/255, green: 135/255, blue: 0, alpha: 1)
            yesBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            
        }else if mainModel?.answer == "no"{
            
            yesBtn.isHidden = true
            noBtn.isHidden = false
            noBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: 162)
            noBtn.backgroundColor = UIColor.init(red: 168/255, green: 135/255, blue: 0, alpha: 1)
            noBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            
        }
        
    }
    
    func yesBtnClicked() {
        
        if mainModel!.answer != nil {
            self.delegate!.pushClicked(question: mainModel!.question)
            return
        }
        
        let impac = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackStyle.medium)
        impac.prepare()
        impac.impactOccurred()
        
        noBtn.isHidden = true
        yesBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: 162)
        yesBtn.backgroundColor = UIColor.init(red: 168/255, green: 135/255, blue: 0, alpha: 1)
        yesBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        mainModel?.answer = "yes"
        let dbmethod = DatabaseMethods.init()
        dbmethod.addAnswer(mainModel?.answer, withQuestion: mainModel?.question)
        
    }
    
    func noBtnClicked() {
        
        if mainModel?.answer != nil {
            self.delegate!.pushClicked(question: mainModel!.question)
            return
        }
        
        let impac = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackStyle.medium)
        impac.prepare()
        impac.impactOccurred()
        
        yesBtn.isHidden = true
        noBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: 162)
        noBtn.backgroundColor = UIColor.init(red: 168/255, green: 135/255, blue: 0, alpha: 1)
        noBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        mainModel?.answer = "no"
        let dbmethod = DatabaseMethods.init()
        dbmethod.addAnswer(mainModel?.answer, withQuestion: mainModel?.question)
    }
    
}
