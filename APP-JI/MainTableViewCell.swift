//
//  MainTableViewCell.swift
//  APP-JI
//
//  Created by 黄鹏昊 on 2018/5/31.
//  Copyright © 2018年 黄鹏昊. All rights reserved.
//

import Foundation
import UIKit

@objc protocol MainViewCellDelegate {
    func pushClicked(theme:String)
}


class MainTableViewCell: UITableViewCell {
    
    var theme:Theme?
    var delegate:MainViewCellDelegate?

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
            self.backgroundColor = UIColor.init(named:"LightYellow")
            self.selectionStyle = .none
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
        titleLab?.text = (theme!.title)!
        
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
    let contentImage = UIImageView.init(image: UIImage.init(named: "MainView_Cell_TextButton"))
    var pushBtn = UIButton.init()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(contentBG)
        self.contentView.addSubview(contentLab)
        self.contentView.addSubview(contentTV)
        self.contentView.addSubview(pushBtn)
        self.contentTV.addSubview(contentImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func settingText() {
        
        super.settingText()
        
        contentBG.layer.cornerRadius = 7
        contentBG.layer.masksToBounds = true
        
        if ((theme?.todayContent) != nil) {
            
            contentLab.isHidden = false
            contentTV.isHidden = true
            pushBtn.isHidden = false
            
            let answerSize = theme?.todayContent!.boundingRect(with: CGSize.init(width: UIScreen.main.bounds.size.width-76, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 17)], context: nil).size
            contentBG.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: answerSize!.height+27)
            contentBG.backgroundColor = UIColor.init(red: 168/255, green: 135/255, blue: 0, alpha: 1)
            
            contentLab.frame = CGRect.init(x: 38, y: 71, width: UIScreen.main.bounds.size.width-76, height: answerSize!.height)
            contentLab.text = theme?.todayContent
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
            
            contentImage.frame = CGRect.init(x: UIScreen.main.bounds.size.width/2-70.5, y: 38, width: 65, height: 65)
            
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
        contentImage.isHidden = false
        
    }
    
    func doneBtnClicked() {
        
        theme?.todayContent = contentTV.text
        contentTV.resignFirstResponder()
        contentTV.isHidden = true
        settingText()
        let datamMethod = CoreDataMethods.init()
        datamMethod.addLog(title: (theme?.title)!, content: contentTV.text)
        self.reloadInputViews()
        //这个地方应该调用首页的出现方法，这样写可能会有问题
    }
    
    func pushBtnClicked() {
        
        self.delegate!.pushClicked(theme: (theme?.title)!)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        contentImage.isHidden = true

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
        
        if theme?.todayContent == nil{
            
            yesBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width/2-33.5, height: 162)
            yesBtn.backgroundColor = UIColor.init(red: 254/255, green: 226/255, blue: 122/255, alpha: 1)
            yesBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            yesBtn.isHidden = false
            noBtn.frame = CGRect.init(x: UIScreen.main.bounds.size.width/2+5.5, y: 57, width: UIScreen.main.bounds.size.width/2-33.5, height: 162)
            noBtn.backgroundColor = UIColor.init(red: 254/255, green: 226/255, blue: 122/255, alpha: 1)
            noBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            noBtn.isHidden = false
            
        }else if theme?.todayContent == "yes"{
            
            noBtn.isHidden = true
            yesBtn.isHidden = false
            yesBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: 162)
            yesBtn.backgroundColor = UIColor.init(red: 168/255, green: 135/255, blue: 0, alpha: 1)
            yesBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            
        }else if theme?.todayContent == "no"{
            
            yesBtn.isHidden = true
            noBtn.isHidden = false
            noBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: 162)
            noBtn.backgroundColor = UIColor.init(red: 168/255, green: 135/255, blue: 0, alpha: 1)
            noBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            
        }
        
    }
    
    func yesBtnClicked() {
        
        if theme?.todayContent != nil {
            self.delegate!.pushClicked(theme: (theme?.title)!)
            return
        }
        
        let impac = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackStyle.medium)
        impac.prepare()
        impac.impactOccurred()
        
        noBtn.isHidden = true
        yesBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: 162)
        yesBtn.backgroundColor = UIColor.init(red: 168/255, green: 135/255, blue: 0, alpha: 1)
        yesBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let dataMethod = CoreDataMethods.init()
        dataMethod.addLog(title: (self.titleLab?.text)!, content: "yes")
        
    }
    
    func noBtnClicked() {
        
        if theme?.todayContent != nil {
            self.delegate!.pushClicked(theme: (theme?.title)!)
            return
        }
        
        let impac = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackStyle.medium)
        impac.prepare()
        impac.impactOccurred()
        
        yesBtn.isHidden = true
        noBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: 162)
        noBtn.backgroundColor = UIColor.init(red: 168/255, green: 135/255, blue: 0, alpha: 1)
        noBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        let dataMethod = CoreDataMethods.init()
        dataMethod.addLog(title: (self.titleLab?.text)!, content: "no")
        
    }
    
}

