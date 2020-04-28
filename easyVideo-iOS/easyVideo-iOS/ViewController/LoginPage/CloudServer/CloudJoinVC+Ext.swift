//
//  CloudJoinVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension CloudJoinVC {
    func initContent() {
        meetingNumberTF.setBorder(4, .BorderTypeAllCorners, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        meetingNumberTF.maxTextLength = 32
        
        nameTF.setBorder(4, .BorderTypeAllCorners, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
        cameraBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        micPhoneBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        hiddenHistoryTabBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        joinBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        micPhoneBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        
        micPhoneBtn.isSelected = getSetParameter(enableMicphone) != nil ? !getSetParameter(enableMicphone)! : false
        cameraBtn.isSelected = getSetParameter(enableCamera) != nil ? !getSetParameter(enableCamera)! : false

        meetingNumberTF.text = getUserParameter(anonymousNumber) != nil ? getUserParameter(anonymousNumber) : ""
        nameTF.text = getUserParameter(anonymousName) != nil ? getUserParameter(anonymousName) : Utils.judge(UIDevice.current.name)
        
        tabBg.layer.masksToBounds = true
        tabBg.layer.cornerRadius = 4
        tabBg.setAroundshadow(UIColor.black, CGSize(width: 0, height: 4), 0.3, 5)
        
        tab.layer.masksToBounds = true
        tab.layer.cornerRadius = 4
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func gethistroyCallNumber() {
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
    
    @objc func removeHistoryCall(_ sender: UIButton) {
        histroyArr.removeObject(at: sender.tag)
        UserDefaults.standard.setValue(histroyArr, forKey: histroyCall)
        
        showOrHiddenTabMethod()
    }
    
    @objc func buttonMethod(sender: UIButton) {
        let setInfo = getSetPlist()
        
        switch sender {
        case backBtn:
            dismiss(animated: true, completion: nil)
            break
        case joinBtn:
            joinBtnAction()
            break
        case cameraBtn:
            cameraBtn.isSelected = !cameraBtn.isSelected
            setInfo.setValue(!cameraBtn.isSelected, forKey: enableCamera)
            break
        case micPhoneBtn:
            micPhoneBtn.isSelected = !micPhoneBtn.isSelected
            setInfo.setValue(!micPhoneBtn.isSelected, forKey: enableMicphone)
            break
        case hiddenHistoryTabBtn:
            showOrHiddenTabMethod()
            break
        default: break
        }
        
        PlistUtils.savePlistFile(setInfo as! [AnyHashable : Any], withFileName: setPlist)
    }
    
    func joinBtnAction() {
        view.endEditing(true)
        
        if meetingNumberTF.text?.count == 0 {
            showHud("alert.inputmeetingnumber".localized, view, .MBProgressHUBPositionBottom, 3)
        }else if !Utils.judgeSpecialCharacter(["\"", "<", ">"], withStr: nameTF.text!) {
            view.endEditing(true)
            showHud("alert.specialcharacter".localized, view, .MBProgressHUBPositionBottom, 2)
        }else {
            let userInfo = getUserPlist()
            
            if meetingNumberTF.text!.contains("*") {
                var number = (meetingNumberTF.text!.components(separatedBy: "*") as Array)[0]
                let password = (meetingNumberTF.text!.components(separatedBy: "*") as Array)[1]
                
                userInfo.setValue(number, forKey: anonymousNumber)
                userInfo.setValue(nameTF.text!, forKey: anonymousName)
                
                number = number.replacingOccurrences(of: " ", with: "")
                getTabBarVC().anonymousDialCall(getInfoString("CloudLoginServer"), "0", number, true, nameTF.text!, password, .conf)
            }else {
                userInfo.setValue(meetingNumberTF.text!, forKey: anonymousNumber)
                userInfo.setValue(nameTF.text!, forKey: anonymousName)
                
                meetingNumberTF.text = meetingNumberTF.text?.replacingOccurrences(of: " ", with: "")
                getTabBarVC().anonymousDialCall(getInfoString("CloudLoginServer"), "0", meetingNumberTF.text!, true, nameTF.text!, "", .conf)
            }
            
            PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName: userPlist)
        }
    }
    
    func showOrHiddenTabMethod() {
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
    
    func onError_(forMg err: EVError) {
        DDLogWrapper.logInfo("sdk onError msg:\(err.msg) code:\(err.code)")
        
        appDelegate.hiddenConnectWindow()
        
        if err.type == .sdk || err.type == .locate {
            if err.code == 10009 {
                showHud("alert.invalidConfNumber".localized, view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 8 {
                showHud("error.8".localized, view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 9 {
                showHud("error.9".localized, view, .MBProgressHUBPositionBottom, 3)
            }else {
                showHud("alert.cantconnert.server".localized, view, .MBProgressHUBPositionBottom, 3)
            }
        }
    }
}
