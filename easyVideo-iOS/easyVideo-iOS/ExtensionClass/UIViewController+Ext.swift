//
//  UIViewController+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/4.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation
import WebKit
import MobileCoreServices
import MessageUI

// MARK: BaseViewController
extension BaseViewController {
    
    func showHud(_ message: String, _ view: UIView, _ position: MBProgressHUBPosition, _ afterDelay: TimeInterval) {
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud.isUserInteractionEnabled = false
        hud.mode = .text
        hud.detailsLabel.text = message
        hud.margin = 10.0
        let offSetY = view.height/2 - 122
        switch position {
        case .MBProgressHUBPositionTop:
            hud.offset.y = -offSetY
            break
        case .MBProgressHUBPositionCenter:
            hud.offset.y = 0
            break
        case .MBProgressHUBPositionBottom:
            hud.offset.y = offSetY
            break
        }
        hud.hide(animated: true, afterDelay: afterDelay)
    }
    
    func hiddenNav() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNav() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func hiddenTabBar() {
        let views: NSArray = self.tabBarController!.view.subviews as NSArray
        let tabbarView: UIView = views[0] as! UIView
        let tabbar = UITabBarController()
        let tabBarHeight: CGFloat = tabbar.tabBar.frame.size.height
        
        tabbarView.height -= tabBarHeight
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabBar() {
        let views: NSArray = self.tabBarController!.view.subviews as NSArray
        let tabbarView: UIView = views[0] as! UIView
        let tabbar = UITabBarController()
        let tabBarHeight: CGFloat = tabbar.tabBar.frame.size.height

        tabbarView.height += tabBarHeight
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func customNavItem() {
        let navTitleFont = UIFont.boldSystemFont(ofSize: 17)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(formHexString: "0x313131") as Any, NSAttributedString.Key.font: navTitleFont as Any]
        UIBarButtonItem.appearance().tintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func createBackItem() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 40))
        view.backgroundColor = UIColor.clear
        let button = UIButton(type: .custom)
        let image = UIImage.init(named: "btn_back")
        let imageview = UIImageView.init(image: image)
        imageview.frame = CGRect(x: 0, y: 10, width: 18, height: 18)
        button.frame = CGRect(x: 0, y: 0, width: 42, height: 40)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        view.addSubview(button)
        view.addSubview(imageview)
        