class MainTableViewPhotoCell:MainTableViewCell,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var logBtn = UIButton.init()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(logBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func settingText() {
        
        super.settingText()
        
        logBtn.isHidden = false

        if theme?.todayContent == nil {
            logBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: 162)
            logBtn.layer.cornerRadius = 7
            logBtn.backgroundColor = UIColor.init(named: "LightYellow")
            logBtn.setImage(UIImage.init(named: "MainView_Cell_PhotoButton"), for: UIControlState.normal)
            logBtn.imageEdgeInsets = UIEdgeInsets(top: 48, left: 0, bottom: 49, right: 0)
            logBtn.addTarget(self, action: #selector(MainTableViewPhotoCell.logBtnClicked), for: UIControlEvents.touchUpInside)
        }else{
            if let todayImage = UIImage(contentsOfFile: (theme?.todayContent)!) {
                logBtn.layer.cornerRadius = 7
                logBtn.layer.masksToBounds = true
                logBtn.frame = CGRect.init(x: 28, y: 57, width: UIScreen.main.bounds.size.width-56, height: UIScreen.main.bounds.size.width-56)
                logBtn.setImage(todayImage, for: .normal)
                logBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cellHeight = UIScreen.main.bounds.size.width+24
                bgLab?.frame = CGRect.init(x: 16, y: 10, width: UIScreen.main.bounds.size.width-32, height: cellHeight-20)
            } else {
                print("文件不存在")
            }
        }
    }
    
    func logBtnClicked() {
        if theme?.todayContent == nil {
            let addActionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            let addFromPhotoAction = UIAlertAction.init(title: "从相册中选择", style: .default){(action:UIAlertAction)in
                let photoPicker = UIImagePickerController()
                photoPicker.delegate = self
                photoPicker.allowsEditing = true
                photoPicker.sourceType = .photoLibrary
                self.window?.rootViewController?.present(photoPicker, animated: true, completion: nil)
            }
            let addFromCameraAction = UIAlertAction.init(title: "拍摄", style:.default) {(action:UIAlertAction)in
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    let  cameraPicker = UIImagePickerController()
                    cameraPicker.delegate = self
                    cameraPicker.allowsEditing = true
                    cameraPicker.sourceType = .camera
                    self.window?.rootViewController?.present(cameraPicker, animated: true, completion: nil)
                }
            }
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            addActionSheet.addAction(addFromCameraAction)
            addActionSheet.addAction(addFromPhotoAction)
            addActionSheet.addAction(cancelAction)
            self.window?.rootViewController?.present(addActionSheet, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let imageDate = Date.init()
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy_MM_dd"
        let imageName = dateFormatter.string(from: imageDate)
        if let imageData = UIImageJPEGRepresentation(image, 1) as NSData? {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataPath = documentsDirectory.appendingPathComponent((theme?.title)!)
            
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }
            
            let fullPath = dataPath.appendingPathComponent(imageName).appendingPathExtension("jpg")
            imageData.write(toFile: fullPath.path, atomically: true)
            print("fullPath=\(fullPath.path)")
            let dataMehtod = CoreDataMethods.init()
            dataMehtod.addLog(title: (theme?.title)!, content: fullPath.path)
        }
        
        picker.dismiss(animated: true, completion: nil)

    }
    
}
