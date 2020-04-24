//
//  PrivateLoginVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension PrivateLoginVC {
    func initContent() {
        serverTF.setBorder(4, .BorderTypeAllCorners, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        accoutTF.setBorder(4, .BorderTypeAllCorners, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        passwordTF.setBorder(4, .BorderTypeAllCorners, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
        backBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        advancedSetBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        
        serverTF.text = getUserParameter(server) != nil ? getUserParameter(server) : ""
        accoutTF.text = getUserParameter(username) != nil ? getUserParameter(username) : ""
        passwordTF.text = getUserParameter(password) != nil ? getUserParameter(password) : ""
    }
    
    func autoLogin() {
        Manager.shared().addDelegate(self)
        
        if getUserParameter(loginState) != nil && getUserParameter(loginState) == "YES" {
            if serverTF.text?.count == 0 {
                showHud("login.note.writeServerAddress".localized, view, .MBProgressHUBPositionBottom, 3)
            }else if accoutTF.text?.count == 0 || passwordTF.text?.count == 0 {
                showHud("login.note.loginIn".localized, view, .MBProgressHUBPositionBottom, 3)
            }else {
                view.endEditing(true)
                
                let userInfo = getUserPlist()
                userInfo.setValue("NO", forKey: loginState)
                PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName: userPlist)
                
                if getUserParameter(port)?.count != 0 {
                    userLogin(withServer: serverTF.text!, withPort: Int(getUserParameter(port) ?? "0")!, withAccout: accoutTF.text!, withPassword: passwordTF.text!)
                }else {
                    userLogin(withServer: serverTF.text!, withPort: 0, withAccout: accoutTF.text!, withPassword: passwordTF.text!)
                }

                
                showHud("login.note.loginIn".localized, view, .MBProgressHUBPositionCenter, 3)
                DDLogWrapper.logInfo("user login server:\(serverTF.text!) port:\(getUserParameter(port) ?? "") accout:\(accoutTF.text!)")
            }
        }
    }
    
    @objc func buttonMethod(sender: UIButton) {
        switch sender {
        case backBtn:
            dismiss(animated: true, completion: nil)
            break
        case loginBtn:
            self.view.endEditing(true)
            if serverTF.text?.count == 0 {
                showHud("login.note.writeServerAddress".localized, view, .MBProgressHUBPositionBottom, 3)
            }else if accoutTF.text?.count == 0 || passwordTF.text?.count == 0 {
                showHud("login.note.writePassWord".localized, view, .MBProgressHUBPositionBottom, 3)
            }else {
                if getUserParameter(port)?.count != 0 {
                    userLogin(withServer: serverTF.text!, withPort: Int(getUserParameter(port) ?? "0")!, withAccout: accoutTF.text!, withPassword: passwordTF.text!)
                }else {
                    userLogin(withServer: serverTF.text!, withPort: 0, withAccout: accoutTF.text!, withPassword: passwordTF.text!)
                }

                showHud("login.note.loginIn".localized, view, .MBProgressHUBPositionCenter, 3)
                
                DDLogWrapper.logInfo("user login server:\(serverTF.text!) port:\(getUserParameter(port) ?? "") accout:\(accoutTF.text!)")
            }
            break
        case advancedSetBtn:
            PresentAdvancedSettingVCPage(animated: true, presentStyle: .fullScreen)
            break
        default: break
        }
    }
    
    func userLoginSucceed(_ user:EVUserInfo) {
        if hud != nil {
            hud.hide(animated: true)
        }
        
        let userInfo = getUserPlist()
        userInfo.setValue("YES", forKey: loginState)
        userInfo.setValue(serverTF.text!, forKey: server)
        userInfo.setValue("private", forKey: loginMethod)
        userInfo.setValue(passwordTF.text!, forKey: password)
        PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName: userPlist)
        
        disMissAllModelController(animated: true)
        
        if getTabBarVC().needDelayJoin {
            getTabBarVC().needDelayJoin = false
            getTabBarVC().dialCall(sipNumber: getTabBarVC().meetingIdStr, isVideoMode: true, disPlayName: getUserParameter(displayName) ?? "", withPassword: getTabBarVC().passwordStr, callType: .conf)
        }
        
    }
    
    func onError_(forMg err: EVError) {
        DDLogWrapper.logInfo("sdk onError msg:\(err.msg) code:\(err.code)")
        if err.type == .sdk || err.type == .locate {
            if err.code == 10009 {
                showHud("errorcode.1100".localized, view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 8 && err.action == "loginWithLocation" {
                showHud("error.8".localized, view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 9 && err.action == "loginWithLocation" {
                showHud("error.9".localized, view, .MBProgressHUBPositionBottom, 3)
            }else {
                if err.action == "downloadUserImage" {
                    return
                }
                showHud("alert.cantconnert.server".localized, view, .MBProgressHUBPositionBottom, 3)
            }
        }else if err.type == .server {
            if err.code == 1101 {
                let alert = "\("alert.passworderror1".localized) \(String((err.args?[0])!)) \("alert.passworderror2".localized)"
                showHud(alert, view, .MBProgressHUBPositionBottom, 3)
                appDelegate.evengine.logout()
                DDLogWrapper.logInfo("evengine.logout()");
            }else if err.code == 1102 {
                showHud("alert.passworderror3".localized, view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 1100 {
                showHud("errorcode.1100".localized, view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 1112 {
                showHud("error.1112".localized, view, .MBProgressHUBPositionBottom, 3)
            }else {
                showHud("alert.cantconnert.server".localized, view, .MBProgressHUBPositionBottom, 3)
            }
        }
        
    }
}