        let backButtonItem = UIBarButtonItem(customView: view)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        space.width = -17
        self.navigationItem.leftBarButtonItems = [space, backButtonItem]
    }
    
    func updateToken(_ webkit: WKWebView) {
        let jsStr = "window.updateToken('\(appDelegate.evengine.getUserInfo()?.token ?? "")')"
        webkit.evaluateJavaScript(jsStr, completionHandler: nil)
    }
    
    func deleteWebCache() {
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0)) {
            
        }
    }
    
    func saveWebLog(_ log: String) {
        WebLogTool.saveLog(log)
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getTabBarVC() -> BaseTabBarVC {
        return appDelegate.window!.rootViewController as! BaseTabBarVC
    }
    
    func sendEmail() {
        DDLogWrapper.logInfo("send Email")
        
        if MFMailComposeViewController.canSendMail() {
            let zip = ZipArchive()
            let path = FileTools.getDocumentsFailePath() + "/Log"
            var zipFile = path + "/log.zip"
            
            let data1 = path + "/evsdk1.log"
            let data2 = path + "/evsdk2.log"
            let data3 = path + "/evsdk3.log"
            let data4 = path + "/EVUILOG.log"
            let data5 = path + "/EVUILOG2.log"
            let data6 = path + "/crash.txt"
            let data7 = path + "/weblog.log"
            let data8 = path + "/weblog2.log"
            let data9 = FileTools.getDocumentsFailePath() + "/emsdk1.log"
            let data10 = FileTools.getDocumentsFailePath() + "/emsdk2.log"
            let data11 = FileTools.getDocumentsFailePath() + "/emsdk3.log"
            
            if zip.createZipFile2(zipFile) {
                zip.addFile(toZip: data1, newname: "evsdk1.log")
                zip.addFile(toZip: data2, newname: "evsdk2.log")
                zip.addFile(toZip: data3, newname: "evsdk3.log")
                zip.addFile(toZip: data4, newname: "EVUILOG.log")
                zip.addFile(toZip: data5, newname: "EVUILOG2.log")
                zip.addFile(toZip: data6, newname: "crash.txt")
                zip.addFile(toZip: data7, newname: "weblog.log")
                zip.addFile(toZip: data8, newname: "weblog2.log")
                zip.addFile(toZip: data9, newname: "emlog1.log")
                zip.addFile(toZip: data10, newname: "emlog2.log")
                zip.addFile(toZip: data11, newname: "emlog3.log")
            }
            
            if !zip.closeZipFile2() {
                zipFile = "textPic";
            }
            
            let picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            picker.setSubject("CFBundleDisplayName".infoPlist + "conf.questionDiagnose".localized)
            picker.setToRecipients(["appsupport@cninnovatel.com"])
            picker.setCcRecipients([""])
            picker.setMessageBody("conf.questionDiagnose.detail".localized, isHTML: true)
            picker.addAttachmentData(try! NSData(contentsOfFile:zipFile) as Data, mimeType: "application/zip", fileName:"\("CFBundleDisplayName".infoPlist) version:\(getInfoString("CFBundleShortVersionString"))_log.zip")
            picker.navigationBar.isTranslucent = false
            picker.modalPresentationStyle = .fullScreen
            picker.navigationBar.tintColor = UIColor.black
            picker.navigationBar.barStyle = .default
            UIBarButtonItem.appearance().tintColor = UIColor.black
            
            present(picker, animated: true, completion: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
        }else {
            showHud("alert.emailnotSet".localized, self.view, .MBProgressHUBPositionBottom, 2)
        }
    }
}

// MARK: LoginVC+Ext
extension LoginVC {
    func initContent() -> Void {
        let companyGest = UITapGestureRecognizer(target: self, action: #selector(self.companyTap))
        let cloudGest = UITapGestureRecognizer(target: self, action: #selector(self.cloudTap))
        
        self.companyImg.addGestureRecognizer(companyGest)
        self.cloudImg.addGestureRecognizer(cloudGest)
        
        companyLb.text = "CompanyName".infoPlist
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func viewWillAppear() {
        DispatchQueue.once(token: "LoginVC", block: {
            if getUserPlist()[loginMethod] != nil {
                if getUserPlist()[loginMethod] as? String == "cloud" {
                    PresentCloudVCPage(animated: false, presentStyle: .fullScreen)
                }else if getUserPlist()[loginMethod] as? String == "private" {
                    PresentPrivatePage(animated: false, presentStyle: .fullScreen)
                }
            }
        })
    }
    
    @objc func companyTap() -> Void {
        PresentPrivatePage(animated: true, presentStyle: .fullScreen)
    }
    
    @objc func cloudTap() -> Void {
        PresentCloudVCPage(animated: true, presentStyle: .fullScreen)
    }
}

// MARK: PrivateVC+Ext
extension PrivateVC {
    func initContent() {
        backBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        joinMeetingBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        setBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
    }
    
    func viewWillAppear() {
        DispatchQueue.once(token: "CloudVC", block: {
            if getUserParameter(loginState) != nil {
                PresentPrivateLoginVCPage(animated: false, presentStyle: .fullScreen)
            }
        })
    }
    
    @objc func buttonMethod(sender: UIButton) {
        switch sender {
        case backBtn:
            dismiss(animated: true, completion: nil)
            break
        case joinMeetingBtn:
            PresentPrivateJoinVCPage(animated: true, presentStyle: .fullScreen)
            break
        case loginBtn:
            PresentPrivateLoginVCPage(animated: true, presentStyle: .fullScreen)
            break
        case setBtn:
            PresentLoginSettingVCPage(animated: true, presentStyle: .fullScreen)
            break
        default: break
        }
    }
}

// MARK: CloudVC+Ext
extension CloudVC {
    func initContent() {
        backBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        joinMeetingBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        setBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
    }
    
    func viewWillAppear() {
        DispatchQueue.once(token: "CloudVC", block: {
            if getUserParameter(loginMethod) != nil {
                PresentCloudLoginVCPage(animated: false, presentStyle: .fullScreen)
            }
        })
    }
    
    @objc func buttonMethod(sender: UIButton) {
        switch sender {
        case backBtn:
            dismiss(animated: true, completion: nil)
            break
        case joinMeetingBtn:
            PresentCloudJoinVCCPage(animated: true, presentStyle: .fullScreen)
            break
        case loginBtn:
            PresentCloudLoginVCPage(animated: true, presentStyle: .fullScreen)
            break
        case setBtn:
            PresentLoginSettingVCPage(animated: true, presentStyle: .fullScreen)
            break
        default: break
        }
    }
}

// MARK: PrivateJoinVC+Ext
extension PrivateJoinVC {
    func initContent() {
        backBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        micPhoneBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        joinBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        advancedSetBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        hiddenHistoryTabBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)

        cameraBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        micPhoneBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        serverTF.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
        meetingNumberTF.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        meetingNumberTF.maxTextLength = 32
        
        nameTF.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)

        micPhoneBtn.isSelected = getSetParameter(enableMicphone) != nil ? !getSetParameter(enableMicphone)! : false
        cameraBtn.isSelected = getSetParameter(enableCamera) != nil ? !getSetParameter(enableCamera)! : false

        serverTF.text = getUserParameter(anonymousServer) != nil ? getUserParameter(anonymousServer) : ""
        meetingNumberTF.text = getUserParameter(anonymousNumber) != nil ? getUserParameter(anonymousNumber) : ""
        nameTF.text = getUserParameter(anonymousName) != nil ? getUserParameter(anonymousName) : Utils.judge(UIDevice.current.name)
        
        tabBg.setLayer(true, 4, nil, nil)
        tabBg.setAroundshadow(UIColor.black, CGSize(width: 0, height: 4), 0.3, 5)
        
        tab.setLayer(true, 4, nil, nil)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        case cameraBtn:
            cameraBtn.isSelected = !cameraBtn.isSelected
            setInfo.setValue(!cameraBtn.isSelected, forKey: enableCamera)
            break
        case micPhoneBtn:
            micPhoneBtn.isSelected = !micPhoneBtn.isSelected
            setInfo.setValue(!micPhoneBtn.isSelected, forKey: enableMicphone)
            break
        case joinBtn:
            joinBtnAction()
            break
        case advancedSetBtn:
            PresentAdvancedSettingVCPage(animated: true, presentStyle: .fullScreen)
            break
        case hiddenHistoryTabBtn:
            showOrHiddenTabMethod()
            break
        default: break
        }
        
        PlistUtils.savePlistFile(setInfo as! [AnyHashable : Any], withFileName: setPlist)
    }
    
    func joinBtnAction() {
        self.view.endEditing(true)
        if serverTF.text?.count == 0 {
            showHud("login.note.writeServerAddress".localized, self.view, .MBProgressHUBPositionBottom, 3)
        }else if meetingNumberTF.text?.count == 0 {
            showHud("alert.inputmeetingnumber".localized, self.view, .MBProgressHUBPositionBottom, 3)
        }else {
            let userInfo = getUserPlist()
            let portstr = getUserParameter(port) != nil ? getUserParameter(port) : "0"
            
            if meetingNumberTF.text!.contains("*") {
                var number = (meetingNumberTF.text!.components(separatedBy: "*") as Array)[0]
                let password = (meetingNumberTF.text!.components(separatedBy: "*") as Array)[1]
                
                userInfo.setValue(number, forKey: anonymousNumber)
                userInfo.setValue(nameTF.text!, forKey: anonymousName)
                userInfo.setValue(serverTF.text!, forKey: anonymousServer)
                
                number = number.replacingOccurrences(of: " ", with: "")
                getTabBarVC().anonymousDialCall(serverTF.text!, portstr!, number, true, nameTF.text!, password, .conf)
            }else {
                userInfo.setValue(meetingNumberTF.text!, forKey: anonymousNumber)
                userInfo.setValue(nameTF.text!, forKey: anonymousName)
                userInfo.setValue(serverTF.text!, forKey: anonymousServer)
                
                meetingNumberTF.text = meetingNumberTF.text?.replacingOccurrences(of: " ", with: "")
                getTabBarVC().anonymousDialCall(serverTF.text!, portstr!, meetingNumberTF.text!, true, nameTF.text!, "", .conf)
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
                showHud("alert.invalidConfNumber".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 8 {
                showHud("error.8".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 9 {
                showHud("error.9".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else {
                showHud("alert.cantconnert.server".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }
        }
    }
}

// MARK: PrivateLoginVC+Ext
extension PrivateLoginVC {
    func initContent() {
        serverTF.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
        accoutTF.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
        passwordTF.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
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
                showHud("login.note.writeServerAddress".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if accoutTF.text?.count == 0 || passwordTF.text?.count == 0 {
                showHud("login.note.loginIn".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else {
                self.view.endEditing(true)
                
                let userInfo = getUserPlist()
                userInfo.setValue("NO", forKey: loginState)
                PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName: userPlist)
                
                if getUserParameter(port)?.count != 0 {
                    userLogin(withServer: serverTF.text!, withPort: Int(getUserParameter(port) ?? "0")!, withAccout: accoutTF.text!, withPassword: passwordTF.text!)
                }else {
                    userLogin(withServer: serverTF.text!, withPort: 0, withAccout: accoutTF.text!, withPassword: passwordTF.text!)
                }

                
                showHud("login.note.loginIn".localized, self.view, .MBProgressHUBPositionCenter, 3)
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
                showHud("login.note.writeServerAddress".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if accoutTF.text?.count == 0 || passwordTF.text?.count == 0 {
                showHud("login.note.writePassWord".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else {
                if getUserParameter(port)?.count != 0 {
                    userLogin(withServer: serverTF.text!, withPort: Int(getUserParameter(port) ?? "0")!, withAccout: accoutTF.text!, withPassword: passwordTF.text!)
                }else {
                    userLogin(withServer: serverTF.text!, withPort: 0, withAccout: accoutTF.text!, withPassword: passwordTF.text!)
                }

                showHud("login.note.loginIn".localized, self.view, .MBProgressHUBPositionCenter, 3)
                
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
                showHud("errorcode.1100".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 8 && err.action == "loginWithLocation" {
                showHud("error.8".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 9 && err.action == "loginWithLocation" {
                showHud("error.9".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else {
                if err.action == "downloadUserImage" {
                    return
                }
                showHud("alert.cantconnert.server".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }
        }else if err.type == .server {
            if err.code == 1101 {
                let alert = "\("alert.passworderror1".localized) \(String((err.args?[0])!)) \("alert.passworderror2".localized)"
                showHud(alert, self.view, .MBProgressHUBPositionBottom, 3)
                appDelegate.evengine.logout()
                DDLogWrapper.logInfo("evengine.logout()");
            }else if err.code == 1102 {
                showHud("alert.passworderror3".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 1100 {
                showHud("errorcode.1100".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 1112 {
                showHud("error.1112".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else {
                showHud("alert.cantconnert.server".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }
        }
        
    }
}

// MARK: AdvancedSettingVC+Ext
extension AdvancedSettingVC {
    func initContent() {
        portTF.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
        httpSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        httpSwitch.isOn = getSetParameter(enableHttps) != nil ? getSetParameter(enableHttps)! : false
        portTF.text = getUserParameter(port) != nil ? getUserParameter(port) : ""
    }
    
    @objc func switchAction(sender: UISwitch) {
        let setInfo = getSetPlist()
        setInfo.setValue(sender.isOn, forKey: enableHttps)
        appDelegate.evengine.enableSecure(sender.isOn)
        PlistUtils.savePlistFile(setInfo as! [AnyHashable : Any], withFileName: setPlist)
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveAction() {
        let userInfo = NSMutableDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(userPlist))
        
        portTF.text?.count != 0 ? userInfo.setValue(portTF.text, forKey: port):userInfo.setValue("", forKey: port)
        PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName: userPlist)
        
        backAction()
    }
}

// MARK: LoginSettingVC+Ext
extension LoginSettingVC {
    func initContent() {
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: CloudLoginVC+Ext
extension CloudLoginVC {
    func initContent() {
        backBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        
        accoutTF.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
        passwordTF.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
        accoutTF.text = getUserParameter(username) != nil ? getUserParameter(username) : ""
        passwordTF.text = getUserParameter(password) != nil ? getUserParameter(password) : ""
    }
    
    func autoLogin() {
        Manager.shared().addDelegate(self)
        
        if getUserParameter(loginState) != nil && getUserParameter(loginState) == "YES" {
            self.view.endEditing(true)
            let userInfo = getUserPlist()
            userInfo.setValue("NO", forKey: loginState)
            PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName: userPlist)
            DDLogWrapper.logInfo("user login server:\(getInfoString("CloudLoginServer")) port:0 accout:\(accoutTF.text!)")
            userLogin(withServer: getInfoString("CloudLoginServer"), withPort: 0, withAccout: accoutTF.text!, withPassword: passwordTF.text!)
            showHud("login.note.loginIn".localized, self.view, .MBProgressHUBPositionCenter, 3)
        }
    }
    
    func userLoginSucceed(_ user:EVUserInfo) {
        hud.hide(animated: true)
        let userInfo = NSMutableDictionary(dictionary: PlistUtils.loadPlistFilewithFileName(userPlist))
        userInfo.setValue("YES", forKey: loginState)
        userInfo.setValue("cloud", forKey: loginMethod)
        userInfo.setValue(passwordTF.text!, forKey: password)
        PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName: userPlist)
        
        disMissAllModelController(animated: false)
        
        if getTabBarVC().needDelayJoin {
            getTabBarVC().needDelayJoin = false
            getTabBarVC().dialCall(sipNumber: getTabBarVC().meetingIdStr, isVideoMode: true, disPlayName: getUserParameter(displayName) ?? "", withPassword: getTabBarVC().passwordStr, callType: .conf)
        }
    }
    
    func onError_(forMg err: EVError) {
        DDLogWrapper.logInfo("[UI] onError msg:\(err.msg) code:\(err.code)")
        if err.type == .sdk || err.type == .locate {
            if err.code == 10009 {
                showHud("errorcode.1100".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 8 && err.action == "loginWithLocation" {
                showHud("error.8".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 9 && err.action == "loginWithLocation" {
                showHud("error.9".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else {
                if err.action == "downloadUserImage" {
                    return
                }
                showHud("alert.cantconnert.server".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }
        }else if err.type == .server {
            if err.code == 1101 {
                let alert = "\("alert.passworderror1".localized) \(String((err.args?[0])!)) \("alert.passworderror2".localized)"
                appDelegate.evengine.logout()
                DDLogWrapper.logInfo("evengine.logout()");
                showHud(alert, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 1102 {
                showHud("alert.passworderror3".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 1100 {
                showHud("errorcode.1100".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 1112 {
                showHud("error.1112".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else {
                showHud("alert.cantconnert.server".localized, self.view, .MBProgressHUBPositionBottom, 3)
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
            if accoutTF.text?.count == 0 || passwordTF.text?.count == 0 {
                showHud("login.note.writePassWord".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else {
                DDLogWrapper.logInfo("user login server:\(getInfoString("CloudLoginServer")) port:0 accout:\(accoutTF.text!)")
                userLogin(withServer: getInfoString("CloudLoginServer"), withPort: 0, withAccout: accoutTF.text!, withPassword: passwordTF.text!)
                showHud("login.note.loginIn".localized, self.view, .MBProgressHUBPositionCenter, 3)
            }
            break
        default: break
        }
    }
}

// MARK:CloudJoinVC+Ext
extension CloudJoinVC {
    func initContent() {
        meetingNumberTF.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        meetingNumberTF.maxTextLength = 32
        
        nameTF.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
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
        
        tabBg.setLayer(true, 4, nil, nil)
        tabBg.setAroundshadow(UIColor.black, CGSize(width: 0, height: 4), 0.3, 5)
        
        tab.setLayer(true, 4, nil, nil)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
            showHud("alert.inputmeetingnumber".localized, self.view, .MBProgressHUBPositionBottom, 3)
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
                showHud("alert.invalidConfNumber".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 8 {
                showHud("error.8".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else if err.code == 9 {
                showHud("error.9".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }else {
                showHud("alert.cantconnert.server".localized, self.view, .MBProgressHUBPositionBottom, 3)
            }
        }
    }
}

// MARK: MeetingVC+Ext
extension MeetingVC {
    func createWKWebView() {
        
        let prefrences = WKPreferences()
        let userContentController = WKUserContentController()
        let webConfiguration = WKWebViewConfiguration()
        userContentController.add(self, name: "callbackObj")
        
        webConfiguration.preferences = prefrences
        webConfiguration.preferences.minimumFontSize = 10
        webConfiguration.preferences.javaScriptEnabled = true
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        webConfiguration.userContentController = userContentController
        
        webKit = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webKit.navigationDelegate = self
        
        self.view.addSubview(webKit)
        
        createMaskView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onRegisterOK), name: NSNotification.Name(rawValue: "onRegisterOK"), object: nil)
    }
    
    func userContentController_(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackObj" {
            let body = "\(message.body)"
            if body.contains("joinConf") {
                joinConf(body)
            }else if body.contains("isShowNav") {
                whetherNeedtoDisplatabBar(message)
            }else if body.contains("shareWechat") {
                shareWechat(body)
            }else if body.contains("shareEmail") {
                shareEmail(body)
            }else if body.contains("tokenExpired") {
                updateToken(webKit)
                loadMeetingVCWeb()
            }else if body.contains("clearCache") {
                deleteWebCache()
                loadMeetingVCWeb()
            }else if body.contains("webLog") {
                saveWebLog(body)
            }
        }
    }

    func createMaskView() {
        maskView = HLogingView.hlogingViewCreateShowTitel("alert.HLogingView.titleTrying".localized, reloadEvent: {
            self.loadMeetingVCWeb()
        }, isShowBtn: false)
        self.view.addSubview(maskView!)
    }
    
    func loadMeetingVCWeb() {
        if getUserParameter(loginState) == "YES" {
            let token = appDelegate.evengine.getUserInfo()?.token ?? ""
            if token == "" {
                didFailProvisionalNavigation()
                return
            }
            // var testUrl = "http://192.168.1.2:4013"
            // var url = "\(testUrl)/#/conferences?token=\(token)"
            
            var url = "\(getUserParameter(customizedH5UrlPrefix) ?? "")/mobile/#/conferences?token=\(token)"
            
            let languages = NSLocale.preferredLanguages
            let currentLanguage = languages[0]
            if currentLanguage.contains("zh") {
                url = "\(url)&lang=cn&v=\(getUserParameter(doradoVersion) ?? "")"
            }else {
                url = "\(url)&lang=en&v=\(getUserParameter(doradoVersion) ?? "")"
            }
            webKit.load(URLRequest(url: URL(string: url)!))
            DDLogWrapper.logInfo("MeetingVC url:\(url)")
        }
    }
    
    func joinConf(_ str:String) {
        let json = (str.components(separatedBy: "$") as Array)[1]
        if json.count == 0 {
            return
        }
        
        DDLogWrapper.logInfo("web meeting joinconf jsonStr:\(str)")
        
        let jsonData = json.data(using: .utf8)
        let dic = try? (JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as! Dictionary<String, Any>)
        let meetId = "\(dic!["numericId"] ?? "")"
        let password = "\(dic!["password"] ?? "")"
        
        let setInfo = getSetPlist()
        
        if (dic?.keys.contains("cameraStatus"))! {
            if "\(dic!["cameraStatus"]!)" == "0" {
                setInfo.setValue(true, forKey: enableCamera)
            }else {
                setInfo.setValue(false, forKey: enableCamera)
            }
        }else {
            setInfo.setValue(true, forKey: enableCamera)
        }
        
        if (dic?.keys.contains("microphoneStatus"))! {
            if "\(dic!["microphoneStatus"]!)" == "0" {
                setInfo.setValue(true, forKey: enableMicphone)
            }else {
                setInfo.setValue(false, forKey: enableMicphone)
            }
        }else {
            setInfo.setValue(true, forKey: enableMicphone)
        }
        
        PlistUtils.savePlistFile(setInfo as! [AnyHashable : Any], withFileName: setPlist)
 
        let userInfo = getUserPlist()
        getTabBarVC().dialCall(sipNumber: meetId, isVideoMode: true, disPlayName: "\(userInfo[displayName]!)", withPassword: password, callType: .conf)
    }
    
    func whetherNeedtoDisplatabBar(_ message:WKScriptMessage) {
        let isshowNav = ((message.body as! String).components(separatedBy: "$") as Array)[1]
        if isshowNav == "false" {
            hiddenTabBar()
        }else {
            showTabBar()
        }
    }
    
    func shareWechat(_ str:String) {
        DDLogWrapper.logInfo("shareWechat")
        
        let json = (str.components(separatedBy: "$") as Array)[1]
        if json.count == 0 {
            return
        }
        let jsonData = json.data(using: .utf8)
        let dic = try? (JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as! Dictionary<String, Any>)
        
        if !WXApi.isWXAppInstalled() {
            showHud("alert.wechat.notInstalled".localized, self.view, .MBProgressHUBPositionBottom, 2)
            return
        }
        
        
        if (dic?.keys.contains("confTime"))! {
            meetingShareWechat(dic!)
        }else {
            meetingNumbershareWechat(dic!)
        }
    }
    
    func shareEmail(_ str:String) {
        let emailLink = (str.components(separatedBy: "$") as Array)[1]
        UIApplication.shared.openURL(URL.init(string: emailLink)!)
    }
    
    func didStartProvisionalNavigation() {
        maskView?.isHidden = false
        maskView?.promptLabel.text = "alert.HLogingView.titleTrying".localized
        maskView?.promptLabel.isHidden = false
        maskView?.gifView.isHidden = false
        maskView?.reloadBtn.isHidden = true
        maskView?.noNetworkImage.isHidden = true
    }
    
    func didFinishNavigation(_ webView:WKWebView) {
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.isScrollEnabled = false
        maskView?.isHidden = true
    }
    
    func didFailProvisionalNavigation() {
        maskView?.promptLabel.text = "alert.HLogingView.titleLoadFailed".localized
        maskView?.promptLabel.isHidden = false
        maskView?.gifView.isHidden = true
        maskView?.reloadBtn.isHidden = false
        maskView?.reloadBtn.setTitle("alert.reload".localized, for: .normal)
        maskView?.noNetworkImage.isHidden = false
    }
    
    func meetingShareWechat(_ dict:Dictionary<String, Any>) {
        let message = WXMediaMessage()
        message.title = "\(dict["confName"] ?? "")"
        var numericId = "\(dict["numericId"] ?? "")"
        if dict["password"] != nil && (dict["password"] as! String).count != 0 {
            numericId = numericId + "*\(dict["password"]!)"
        }
        message.description = "\("conf.wechat.shared.meetingId".localized)\(numericId)\r\(dict["confTime"] ?? "")"
        message.setThumbImage(UIImage.init(named: "Icon-1041")!)
        
        let ext = WXWebpageObject()
        ext.webpageUrl = (dict["url"] as! String).replacingOccurrences(of: "\"", with: "")
        message.mediaObject = ext
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        
        WXApi.send(req, completion: nil)
    }
    
    func meetingNumbershareWechat(_ dict:Dictionary<String, Any>) {
        let message = WXMediaMessage()
        message.title = "\(dict["name"] ?? "")\("conf.room.room".localized)"
        if dict["password"] != nil && (dict["password"] as! String).count != 0 {
            message.description = "\("conf.room.roomId".localized) \(dict["numericId"] ?? "")\r\("conf.password".localized)\(dict["password"] ?? "")"
        }else {
            message.description = "\("conf.room.roomId".localized) \(dict["numericId"] ?? "")"
        }
        message.setThumbImage(UIImage.init(named: "Icon-1041")!)
        
        let ext = WXWebpageObject()
        ext.webpageUrl = (dict["url"] as! String).replacingOccurrences(of: "\"", with: "")
        message.mediaObject = ext
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        
        WXApi.send(req, completion: nil)
    }
    
    @objc func onRegisterOK() {
        
        loadMeetingVCWeb()
    }
}

// MARK: JoinMeetingVC+Ext
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
        
        tabBg.setLayer(true, 4, nil, nil)
        tabBg.setAroundshadow(UIColor.black, CGSize(width: 0, height: 4), 0.3, 5)
        
        tab.setLayer(true, 4, nil, nil)
        
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
            showHud("alert.inputmeetingnumber".localized, self.view, .MBProgressHUBPositionBottom, 2)
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

// MARK: ChatVC+Ext

// MARK: ContactVC+Ext
extension ContactVC {
    func createWKWebView() {
        
        let prefrences = WKPreferences()
        let userContentController = WKUserContentController()
        let webConfiguration = WKWebViewConfiguration()
        userContentController .add(self, name: "callbackObj")
        
        webConfiguration.preferences = prefrences
        webConfiguration.preferences.minimumFontSize = 10
        webConfiguration.preferences.javaScriptEnabled = true
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        webConfiguration.userContentController = userContentController
        
        webKit = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webKit.navigationDelegate = self
        
        self.view.addSubview(webKit)
        
        createMaskView()
        
        loadMeetingVCWeb()
    }
    
    func userContentController_(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let body = "\(message.body)"
        
        if message.name == "callbackObj" {
            if body.contains("isShowNav") {
                whetherNeedtoDisplatabBar(message)
            }else if body.contains("p2pCall") {
                p2pCallMethod(message)
            }else if body.contains("tokenExpired") {
                updateToken(webKit)
                loadMeetingVCWeb()
            }else if body.contains("clearCache") {
                deleteWebCache()
                loadMeetingVCWeb()
            }else if body.contains("webLog") {
                saveWebLog(body)
            }
        }
    }
    
    func createMaskView() {
        maskView = HLogingView.hlogingViewCreateShowTitel("alert.HLogingView.titleTrying".localized, reloadEvent: {
            self.loadMeetingVCWeb()
        }, isShowBtn: false)
        self.view.addSubview(maskView!)
    }
    
    func loadMeetingVCWeb() {
        webKit.frame = self.view.frame
        
        let token = appDelegate.evengine.getUserInfo()?.token ?? ""
        if token == "" {
            didFailProvisionalNavigation()
            return
        }
        if getUserParameter(loginState) == "YES" {
            var url = "\(getUserParameter(customizedH5UrlPrefix) ?? "")/mobile/#/contacts?token=\(token)"
            
            let languages = NSLocale.preferredLanguages
            let currentLanguage = languages[0]
            if currentLanguage.contains("zh")  {
                url = "\(url)&lang=cn&v=\(getUserParameter(doradoVersion) ?? "")"
            }else {
                url = "\(url)&lang=en&v=\(getUserParameter(doradoVersion) ?? "")"
            }

            webKit.load(URLRequest(url: URL(string: url)!))
            DDLogWrapper.logInfo("ContactVC web url:\(url)")
        }
    }
    
    func whetherNeedtoDisplatabBar(_ message:WKScriptMessage) {
        let isshowNav = ((message.body as! String).components(separatedBy: "$") as Array)[1]
        if isshowNav == "false" {
            hiddenTabBar()
        }else {
            showTabBar()
        }
    }
    
    func p2pCallMethod(_ message:WKScriptMessage) {
        let json = ("\(message.body)".components(separatedBy: "$") as Array)[1]
        if json.count == 0 {
            return
        }
        let jsonData = json.data(using: .utf8)
        let dic = try? (JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as! Dictionary<String, Any>)
        if dic!["userId"] != nil {
            getTabBarVC().p2pDialCall("\(dic!["imageUrl"]!)", "\(dic!["userId"]!)", "\(dic!["displayName"]!)")
        }else {
            showHud("alert.cantconnert.server".localized, self.view, .MBProgressHUBPositionBottom, 3)
        }
    }
    
    func didStartProvisionalNavigation() {
        maskView?.isHidden = false
        maskView?.promptLabel.text = "alert.HLogingView.titleTrying".localized
        maskView?.promptLabel.isHidden = false
        maskView?.gifView.isHidden = false
        maskView?.reloadBtn.isHidden = true
        maskView?.noNetworkImage.isHidden = true
    }
    
    func didFinishNavigation(_ webView:WKWebView) {
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.isScrollEnabled = false
        maskView?.isHidden = true
    }
    
    func didFailProvisionalNavigation() {
        maskView?.promptLabel.text = "alert.HLogingView.titleLoadFailed".localized
        maskView?.promptLabel.isHidden = false
        maskView?.gifView.isHidden = true
        maskView?.reloadBtn.isHidden = false
        maskView?.reloadBtn.setTitle("alert.reload".localized, for: .normal)
        maskView?.noNetworkImage.isHidden = false
    }
}

// MARK: Me+Ext
extension MeVC {
    func initContent() {
        pushMeDetailBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        
        customNavItem()
    }
    
    func tableView_(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            pushSettingVC(animated: true)
            break
        case 1:
            modifyPasswordAction()
            break
        case 2:
            pushInvitaVC(animated: true)
            break
        case 3:
            pushAboutVC(animated: true)
            break
        default:
            break
        }
    }
    
    func setDisplayContent() {
        let headPath = "\(FileTools.getDocumentsFailePath())/header.jpg"
        let data = getSize(url: URL.init(string: headPath) ?? URL.init(string: "")!)
        if data != 0 {
            userImg.image = UIImage.init(contentsOfFile: headPath)
        }else {
            userImg.image = UIImage.init(named: "default_photo")
        }
        
        let userInfo = PlistUtils.loadPlistFilewithFileName(userPlist)
        accoutLb.text = userInfo[username] as? String
        disPlayNameLb.text = userInfo[displayName] as? String
    }
    
    func modifyPasswordAction() {
        let alert = UIAlertController(title: "alert.pwd.pop.title".localized, message: "alert.pwd.pop.content".localized, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "alert.password".localized
            textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "alert.cancel".localized, style: .default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "alert.sure".localized, style: .default, handler: { (_) in
            let textField = alert.textFields![0]
            if textField.text?.count != 0 {
                if textField.text == getUserParameter(password) {
                    self.pushModifyPasswordVC(animated: true)
                }else {
                    self.showHud("alert.passwordError".localized, self.view, .MBProgressHUBPositionBottom, 3)
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func buttonMethod(sender: UIButton) {
        switch sender {
        case pushMeDetailBtn:
            pushUserInformationVC(animated: true)
            break
        default: break
        }
    }
}

// MARK: SettingVC+Ext
extension SettingVC {
    func initContent() {
        title = "title.parametersetting".localized
        
        createBackItem()
    }
    
    func tableView_(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = NormalCell.cellWithTableViewForSeetingVC(tableView, IndexPath: indexPath)
            return cell
        }else if indexPath.section == 1 {
            let cell = NormalCell.cellWithTableViewForSeetingVC(tableView, IndexPath: indexPath)
            return cell
        }else {
            let cell = SwitchCell.cellWithTableView(tableView, indexRow: indexPath)
            return cell
        }
    }
    
    override func goBack() {
        if backBool {
            navigationController?.popViewController(animated: true)
        }else {
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: InvitaVC+Ext
extension InvitaVC {
    func initContent() {
        title = "me.invite".localized
        
        shareToOneBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        shareToGroupBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        
        createBackItem()
    }
    
    @objc func buttonMethod(sender: UIButton) {
        switch sender {
        case shareToOneBtn:
            sendLinkContent(0)
            break
        case shareToGroupBtn:
            sendLinkContent(1)
            break
        default: break
        }
    }
    
    func sendLinkContent(_ flag: Int32) {
        if !WXApi.isWXAppInstalled() {
            showHud("alert.wechat.notInstalled".localized, self.view, .MBProgressHUBPositionBottom, 2)
        }else {
            let message = WXMediaMessage()
            message.title = "CFBundleDisplayName".infoPlist
            message.description = "Appdescription".infoPlist
            message.setThumbImage(UIImage.init(named: "Icon-1041")!)
            
            let ext = WXWebpageObject()
            ext.webpageUrl = "AppDownloadlink".infoPlist
            message.mediaObject = ext
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = flag
            
            WXApi.send(req, completion: nil)
        }
    }
}

// MARK: ModifyPasswordVC+Ext
extension ModifyPasswordVC {
    func initContent() {
        title = "title.modifyPassword".localized
        
        let buttonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(modifyPasswordAction))
        buttonItem.tintColor = UIColor.init(formHexString: "0xf04848")
        navigationItem.rightBarButtonItem = buttonItem
        
        self.view.backgroundColor = UIColor.init(formHexString: "0xf7f7f7")
        
        createBackItem()
    }
    
    func tableView_(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NormalWithTFCell.cellWithTableViewForModifyPasswordVC(tableView, indexPath)
        if indexPath.section == 0 {
            cell.cellTitleLb.text = "alert.modifyp.accout".localized
            cell.cellTF.text = PlistUtils.loadPlistFilewithFileName(userPlist)[username] as? String
            cell.cellTF.isEnabled = false
        }else {
            if indexPath.row == 0 {
                cell.cellTitleLb.text = "alert.modifyp.password".localized
                cell.cellTF.placeholder = "alert.modifyp.input".localized
                cell.cellTF.isSecureTextEntry = true
            }else if indexPath.row == 1 {
                cell.cellTitleLb.text = "alert.modifyp.againpassword".localized
                cell.cellTF.placeholder = "alert.modifyp.agintinput".localized
                cell.cellTF.isSecureTextEntry = true
            }
        }
        return cell
    }
    
    @objc func modifyPasswordAction() {
        let cell = tab.cellForRow(at: NSIndexPath.init(row: 0, section: 1) as IndexPath) as! NormalWithTFCell
        let cell2 = tab.cellForRow(at: NSIndexPath.init(row: 1, section: 1) as IndexPath) as! NormalWithTFCell
        
        if cell.cellTF.text?.count == 0 || cell2.cellTF.text?.count == 0 {
            showHud("alert.pass.note.writeNew".localized, self.view, .MBProgressHUBPositionBottom, 3)
        }else if !CheckString(cell.cellTF.text!, 4, 16) {
            showHud("alert.pass.note.format".localized, self.view, .MBProgressHUBPositionBottom, 3)
        }else if cell.cellTF.text != cell2.cellTF.text {
            showHud("alert.pass.note.notMatch".localized, self.view, .MBProgressHUBPositionBottom, 3)
        }else {
            if appDelegate.evengine.changePassword(appDelegate.evengine.encryptPassword(PlistUtils.loadPlistFilewithFileName(userPlist)[password] as! String), newpassword: appDelegate.evengine.encryptPassword(cell.cellTF.text!)) == 0 {

                showHud("alert.changepasswordok".localized, self.view, .MBProgressHUBPositionBottom, 3)
                perform(#selector(loginOut), with: self, afterDelay: 1)
            }
        }
    }
    
    func CheckString(_ str: String, _ minLen: Int, _ maxLen: Int) -> Bool {
        if str.count > maxLen || str.count < minLen {
            return false
        }
        
        return true
    }
    
    @objc func loginOut() {
        if block != nil {
            block!()
        }
    }
}

// MARK: AboutVC+Ext
extension AboutVC {
    func initContent() {
        title = "title.about".localized
        
        companyCopyrightLb.text = "CompanyCopyright".infoPlist
        versionNumberLb.text = "CFBundleDisplayName".infoPlist + " " + getInfoString("CFBundleShortVersionString")
        
        createBackItem()
    }
    
    func checkVersion() {
        let appUrl = URL.init(string: "http://itunes.apple.com/lookup?id=\(getInfoString("Apple_Id"))")
        let appMsg = try? String.init(contentsOf: appUrl!, encoding: .utf8)
        let appMsgDict:NSDictionary = getDictFromString(jString: appMsg!)
        let appResultsArray:NSArray = (appMsgDict["results"] as? NSArray)!
        if appResultsArray.count==0 {
            return
        }
        
        let appResultsDict = appResultsArray.lastObject as! NSDictionary
        let appStoreVersion = appResultsDict["version"] as! String
        
        let localVersion = getInfoString("CFBundleShortVersionString")
        
        if localVersion != appStoreVersion {
            UIApplication.shared.openURL(URL.init(string: "itms-apps://itunes.apple.com/app/id\(getInfoString("Apple_Id"))")!)
        }else {
            showHud("alert.dontneedupload".localized, self.view, .MBProgressHUBPositionBottom, 2)
        }
        
    }
    
    override func goBack() {
        if backBool {
            navigationController?.popViewController(animated: true)
        }else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func getDictFromString(jString:String) -> NSDictionary {
        let jsonData:Data = jString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
}

// MARK: UserInformationVC+Ext
extension UserInformationVC {
    func initContent() {
        title = "title.infomation".localized
        
        createBackItem()
    }
    
    func tableView_(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = NormalWithImgCell.cellWithTableViewForUserInformationVC(tableView, indexRow: indexPath.row)
            return cell
        }else if indexPath.row == 1 {
            let cell = NormalCell.cellWithTableViewForUserInformationVC(tableView, indexRow: indexPath.row)
            return cell
        }else if (indexPath.row == 7) {
            let cell = LoginOutCell.cellWithTableView(tableView, indexRow: indexPath.row)
            return cell
        }else {
            let cell = NormalWithLbCell.cellWithTableViewForUserInformationVC(tableView, indexRow: indexPath.row)
            return cell
        }
    }
    
    func modifyDisPlayNameAction() {
        
        let alert = UIAlertController(title: "alert.changeName".localized, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "alert.updateName.propt".localized
            textField.text = PlistUtils.loadPlistFilewithFileName(userPlist)[displayName] as? String
        }
        alert.addAction(UIAlertAction(title: "alert.cancel".localized, style: .default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "alert.sure".localized, style: .default, handler: {[weak self] (_) in
            let textField = alert.textFields![0]
            if textField.text?.count != 0 {
                self?.appDelegate.evengine.changeDisplayName(textField.text!)
                
                DDLogWrapper.logInfo("changeDisplayName name:\(textField.text!)")
                
                let cell = self?.tab.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! NormalCell
                cell.cellDetailLb.text = textField.text!
                
                let userInfo = getUserPlist()
                userInfo.setValue(textField.text!, forKey: displayName)
                PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName:userPlist)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func loginOutAction() {
        Utils.showAlert("alert.note.loginout".localized, oneBtn: "alert.sure".localized, twoBtn: "alert.cancel".localized) {[weak self] (flag) in
            if flag {
                if self?.block != nil {
                    self?.block!()
                }
            }
        }
    }
    
    func modifyHeadImg() {
        
        Utils.showCameraAlert("takePhoto".localized, twoBtn: "takeLibrary".localized, threeBtn: "alert.cancel".localized) {[weak self] (flag) in
            if flag {
                if (self?.isCameraAvailable())! && (self?.doesCameraSupportTakingPhotos())! {
                    self?.imgPicker.sourceType = .camera
                    if (self?.isFrontCameraAvailable())! {
                        self?.imgPicker.cameraDevice = .front
                    }

                    self?.imgPicker.mediaTypes = [(kUTTypeImage as String)]
                    self?.imgPicker.delegate = self
                    self?.imgPicker.allowsEditing = false
                    self?.imgPicker.transitioningDelegate = self
                    self?.imgPicker.modalPresentationStyle = .fullScreen

                    self?.present(self!.imgPicker, animated: true, completion: {
                        DDLogWrapper.logInfo("[UI] user open camera")
                    })
                }
            }else {
                if (self?.isPhotoLibraryAvailable())! {
                    self?.imgPicker.navigationBar.isTranslucent = false
                    self?.imgPicker.navigationBar.tintColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
                    self?.imgPicker.navigationBar.barStyle = .default
                    self?.imgPicker.sourceType = .photoLibrary
                    self?.imgPicker.mediaTypes = [(kUTTypeImage as String)]
                    self?.imgPicker.delegate = self
                    self?.imgPicker.allowsEditing = false
                    self?.imgPicker.transitioningDelegate = self
                    self?.imgPicker.modalPresentationStyle = .fullScreen
                    self?.imgPicker.navigationBar.barTintColor = .white
                    UIBarButtonItem.appearance().tintColor = UIColor.black

                    self?.present(self!.imgPicker, animated: true, completion: {
                        self?.setNeedsStatusBarAppearanceUpdate()
                        DDLogWrapper.logInfo("[UI] user open PhotoLibrary")
                    })
                }
            }
        }
    }
    
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func doesCameraSupportTakingPhotos() -> Bool {
        return cameraSupportsMedia(String(kUTTypeImage), paramSourceType: .camera)
    }
    
    func cameraSupportsMedia(_ paramMediaType: String, paramSourceType: UIImagePickerController.SourceType) ->Bool {
        var result = false
        if paramMediaType.count == 0 {
            return result
        }
        let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: paramSourceType)! as NSArray
        availableMediaTypes.enumerateObjects { (obj, idx, stop) in
            let mediaType = obj as! String
            if mediaType ==  paramMediaType {
                result = true
            }
        }
        return result
    }
    
    func isFrontCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.front)
    }
    
    func isPhotoLibraryAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    func imageByScalingToMaxSize(_ sourceImage: UIImage) -> UIImage {
        if sourceImage.size.width < 200.0 {
            return sourceImage
        }
        
        var btWidth = 0.0
        var btHeight = 0.0
        
        if sourceImage.size.width > sourceImage.size.height {
            btHeight = 200.0
            btWidth = Double(sourceImage.size.width * (200.0 / sourceImage.size.height))
        }else {
            btWidth = 200.0
            btHeight = Double(sourceImage.size.width * (200.0 / sourceImage.size.height))
        }
        
        let targetSize = CGSize(width: btWidth, height: btHeight)
        
        return imageByScalingAndCroppingForSourceImage(sourceImage, targetSize)
    }
    
    func imageByScalingAndCroppingForSourceImage(_ sourceImage: UIImage,_ targetSize: CGSize) -> UIImage {
        var newImage:UIImage?
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        
        if __CGSizeEqualToSize(imageSize, targetSize) == false {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            
            if widthFactor > heightFactor {
                scaleFactor = Double(widthFactor)
            }else {
                scaleFactor = Double(heightFactor)
            }
            
            scaledWidth  = width * CGFloat(scaleFactor)
            scaledHeight = height * CGFloat(scaleFactor)
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }else if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width  = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        if (newImage != nil) {
            
        }
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

// MARK: TermsServiceVC+Ext
extension TermsServiceVC {
    func inintContent() {
        title = "title.termsservice".localized
        
        createBackItem()
    }
    
    func createWKWebView() {
        let prefrences = WKPreferences()
        let userContentController = WKUserContentController()
        let webConfiguration = WKWebViewConfiguration()
        
        webConfiguration.preferences = prefrences
        webConfiguration.preferences.minimumFontSize = 10
        webConfiguration.preferences.javaScriptEnabled = true
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        webConfiguration.userContentController = userContentController
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        let webKit = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webKit.load(URLRequest.init(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "licenseServer", ofType: "html")!)))
        
        view.addSubview(webKit)
    }
}

// MARK: ConnectingVC+Ext
extension ConnectingVC {
    func initContent() {
        hangUpBtn.addTarget(self, action: #selector(hangUpAction), for: .touchUpInside)
    }
    
    func creatRippleAnimationView() {
        if !(animationView != nil) {
            animationView = RippleAnimationView(frame: CGRect(x: 0, y: 0, width: 75, height: 75), animationType: .withBackground)!
        }
        
        view.addSubview(animationView!)
        view.bringSubviewToFront(callImg)
        view.bringSubviewToFront(sipNumberLb)
    }
    
    func removeRippleAnimationView() {
        if animationView != nil {
            animationView?.removeFromSuperview()
            animationView = nil
        }
    }
    
    @objc func hangUpAction() {
        appDelegate.hiddenConnectWindow()
    }
}

// MARK: ConferenceVC+Ext
extension ConferenceVC {
    func createWKWebView() {
        
        let prefrences = WKPreferences()
        let userContentController = WKUserContentController()
        let webConfiguration = WKWebViewConfiguration()
        userContentController.add(self, name: "callbackObj")
        
        webConfiguration.preferences = prefrences
        webConfiguration.preferences.minimumFontSize = 10
        webConfiguration.preferences.javaScriptEnabled = true
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        webConfiguration.userContentController = userContentController
        
        webKit = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webKit.navigationDelegate = self
        
        view.addSubview(webKit)
        
        createMaskView()
    }
    
    func createMaskView() {
        maskView = HLogingViewLandscape.hlogingViewCreateShowTitel("alert.HLogingView.titleTrying".localized, reloadEvent: {
            self.loadWebView(self.meetingNumber)
        }, isShowBtn: false)
        view.addSubview(maskView!)
    }
    
    func loadWebView(_ meetingId:String) {
        meetingNumber = meetingId
        let info = appDelegate.evengine.getUserInfo()
        let token = info?.token ?? ""
        if token == "" {
            didFailProvisionalNavigation()
            return
        }
        var url = "\(info?.customizedH5UrlPrefix ?? "")/mobile/#/confControl?numericId=\(meetingId)&token=\(token)&deviceId=\(info?.deviceId ?? 0)"
        
        let languages = NSLocale.preferredLanguages
        let currentLanguage = languages[0]
        if currentLanguage.contains("zh")  {
            url = "\(url)&lang=cn&v=\(info?.doradoVersion ?? "")"
        }else {
            url = "\(url)&lang=en&v=\(info?.doradoVersion ?? "")"
        }

        webKit.load(URLRequest(url: URL(string: url)!))
        DDLogWrapper.logInfo("ConferenceVC web url:\(url)")
    }
    
    func userContentController_(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackObj" {
            let body = "\(message.body)"
            if body.contains("tokenExpired") {
                updateToken(webKit)
                loadWebView(meetingNumber)
            }else if body.contains("clearCache") {
                deleteWebCache()
                loadWebView(meetingNumber)
            }else if body.contains("shareWechat") {
                shareWechat(body)
            }else if body.contains("shareEmail") {
                shareEmail(body)
            }else if body.contains("webLog") {
                saveWebLog(body)
            }
        }
    }
    
    func shareWechat(_ str:String) {
        DDLogWrapper.logInfo("shareWechat")
        
        let json = (str.components(separatedBy: "$") as Array)[1]
        if json.count == 0 {
            return
        }
        let jsonData = json.data(using: .utf8)
        let dic = try? (JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as! Dictionary<String, Any>)
        
        if !WXApi.isWXAppInstalled() {
            showHud("alert.wechat.notInstalled".localized, self.view, .MBProgressHUBPositionBottom, 2)
            return
        }
        
        if (dic?.keys.contains("confTime"))! {
            meetingShareWechat(dic!)
        }else {
            meetingNumbershareWechat(dic!)
        }
    }
    
    func meetingShareWechat(_ dict:Dictionary<String, Any>) {
        let message = WXMediaMessage()
        message.title = "\(dict["confName"] ?? "")"
        var numericId = "\(dict["numericId"] ?? "")"
        if dict["password"] != nil && (dict["password"] as! String).count != 0 {
            numericId = numericId + "*\(dict["password"]!)"
        }
        message.description = "\("conf.wechat.shared.meetingId".localized)\(numericId)\r\(dict["confTime"] ?? "")"
        message.setThumbImage(UIImage.init(named: "Icon-1041")!)
        
        let ext = WXWebpageObject()
        ext.webpageUrl = (dict["url"] as! String).replacingOccurrences(of: "\"", with: "")
        message.mediaObject = ext
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        
        WXApi.send(req, completion: nil)
    }
    
    func meetingNumbershareWechat(_ dict:Dictionary<String, Any>) {
        let message = WXMediaMessage()
        message.title = "\(dict["name"] ?? "")\("conf.room.room".localized)"
        if dict["password"] != nil && (dict["password"] as! String).count != 0 {
            message.description = "\("conf.room.roomId".localized) \(dict["numericId"] ?? "")\r\("conf.password".localized)\(dict["password"] ?? "")"
        }else {
            message.description = "\("conf.room.roomId".localized) \(dict["numericId"] ?? "")"
        }
        message.setThumbImage(UIImage.init(named: "Icon-1041")!)
        
        let ext = WXWebpageObject()
        ext.webpageUrl = (dict["url"] as! String).replacingOccurrences(of: "\"", with: "")
        message.mediaObject = ext
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        
        WXApi.send(req, completion: nil)
    }
    
    func shareEmail(_ str:String) {
        let emailLink = (str.components(separatedBy: "$") as Array)[1]
        UIApplication.shared.openURL(URL.init(string: emailLink)!)
    }
    
    func didStartProvisionalNavigation() {
        maskView?.isHidden = false
        maskView?.promptLabel?.text = "alert.HLogingView.titleTrying".localized
        maskView?.promptLabel?.isHidden = false
        maskView?.gifView?.isHidden = false
        maskView?.reloadBtn?.isHidden = true
        maskView?.noNetworkImage?.isHidden = true
    }
    
    func didFinishNavigation(_ webView:WKWebView) {
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.isScrollEnabled = false
        maskView?.isHidden = true
    }
    
    func didFailProvisionalNavigation() {
        maskView?.promptLabel?.text = "alert.HLogingView.titleLoadFailed".localized
        maskView?.promptLabel?.isHidden = false
        maskView?.gifView?.isHidden = true
        maskView?.reloadBtn?.isHidden = false
        maskView?.reloadBtn?.setTitle("alert.reload".localized, for: .normal)
        maskView?.noNetworkImage?.isHidden = false
    }
}

// MARK: StatisticalVC+Ext
extension StatisticalVC {
    func initContent() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        timerSecond = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(refreshStatistical), userInfo: nil, repeats: true)
    }
    
    @objc func refreshStatistical() {
        sgnalArr = appDelegate.evengine.getStats()
        
        if sgnalArr.count == 0 {
            return
        }
        let stats = sgnalArr[0]
        if stats.is_encrypted {
            statisLb.text = "\("video.statistics.title".localized)(\("video.statistics.encrypt".localized))"
        }else {
            statisLb.text = "\("video.statistics.title".localized)"
        }
        
        codecsArr.removeAllObjects()
        rateArr.removeAllObjects()
        fblArr.removeAllObjects()
        loseArr.removeAllObjects()
        loseNum.removeAllObjects()
        dataArray.removeAllObjects()
        
        for stats in sgnalArr {
            if stats.type == .audio {
                if stats.dir == .upload {
                    dataArray.add("\("video.statistics.column.thisEnd.audio".localized)")
                }else {
                    dataArray.add("\("video.statistics.column.farEnd.audio".localized)")
                }
            }else if stats.type == .video {
                if stats.dir == .upload {
                    dataArray.add("\("video.statistics.column.thisEnd.video".localized)")
                }else {
                    dataArray.add("\("video.statistics.column.farEnd.video".localized)")
                }
            }else {
                if stats.dir == .upload {
                    dataArray.add("\("video.statistics.column.thisEnd.content".localized)")
                }else {
                    dataArray.add("\("video.statistics.column.farEnd.content".localized)")
                }
            }
            
            codecsArr.add(stats.payload_type)
            rateArr.add(String(format:"%.1f", stats.real_bandwidth))
            
            if stats.type == .audio {
                fblArr.add("-")
            }else {
                fblArr.add("\(stats.resolution.width)x\(stats.resolution.height) (\(String(format:"%.1f", stats.fps)))")
            }
            
            loseArr.add("\(String(format:"%.1f", stats.packet_loss_rate))")
            loseNum.add("\(Int(stats.cum_packet_loss))")
            
            tab.reloadData()
        }
    }
}

// MARK: AnonymousLinkVC+Ext
extension AnonymousLinkVC {
    func initContent() {
        cameraBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        micPhoneBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        cameraBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        micPhoneBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        joinBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)

        micPhoneBtn.isSelected = getSetParameter(enableMicphone) != nil ? !getSetParameter(enableMicphone)! : false
        cameraBtn.isSelected = getSetParameter(enableCamera) != nil ? !getSetParameter(enableCamera)! : false
        
        disPlayNameLb.setLayer(true, 4, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
        bgView.setLayer(true, 4, nil, nil)
        bgView.setAroundshadow(UIColor.black, CGSize(width: 0, height: 4), 0.3, 5)
        
        disPlayNameLb.text = Utils.judge(UIDevice.current.name)
        meetingNumberLb.text = "\(dict["confid"]!)"
    }
    
    @objc func buttonMethod(sender: UIButton) {
        let setInfo = getSetPlist()
        
        switch sender {
        case joinBtn:
            if "\(dict["protocol"] ?? "")" == "https"{
                appDelegate.evengine.enableSecure(true)
            }else {
                appDelegate.evengine.enableSecure(false)
            }
            
            if !checkCameraPermission() {
                let alert = UIAlertController.init(title: "“\("CFBundleDisplayName".infoPlist)”\("alert.access.camera".localized)", message: "alert.open.camera".localized, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "alert.noallow".localized, style: .default, handler: { (_) in
                    
                }))
                alert.addAction(UIAlertAction(title: "alert.ok".localized, style: .default, handler: { (_) in
                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                }))
                
                UIViewControllerCJHelper.findCurrentShowingViewController()?.present(alert, animated: true, completion: nil)
                return
            }else if !checkMicphonePermission() {
                let alert = UIAlertController.init(title: "“\("CFBundleDisplayName".infoPlist)”\("alert.access.micphone".localized)", message: "alert.open.micphone".localized, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "alert.noallow".localized, style: .default, handler: { (_) in
                    
                }))
                alert.addAction(UIAlertAction(title: "alert.ok".localized, style: .default, handler: { (_) in
                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                }))
                
                UIViewControllerCJHelper.findCurrentShowingViewController()?.present(alert, animated: true, completion: nil)
                return
            }
            
            getTabBarVC().anonymousDialCall("\(dict["server"] ?? "")", "\(dict["port"] ?? "")", "\(dict["confid"] ?? "")", true, disPlayNameLb.text ?? "", "\(dict["password"] ?? "")", .conf)
            dismiss(animated: true, completion: nil)
            break
        case cancelBtn:
            dismiss(animated: true, completion: nil)
            break
        case cameraBtn:
            cameraBtn.isSelected = !cameraBtn.isSelected
            setInfo.setValue(!cameraBtn.isSelected, forKey: enableCamera)
            break
        case micPhoneBtn:
            micPhoneBtn.isSelected = !micPhoneBtn.isSelected
            setInfo.setValue(!micPhoneBtn.isSelected, forKey: enableMicphone)
            break
        default:
            break
        }
        
        PlistUtils.savePlistFile(setInfo as! [AnyHashable : Any], withFileName: setPlist)
    }
}
