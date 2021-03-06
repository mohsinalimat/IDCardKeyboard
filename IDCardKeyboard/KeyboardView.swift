//
//  KeyboardView.swift
//  Swiftk
//
//  Created by KingCQ on 16/5/30.
//  Copyright © 2016年 KingCQ. All rights reserved.
//

import UIKit

let marginvalue = CGFloat(0.5)
let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let CLEAR_NOTIFICTION = "CLEAR_NOTIFICTION"


typealias InputTextClosure = (String)->()

class KeyboardView: UIView, UITextFieldDelegate{
    static let shareKeyboard: KeyboardView = KeyboardView()
    var textFields = [UITextField]()
    
    var inputTextClosure: InputTextClosure?
    var superView: UIView! = nil
    
    var text = ""
    
    override init(frame: CGRect) {
        let frameH = CGFloat(224.0)
//        var frameH = CGFloat(224.0)
//        switch Device() {
//        case .iPhone5,.iPhone5s,.iPhone5c:
//            frameH = CGFloat(224.0)
//        case .iPhone6,.iPhone6s:
//            frameH = CGFloat(258.0)
//        case .iPhone6Plus,.iPhone6sPlus:
//            frameH = CGFloat(271.0)
//        default:
//            break
//        } 这个根据自己项目来适配
        
        let frame: CGRect = CGRectMake(0,0,SCREEN_WIDTH,frameH)
        super.init(frame: frame)
        self.backgroundColor = .lightGrayColor()
        customSubview(frame)
        
    }
    
    func addKeyboard(view: UIView, field: UITextField?) {
        superView = view
        KeyboardNotification.shareKeyboardNotification.addKeyboardNotificationForSuperView(superView, margin: 0)
        if field != nil {
            textFields.append(field!)
            field!.inputView = self
            field!.delegate = self
            return
        }
        for view in superView.subviews {
            if view.isKindOfClass(UITextField) {
                let textField: UITextField = view as! UITextField
                textField.delegate = self
                textFields.append(textField)
                textField.inputView = self
            }
        }
    }
    
   private func customSubview(frame: CGRect){
        for idx in 0...11 {
            let button: UIButton = UIButton()
            button.frame = CGRectMake(CGFloat(idx%3) * (frame.width/3+marginvalue), CGFloat(idx/3) * (frame.height/4.0 + marginvalue), frame.width/3, frame.height/4.0)
            button.backgroundColor = .whiteColor()
            button.tag = idx
            button.setTitle("\(idx+1)", forState: .Normal)
            if idx == 9 {
                button.setTitle("x", forState: .Normal)
            }
            if idx == 10 {
                button.setTitle("0", forState: .Normal)
            }
            if idx == 11 {
                button.setTitle("回退", forState: .Normal)
            }
            button.setBackgroundImage(UIImage.imageWithColor(.whiteColor()), forState: .Normal)
            button.setBackgroundImage(UIImage.imageWithColor(.lightGrayColor()), forState: .Highlighted)
            button.setTitleColor(.blackColor(), forState: .Normal)
            button.addTarget(self, action: #selector(tap(_:)), forControlEvents: .TouchUpInside)
            addSubview(button)
        }
    }
    
    func tap(sender:UIButton) {
        if sender.currentTitle! == "回退" {
            if text.characters.count > 0 {
                text = text.removeLastCharacter()
            }
        } else {
            text += sender.currentTitle!
        }
        
        editTextField(text)
 
    }
    
    func editTextField(text: String) {
        if textFields.count == 0 {
            return
        }
        for field in textFields {
            if field.isFirstResponder() == true {
                field.text = text
            }
        }
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        text = ""
        return true
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension String {
    mutating func removeLastCharacter() -> String {
        self.removeAtIndex(self.endIndex.predecessor())
        return self
    }
}

extension UIImage {
    /** 生成纯色图片, 默认大小1x1, 在UITableViewCell默认左侧图标使用时需要手动设定大小占位 */
    public class func imageWithColor(color: UIColor, size: CGSize = CGSizeMake(1, 1)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.set()
        UIRectFill(CGRect(origin: CGPointZero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}




/*
 keyboard height
 iphone5 : 224
 iphone6 : 258
 iphone6 plus: 271
 */

