//
//  JoinMeetingVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension JoinMeetingVC {
    func getSwitchState() {
        cameraSwitch.isOn = getSetParameter(enableCamera) != nil ? !getSetParameter(enableCamera)! : false
        microphoneSwitch.isOn = getSetParameter(enableMicphone) != nil ? !getSetParameter(enableMicphone)! : false
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        histroyArr.removeAllObjects()
        
        if UserDefaults.standard.object(forKey: histroyCall) != nil {
            histroyArr.addObjects(from: UserDefaults.standard.object(forKey: histroyCall) as! [String])
            tabHeightConstraint.constant = CGFloat(histroyArr.count*44)
            bgHeightConstraint.constant = CGFloat(histroyArr.count*44)
            hiddenHistoryTabBtn.isHidden = false
            tab.reloadData()
        }else {
            tabHeightConstraint.constant = 0
            bgHeightConstraint.constant = 0
            hiddenHistoryTabBtn.isHidden = true
        }
    }
    
    func initContent() {
        title = "title.joinmeeting".localized
        
        tabBg.layer.masksToBounds = true
        tabBg.layer.cornerRadius = 4
        tabBg.setAroundshadow(UIColor.black, CGSize(width: 0, height: 4), 0.3, 5)
        
        tab.layer.masksToBounds = true
        tab.layer.cornerRadius = 4
        
        meetIdTF.delegate = self
        meetIdTF.inputView = UIView.init(frame: .zero)
        let item = meetIdTF.inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
        
        cameraSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
        microphoneSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
        joinMeetingBtn.addTarget(self, action: #selector(joinMeetingAction), for: .touchUpInside)
        hiddenHistoryTabBtn.addTarget(self, action: #selector(showOrHiddenTabMethod), for: .touchUpInside)
        
        let scale = UIScreen.main.scale
        let width = scale > 0.0 ? 1.0 / scale : 1.0
        for btn in keyBoardBtn {
            btn.layer.borderWidth = width
            btn.layer.borderColor = UIColor.init(red: 193/255, green: 193/255, blue: 193/255, alpha: 0.4).cgColor
            btn.addTarget(self, action: #selector(keyBoardBtnAction(sender:)), for: .touchUpInside)
            btn.addTarget(self, action: #selector(keyBoardBtnActionTouchDown(sender:)), for: .touchDown)
            btn.addTarget(self, action: #selector(keyBoardBtnActionTouchDragOutside(sender:)), for: .touchDragOutside)
            btn.addTarget(self, action: #selector(keyBoardBtnActionTouchDragEnter(sender:)), for: .touchDragEnter)
            
            if btn.tag == 12 {
                let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(deleteAllstr))
                longPress.minimumPressDuration = 2
                btn.addGestureRecognizer(longPress)
            }
        }
        
        customNavItem()
    }
    
    @objc func removeHistoryCall(_ sender: UIButton) {
        histroyArr.removeObject(at: sender.tag)
        UserDefaults.standard.setValue(histroyArr, forKey: histroyCall)
        
        showOrHiddenTabMethod()
    }
    
    @objc func keyBoardBtnAction(sender:UIButton) {
        tab.isHidden = true
        tabBg.isHidden = tab.isHidden
        for btn in keyBoardBtn {
            btn.backgroundColor = UIColor.white
        }
        
        if sender.tag == 10 {
            if meetIdTF.text?.count == 32 {
                return
            }
            let rangee = meetIdTF.selectedRange()
            indexCursor = rangee.location
            if meetIdTF.text?.count == 32 {
                return
            }
            let str = NSMutableString.init(string: meetIdTF.text!)
            str.insert("*", at: indexCursor)
            meetIdTF.text = "\(str)"
            indexCursor += 1
            
            let range = NSMakeRange(indexCursor, 0)
            meetIdTF.setSelectedRange(range)
        }else if sender.tag == 11 {
            if meetIdTF.text?.count == 32 {
                return
            }
            let rangee = meetIdTF.selectedRange()
            indexCursor = rangee.location
            if meetIdTF.text?.count == 32 {
                return
            }
            let str = NSMutableString.init(string: meetIdTF.text!)
            str.insert("\(0)", at: indexCursor)
            meetIdTF.text = "\(str)"
            indexCursor += 1
            
            let range = NSMakeRange(indexCursor, 0)
            meetIdTF.setSelectedRange(range)
        }else if (sender.tag == 12) {
            let rangee = meetIdTF.selectedRange()
            indexCursor = rangee.location
            if indexCursor == 0 && rangee.length == 0 {
                return
            }else if (indexCursor == meetIdTF.text?.count) {
                meetIdTF.text = removeLastOneChar(meetIdTF.text!)
            }else {
                if meetIdTF.text?.count == 32 {
                    return
                }
                let str = NSMutableString.init(string: meetIdTF.text!)
                if rangee.length == 0 {
                    let range = NSMakeRange(indexCursor-1, 1)
                    str.replaceCharacters(in: range, with: "")
                }else {
                    let range = NSMakeRange(indexCursor, rangee.length)
                    str.replaceCharacters(in: range, with: "")
                }
                
                meetIdTF.text = "\(str)"
            }
            if indexCursor != 0 {
                indexCursor -= 1
            }
            let range = NSMakeRange(indexCursor, 0)
            meetIdTF.setSelectedRange(range)
        }else {
            let rangee = meetIdTF.selectedRange()
            indexCursor = rangee.location
            if meetIdTF.text?.count == 32 {
                return
            }
            let str = NSMutableString.init(string: meetIdTF.text!)
            str.insert("\(sender.tag)", at: indexCursor)
            meetIdTF.text = "\(str)"
            indexCursor += 1
            
            let range = NSMakeRange(indexCursor, 0)
            meetIdTF.setSelectedRange(range)
        }
    }
    
    @objc func keyBoardBtnActionTouchDown(sender:UIButton) {
        for btn in keyBoardBtn {
            btn.backgroundColor = UIColor.white
        }
        sender.backgroundColor = UIColor.init(formHexString: "0xf7f7f7")
    }
    
    @objc func keyBoardBtnActionTouchDragOutside(sender:UIButton) {
        for btn in keyBoardBtn {
            btn.backgroundColor = UIColor.white
        }
    }
    
    @objc func keyBoardBtnActionTouchDragEnter(sender:UIButton) {
        for btn in keyBoardBtn {
            btn.backgroundColor = UIColor.white
        }
        sender.backgroundColor = UIColor.init(formHexString: "0xf7f7f7")
    }
    
    @objc func deleteAllstr() {
        meetIdTF.text = ""
    }
    
    @objc func switchAction(sender:UISwitch) {
        let setInfo = getSetPlist()
        
        switch sender {
        case cameraSwitch:
            setInfo.setValue(!sender.isOn, forKey: enableCamera)
            break
        case microphoneSwitch:
            setInfo.setValue(!sender.isOn, forKey: enableMicphone)
            break
        default: break
        }
        
        PlistUtils.savePlistFile(setInfo as! [AnyHashable : Any], withFileName: setPlist)
    }
    
    @objc func joinMeetingAction() {
        if meetIdTF.text?.count == 0 {
            showHud("alert.inputmeetingnumber".localized, view, .MBProgressHUBPositionBottom, 2)
            return
        }
        
        if meetIdTF.text!.contains("*") {
            let meeting = (meetIdTF.text!.components(separatedBy: "*") as Array)[0]
            let password = (meetIdTF.text!.components(separatedBy: "*") as Array)[1]
            getTabBarVC().dialCall(sipNumber: meeting, isVideoMode: true, disPlayName: getUserParameter(displayName) ?? "", withPassword: password, callType: .conf)
        }else {
            getTabBarVC().dialCall(sipNumber: meetIdTF.text!, isVideoMode: true, disPlayName: getUserParameter(displayName) ?? "", withPassword: "", callType: .conf)
        }
    }
    
    @objc func showOrHiddenTabMethod() {
        tab.isHidden = !tab.isHidden
        tabBg.isHidden = tab.isHidden
        if !tab.isHidden {
            histroyArr.removeAllObjects()
            
            if UserDefaults.standard.object(forKey: histroyCall) != nil {
                histroyArr.addObjects(from: UserDefaults.standard.object(forKey: histroyCall) as! [String])
                tabHeightConstraint.constant = CGFloat(histroyArr.count*44)
                bgHeightConstraint.constant = CGFloat(histroyArr.count*44)
                hiddenHistoryTabBtn.isHidden = false
                tab.reloadData()
            }else {
                tabHeightConstraint.constant = 0
                bgHeightConstraint.constant = 0
                hiddenHistoryTabBtn.isHidden = true
            }
        }
    }
    
    func removeLastOneChar(_ origin:String) -> String {
        let str = origin
        if str.count > 0 {
            return String(str.dropLast())
        }
        return origin
    }
}
