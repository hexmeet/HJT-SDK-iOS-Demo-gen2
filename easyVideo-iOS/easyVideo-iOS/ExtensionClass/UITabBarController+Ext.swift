//
//  UITabBarController+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/3.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit
import CoreTelephony

extension BaseTabBarVC {
    
    /// 加载当前VC
    func loadTabBarVC() -> Void {
        self.delegate = self
        
        appDelegate.evengine.setDelegate(self)
        
        let meetingVC = MeetingVC()
        let meetingNav = UINavigationController(rootViewController: meetingVC)
        let joinMeetingVC = JoinMeetingVC()
        let joinMeetingNav = UINavigationController(rootViewController: joinMeetingVC)
        let contactVC = ContactVC()
        let contactNav = UINavigationController(rootViewController: contactVC)
        let meVC = MeVC()
        let meNav = UINavigationController(rootViewController: meVC)
        
        viewControllers = [meetingNav, joinMeetingNav, contactNav, meNav]
        
        let item1 = self.tabBar.items![0]
        let item2 = self.tabBar.items![1]
        let item3 = self.tabBar.items![2]
        let item4 = self.tabBar.items![3]
        
        item1.image = UIImage(named: "nav_meeting_nor")
        item2.image = UIImage(named: "nav_join_nor")
        item3.image = UIImage(named: "nav_contacts_n")
        item4.image = UIImage(named: "nav_me_nor")
        
        item1.title = "tabbar.meetings".localized
        item2.title = "tabbar.join".localized
        item3.title = "tabbar.contacts".localized
        item4.title = "tabbar.me".localized
        
        item1.selectedImage = UIImage(named: "nav_meeting_pre")
        item2.selectedImage = UIImage(named: "nav_join_pre")
        item3.selectedImage = UIImage(named: "nav_contacts_p")
        item4.selectedImage = UIImage(named: "nav_me_pre")
        
        UITabBar.appearance().tintColor = UIColor.init(formHexString: "0x0079FF")
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 11.0)!] as [NSAttributedString.Key: Any], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 11.0)!] as [NSAttributedString.Key: Any], for: .highlighted)
        
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = UIColor.init(formHexString: "0x313131")
        }
        
        selectedIndex = 0
    }
    
    func addAVAudioSessionInterruptionNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterrupted(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    func addAudioRouteChangeListenerCallback() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListenerCallback(notification:)), name: AVAudioSession.routeChangeNotification, object: AVAudioSession.sharedInstance())
    }
    
    func creatVideoWindow() {
        videoWidow = UIWindow()
        videoWidow?.windowLevel = .statusBar
        videoWidow?.frame = UIScreen.main.bounds
        videoWidow?.backgroundColor = UIColor.red
        videoWidow?.isUserInteractionEnabled = true
        videoVC = VideoVC()
        videoVC?.joinGroupChat = { flag in
            self.appDelegate.allowRotation = 0
            
            if self.theDeviceorientation == UIDeviceOrientation.landscapeRight {
                UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")
                UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
            }else if self.theDeviceorientation == UIDeviceOrientation.landscapeLeft {
                UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeRight.rawValue), forKey: "orientation")
                UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
            }else{
                UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeRight.rawValue), forKey: "orientation")
                UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
            }
            
            let chat = ChatPageViewController()
            chat.hidesBottomBarWhenPushed = true
            chat.groupStr = self.appDelegate.evengine.getIMGroupID()
            chat.backBool = false
            chat.showVideoWindow = {
                self.appDelegate.emengine.setDelegate(self)
                self.videoWidow?.isHidden = false
                self.videoWidow?.frame = UIScreen.main.bounds
                self.appDelegate.allowRotation = 1
                self.videoVC?.meanBg.isHidden = false
                
                if self.theDeviceorientation == UIDeviceOrientation.landscapeRight {
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")
                }else if self.theDeviceorientation == UIDeviceOrientation.landscapeLeft {
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeRight.rawValue), forKey: "orientation")
                }else{
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeRight.rawValue), forKey: "orientation")
                }
                
                let vc = UIViewControllerCJHelper.findCurrentShowingViewController()
                vc.navigationController?.popToRootViewController(animated: true)
                
                self.videoVC?.joinMeetingMode()
            }
            
            Utils.currentNC().pushViewController(chat, animated: true)
            
            self.videoWidow?.frame = CGRect(x: 0, y: 100, width: 160, height: 90)
            self.videoWidow?.isHidden = false
        }
        videoVC?.hiddenWindowblock = {
            self.appDelegate.allowRotation = 0
            if self.theDeviceorientation == UIDeviceOrientation.portrait {
                UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")
                UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
            }else{
                UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
            }
            self.hiddenVideoWindow()
            
            let vc = UIViewControllerCJHelper.findCurrentShowingViewController()
            self.appDelegate.networkWindow?.frame = CGRect(x: 0, y: (vc.navigationController?.navigationBar.frame.height ?? 64) + UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 40)
        }
        videoWidow?.rootViewController = videoVC
        videoWidow?.isHidden = false
        videoWidow?.isHidden = true
    }
    
    func setMotionManager() {
        MotionManager.share().start { (motionType) in
            if motionType.rawValue == 0 {
                self.theDeviceorientation = .portraitUpsideDown
            }else if motionType.rawValue == 1 {
                self.theDeviceorientation = .portrait
            }else if motionType.rawValue == 2 {
                self.theDeviceorientation = .landscapeLeft
                let device = self.appDelegate.evengine.getDevice(.videoCapture)
                let currentCamId = device.name
                if currentCamId.contains("in_video:0") {
                    self.appDelegate.evengine.setDeviceRotation(180)
                }else {
                    self.appDelegate.evengine.setDeviceRotation(0)
                }
            }else if motionType.rawValue == 3 {
                self.theDeviceorientation = .landscapeRight
                let device = self.appDelegate.evengine.getDevice(.videoCapture)
                let currentCamId = device.name
                if currentCamId.contains("in_video:0") {
                    self.appDelegate.evengine.setDeviceRotation(0)
                }else {
                    self.appDelegate.evengine.setDeviceRotation(180)
                }
            }
            
            if self.appDelegate.allowRotation == 0 {
                if self.theDeviceorientation == UIDeviceOrientation.portrait {
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
                }else{
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
                }
            }
        }
    }
    
    func setCTCallCenter() {
        
        center.callEventHandler = { (call:CTCall!) in
            switch call.callState {
            case CTCallStateDisconnected:
                self.callDisconnected()
                DDLogWrapper.logInfo("CTCallStateDisconnected")
                break
            case CTCallStateConnected:
                self.callConnectedAndcallIncoming()
                DDLogWrapper.logInfo("CTCallStateConnected")
                break
            case CTCallStateIncoming:
                self.callConnectedAndcallIncoming()
                DDLogWrapper.logInfo("CTCallStateIncoming")
                break
            case CTCallStateDialing:
                DDLogWrapper.logInfo("CTCallStateDialing")
                break
            default:
                break
            }
        }
    }
    
    func callDisconnected() {
        if videoVC!.isEnableCamera {
            appDelegate.evengine.enableCamera(true)
            DDLogWrapper.logInfo("evengine.enableCamera(true)")
        }
        
        if getUserParameter(loginState) != nil && getUserParameter(loginState) == "YES" {
            let headImgPath = "\(FileTools.getDocumentsFailePath())/header.jpg"
            self.appDelegate.evengine.setUserImage(Bundle.main.path(forResource: "img_videomute", ofType: "jpg")!, filename: headImgPath)
        }else {
            self.appDelegate.evengine.setUserImage(Bundle.main.path(forResource: "img_videomute", ofType: "jpg")!, filename: FileTools.bundleFile("default_user_icon.jpg"))
        }
    }
    
    func callConnectedAndcallIncoming() {
        appDelegate.evengine.enableCamera(false)
        DDLogWrapper.logInfo("evengine.enableCamera(false)")
        if getUserParameter(loginState) != nil && getUserParameter(loginState) == "YES" {
            let headImgPath = "\(FileTools.getDocumentsFailePath())/header.jpg"
            self.appDelegate.evengine.setUserImage(Bundle.main.path(forResource: "img_videomute2", ofType: "jpg")!, filename: headImgPath)
        }else {
            self.appDelegate.evengine.setUserImage(Bundle.main.path(forResource: "img_videomute2", ofType: "jpg")!, filename: FileTools.bundleFile("default_user_icon.jpg"))
        }
    }
    
    @objc func audioSessionInterrupted(notification: NSNotification) {
        appDelegate.evengine.audioInterruption(notification.userInfo![AVAudioSessionInterruptionTypeKey] as! Int32)
    }
    
    @objc func audioRouteChangeListenerCallback(notification: NSNotification) {
        if !Utils.isHeadSetPlugging() {
            Utils.setSpeaker()
        }
    }
    
    func dialCall(sipNumber sip:String, isVideoMode flag:Bool, disPlayName name:String, withPassword password:String, callType type:EVSvcCallType) {
        DDLogWrapper.logInfo("dialCall sipNumber:\(sip) sip:\(sip) isVideoMode:\(flag) disPlayName:\(name) password:\(password) callType:\(type)")
        
        if !isValidNumber(sip) {
            let view = UIViewControllerCJHelper.findCurrentShowingViewController() as! BaseViewController
            view.showHud("alert.invalidConfNumber".localized, self.view, .MBProgressHUBPositionBottom, 2)
            return
        }
        
        appDelegate.evengine.setUserImage(Bundle.main.path(forResource: "img_videomute", ofType: "jpg")!, filename: "\(FileTools.getDocumentsFailePath())/header.jpg")
        
        saveNumberMethod(sip)
        
        self.videoVC?.meetingNumberLb.isHidden = sip.first != "1" ? true : false
        
        if getSetParameter(enableMicphone) != nil {
            appDelegate.evengine.enableMic(getSetParameter(enableMicphone)!)
        }else {
            appDelegate.evengine.enableMic(true)
        }
        
        if getSetParameter(enableCamera) != nil {
            appDelegate.evengine.enableCamera(getSetParameter(enableCamera)!)
        }else {
            appDelegate.evengine.enableMic(true)
        }
        
        meetingIdStr = sip
        passwordStr = password
        
        appDelegate.showConnectWindow()
        if type == .conf {
            appDelegate.changeConnectWindowSipNumber(sip)
        }else {
            appDelegate.changeConnectWindowSipNumber(p2pName)
        }
        appDelegate.evengine.joinConference(sip, display_name: name, password: password, svcCallType: .conf)
    }
    
    func p2pDialCall(_ img: String, _ userId: String, _ name: String) {
        DDLogWrapper.logInfo("p2pDialCall img:\(img) userId:\(userId) name:\(name)")
        
        p2pImg = img
        p2pName = name
        appDelegate.evengine.enableCamera(true)
        appDelegate.evengine.joinConference(userId, display_name: name, password: "", svcCallType: .P2P)
    }
    
    func anonymousDialCall(_ server:String, _ port:String, _ sip:String, _ isVideo:Bool, _ name:String, _ password:String, _  type:EVSvcCallType) {
        DDLogWrapper.logInfo("anonymousDialCall server:\(server) port:\(port) sip:\(sip) isVideo:\(isVideo) name:\(name) password:\(password) type:\(type)")
        
        if !isValidNumber(sip) {
            let view = UIViewControllerCJHelper.findCurrentShowingViewController() as! BaseViewController
            view.showHud("alert.invalidConfNumber".localized, self.view, .MBProgressHUBPositionBottom, 2)
            return
        }
        
        self.appDelegate.evengine.setUserImage(Bundle.main.path(forResource: "img_videomute", ofType: "jpg")!, filename: FileTools.bundleFile("default_user_icon.jpg"))
        
        saveNumberMethod(sip)
        
        let name = displayName.count == 0 ? Utils.judge(UIDevice.current.name) : name
        
        appDelegate.isAnonymousUser = true
        
        self.videoVC?.meetingNumberLb.isHidden = false
        
        if getSetParameter(enableMicphone) != nil {
            appDelegate.evengine.enableMic(getSetParameter(enableMicphone)!)
        }else {
            appDelegate.evengine.enableMic(true)
        }
        
        let p = port.count == 0 ? "0" : port
        
        if getSetParameter(enableCamera) != nil {
            appDelegate.evengine.enableCamera(getSetParameter(enableCamera)!)
        }else {
            appDelegate.evengine.enableMic(true)
        }
        
        meetingIdStr = sip
        passwordStr = password
        serverStr = server
        nameStr = name
        portStr = p
        
        videoVC?.local.nameLb.text = name
        
        appDelegate.showConnectWindow()
        appDelegate.changeConnectWindowSipNumber(sip)
        
        appDelegate.evengine.joinConference(withLocation: server, port: UInt32(p)!, conference_number: sip, display_name: name, password: password)
    }
    
    func showVideoWindow() {
        videoWidow?.isHidden = false
    }
    
    func hiddenVideoWindow() {
        videoWidow?.isHidden = true
    }
    
    func showMeetingWindow(_ sip:String) {
        appDelegate.allowRotation = 1
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.showVideoWindow()
        if theDeviceorientation == UIDeviceOrientation.landscapeRight {
            UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
            UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")
            self.perform(#selector(setCamera), with: nil, afterDelay: 1)
        }else if theDeviceorientation == UIDeviceOrientation.landscapeLeft {
            UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
            UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeRight.rawValue), forKey: "orientation")
        }else {
            UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
            UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeRight.rawValue), forKey: "orientation")
        }
        
        videoVC?.startTimer()
        videoVC?.meetingNumberLb.text = sip
    }
    
    @objc func setCamera() {
        appDelegate.evengine.setDeviceRotation(180)
    }
    
    func removeP2pCallView() {
        stopSound()
    self.appDelegate.evengine.setLocalVideoWindow(Unmanaged.passUnretained((self.videoVC?.local.videoV)!).toOpaque())
        self.p2pCallView?.removeFromSuperview()
        self.p2pCallView = nil
        
        self.appDelegate.allowRotation = 0
        if self.theDeviceorientation == UIDeviceOrientation.portrait {
            UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")
            UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
        }else{
            UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
    
    // MARK: EVSDK
    func onRegister_(_ registered: Bool) {
        DispatchQueue.main.async {
            let userInfo = getUserPlist()
            
            if (!registered) {
                if getUserParameter(loginState) != nil && getUserParameter(loginState) == "YES" {
                    self.appDelegate.showNetworkWindow()
                }
                userInfo.setValue("NO", forKey: loginState)
                PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName: userPlist)
                DDLogWrapper.logInfo("onRegister(false)")
            }else {
                if !self.appDelegate.isAnonymousUser {
                    userInfo.setValue("YES", forKey: loginState)
                    PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName: userPlist)
                }
                self.appDelegate.hiddenNetworkWindow()
                DDLogWrapper.logInfo("onRegister(true)")
            }
        }
    }
    
    func onLoginSucceed_(_ user: EVUserInfo) {
        DispatchQueue.main.async {
            if getFeatureSupportParameter(chatInConference) {
                EMMessageManager.sharedInstance().selectEntity(nil, ascending: true, filterString: nil, success: { (results) in
                    for obj in results {
                        EMMessageManager.sharedInstance().deleteEntity(obj as! NSManagedObject, success: nil, fail: nil)
                    }
                }, fail: nil)
                
                EMManager.sharedInstance().delegates.onCallEnd()
                
                EVUserIdManager.sharedInstance().selectEntity(nil, ascending: true, filterString: nil, success: { (results) in
                    for obj in results {
                        EVUserIdManager.sharedInstance().deleteEntity(obj as! NSManagedObject, success: nil, fail: nil)
                    }
                }, fail: nil)
                
                self.appDelegate.emengine.logout()
            }
            
            let featurePlist = NSMutableDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(featureSupportPlist))
            
            featurePlist.setValue(user.featureSupport.contactWebPage, forKey: contactWebPage)
            featurePlist.setValue(user.featureSupport.p2pCall, forKey: p2pCall)
            featurePlist.setValue(user.featureSupport.chatInConference, forKey: chatInConference)
            featurePlist.setValue(user.featureSupport.sitenameIsChangeable, forKey: sitenameIsChangeable)
            featurePlist.setValue(user.featureSupport.switchingToAudioConference, forKey: switchingToAudioConference)
            PlistUtils.savePlistFile(featurePlist as! [AnyHashable : Any], withFileName: featureSupportPlist)
            
            if self.appDelegate.isAnonymousUser {
                return
            }
            
            let headPath = "\(FileTools.getDocumentsFailePath())/header.jpg"
            self.appDelegate.evengine.downloadUserImage(headPath)
            
            DDLogWrapper.logInfo("user login onLoginSucceed:username:\(user.username)")
            // update user info
            let userInfo = getUserPlist()
            userInfo.setValue(user.username, forKey: username)
            userInfo.setValue(user.displayName, forKey: displayName)
            userInfo.setValue(user.org, forKey: org)
            userInfo.setValue(user.cellphone, forKey: cellphone)
            userInfo.setValue(user.email, forKey: email)
            userInfo.setValue(user.telephone, forKey: telephone)
            userInfo.setValue(user.token, forKey: token)
            userInfo.setValue(String(user.userId), forKey: userId)
            userInfo.setValue(String(user.deviceId), forKey: deviceId)
            userInfo.setValue(user.doradoVersion, forKey: doradoVersion)
            userInfo.setValue(user.dept, forKey: dept)
            userInfo.setValue(user.customizedH5UrlPrefix, forKey: customizedH5UrlPrefix)
            PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName: userPlist)
            
            self.appDelegate.isLogin = true
            
            Manager.shared().delegates.onLoginSucceed!(forMg: user)
        }
    }
    
    // MARK: SDK
    func onError_(_ err: EVError) {
        DispatchQueue.main.async {
            Manager.shared().delegates.onError!(forMg: err)
            DDLogWrapper.logError("sdk onError code:\(err.code) msg:\(err.msg)")
        }
    }
    
    func onDownloadUserImageComplete_(_ path: String) {
        DispatchQueue.main.async {
            self.appDelegate.evengine.setUserImage(Bundle.main.path(forResource: "img_videomute", ofType: "jpg")!, filename: path)
            DDLogWrapper.logInfo("sdk onDownloadUserImageComplete path:\(path)")
        }
    }
    
    func onCallConnected_(_ info: EVCallInfo) {
        DispatchQueue.main.async {
            DDLogWrapper.logInfo("sdk onCallConnected conference_number:\(info.conference_number) peer:\(info.peer)")
            
            if Utils.isHeadSetPlugging() {
                Utils.setReceiver()
            }else {
                Utils.setSpeaker()
            }
            
            if self.appDelegate.evengine.getDevice(.videoCapture).name.contains("in_video:0") {
                self.appDelegate.evengine.switchCamera()
            }
            
            if getFeatureSupportParameter(chatInConference) {
                self.appDelegate.emengine.setDelegate(self)
                let url = URL.init(string: self.appDelegate.evengine.getIMAddress())
                
                if url != nil {
                    self.appDelegate.emengine.anonymousLogin((url?.host)!, port: UInt32.init("\(url?.port ?? 0)")!, displayname: self.appDelegate.evengine.getDisplayName(), external_info: "\(self.appDelegate.evengine.getUserInfo()?.userId ?? 0)")
                    DDLogWrapper.logInfo("getIMAddress address:\(url!.absoluteString) server:\((url?.host)!) port:\(UInt32.init("\(url?.port ?? 0)")!)")
                }else {
                    DDLogWrapper.logInfo("getIMAddress error")
                }
            }
            
            if info.svcCallType == .conf {
                self.appDelegate.hiddenConnectWindow()
                self.showMeetingWindow(info.conference_number)
            }else if info.svcCallType == .P2P {
                self.appDelegate.allowRotation = 1
                UIApplication.shared.isIdleTimerDisabled = true
                
                if self.theDeviceorientation == UIDeviceOrientation.landscapeRight {
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")
                    self.perform(#selector(self.setCamera), with: nil, afterDelay: 1)
                }else if self.theDeviceorientation == UIDeviceOrientation.landscapeLeft {
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeRight.rawValue), forKey: "orientation")
                }else {
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
                    UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeRight.rawValue), forKey: "orientation")
                }
                
                self.p2pCallView = (Bundle.main.loadNibNamed("P2pCallView", owner: nil, options: nil)![0] as! P2pCallView)
                self.p2pCallView!.frame = UIScreen.main.bounds
                self.p2pCallView?.nameLb.text = self.p2pName
                self.p2pCallView?.headImg.sd_setImage(with: URL.init(string: self.p2pImg), completed: nil)
                self.p2pCallView?.btnblock = {
                    self.appDelegate.evengine.hangUp()
                    
                    self.p2pCallView?.removeFromSuperview()
                    self.p2pCallView = nil
                    
                    self.appDelegate.allowRotation = 0
                    if self.theDeviceorientation == UIDeviceOrientation.portrait {
                        UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")
                        UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
                    }else{
                        UIDevice.current.setValue(NSNumber.init(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
                    }
                }
                self.view.addSubview(self.p2pCallView!)
            }
        }
    }
    
    func onPeerImageUrl_(_ imageUrl: String) {
        DispatchQueue.main.async {
            DDLogWrapper.logInfo("sdk onPeerImageUrl imageUrl:\(imageUrl)")
            if self.invitationView != nil {
                self.invitationView!.headImg.sd_setImage(with: URL.init(string: imageUrl), completed: nil)
            }
        }
    }
    
    func onCallPeerConnected_(_ info: EVCallInfo) {
        DispatchQueue.main.async {
            DDLogWrapper.logInfo("sdk onCallPeerConnected conference_number:\(info.conference_number) peer:\(info.peer)")
            
            if Utils.isHeadSetPlugging() {
                Utils.setReceiver()
            }else {
                Utils.setSpeaker()
            }
            
            self.videoVC?.meetingNumberLb.isHidden = true
        self.appDelegate.evengine.setLocalVideoWindow(Unmanaged.passUnretained((self.videoVC?.local.videoV)!).toOpaque())
            self.p2pCallView?.removeFromSuperview()
            self.p2pCallView = nil
            stopSound()
            
            let device = self.appDelegate.evengine.getDevice(.videoCapture)
            if device.name.contains("in_video:0") {
                self.appDelegate.evengine.switchCamera()
            }
            self.showMeetingWindow(info.conference_number)
        }
    }
    
    func onCallEnd_(_ info: EVCallInfo) {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
            
            if getFeatureSupportParameter(chatInConference) {
                EMMessageManager.sharedInstance().selectEntity(nil, ascending: true, filterString: nil, success: { (results) in
                    for obj in results {
                        EMMessageManager.sharedInstance().deleteEntity(obj as! NSManagedObject, success: nil, fail: nil)
                    }
                }, fail: nil)
                
                EMManager.sharedInstance().delegates.onCallEnd()
                
                EVUserIdManager.sharedInstance().selectEntity(nil, ascending: true, filterString: nil, success: { (results) in
                    for obj in results {
                        EVUserIdManager.sharedInstance().deleteEntity(obj as! NSManagedObject, success: nil, fail: nil)
                    }
                }, fail: nil)
                
                self.appDelegate.emengine.logout()
            }
            
            if !self.videoWidow!.isHidden {
                DDLogWrapper.logInfo("sdk onCallEnd conference_number:\(info.conference_number) peer:\(info.peer)")
                
                self.videoVC?.onCallEnd(info)
                if info.err.code == 100 || info.err.code == 101 {
                    if info.svcCallType == .conf {
                        let alert = UIAlertController().creatAlertController(info.conference_number, "alert.callendAlert".localized, .alert)
                        UIViewControllerCJHelper.findCurrentShowingViewController().present(alert, animated: true, completion: nil)
                    }else {
                        let alert = UIAlertController().creatAlertController("", "alert.callendAlert".localized, .alert)
                        UIViewControllerCJHelper.findCurrentShowingViewController().present(alert, animated: true, completion: nil)
                    }
                    DDLogWrapper.logInfo("callend: Meeting ended or terminated by meeting host. number:\(info.conference_number) code:\(info.err.code)")
                }else if info.err.code == 11 || info.err.code == 102 {
                    if info.svcCallType == .conf {
                        let alert = UIAlertController().creatAlertController(info.conference_number, "alert.networkunavailable".localized, .alert)
                        UIViewControllerCJHelper.findCurrentShowingViewController().present(alert, animated: true, completion: nil)
                    }else {
                        let alert = UIAlertController().creatAlertController("", "alert.networkunavailable".localized, .alert)
                        UIViewControllerCJHelper.findCurrentShowingViewController().present(alert, animated: true, completion: nil)
                    }
                    DDLogWrapper.logInfo("callend MRU: number:\(info.conference_number) code:\(info.err.code)")
                }
            }else {
                DDLogWrapper.logError("sdk onCallEnd errcode:\(info.err.code)")
                
                self.appDelegate.hiddenConnectWindow()
                
                let view = UIViewControllerCJHelper.findCurrentShowingViewController() as! BaseViewController
                
                switch info.err.code {
                case 1001:
                    view.showHud("alert.invalidConfNumber".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 2001:
                    view.showHud("alert.cloudnotactivat".localized, self.view, .MBProgressHUBPositionBottom, 3)
                case 2005:
                    view.showHud("alert.meetingnotstart".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 2015:
                    let passwordView = Bundle.main.loadNibNamed("PasswordReminderView", owner: nil, options: nil)![0] as! PasswordReminderView
                    passwordView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    passwordView.frame = view.view.frame
                    passwordView.passwordTF.becomeFirstResponder()
                    
                    passwordView.joinblock = { [weak self] str in
                        self?.view.endEditing(true)
                        if (self?.appDelegate.isAnonymousUser)! {
                            self?.anonymousDialCall(self!.serverStr, self!.portStr, self!.meetingIdStr, true, self!.nameStr, str, .conf)
                        }else {
                            self?.dialCall(sipNumber: self!.meetingIdStr, isVideoMode: true, disPlayName: self!.nameStr, withPassword: str, callType: .conf)
                        }
                        passwordView.removeFromSuperview()
                    }
                    view.view.addSubview(passwordView)
                    break
                case 2031:
                    view.showHud("alert.meetingdosenotanonymouscall".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 2033:
                    view.showHud("alert.allowmeeting".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 2035:
                    view.showHud("alert.trialexpired".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 2023:
                    view.showHud("alert.limit".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 2025:
                    view.showHud("error.2025".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 2024:
                    view.showHud("error.2024".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 2011:
                    view.showHud("error.2011".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 2009:
                    view.showHud("error.2009".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 2007:
                    view.showHud("error.2007".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 4055:
                    view.showHud("error.4055".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 4051:
                    view.showHud("error.4051".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 4049:
                    view.showHud("error.4049".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 4057:
                    view.showHud("error.4057".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 10:
                    self.removeP2pCallView()
                    view.showHud("error.10".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 101:
                    self.removeP2pCallView()
                    view.showHud("error.101".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 14:
                    self.removeP2pCallView()
                    view.showHud("error.14".localized, self.view, .MBProgressHUBPositionBottom, 3)
                    break
                case 0:
                    self.removeP2pCallView()
                    break
                default:
                    view.showHud("\("alert.joinmeetingerr".localized)\(info.err.code)", self.view, .MBProgressHUBPositionBottom, 3)
                    break
                }
            }
        }
    }
    
    func onJoinConferenceIndication_(_ info: EVCallInfo) {
        DispatchQueue.main.async {
            DDLogWrapper.logInfo("sdk onJoinConferenceIndication conference_number:\(info.conference_number) peer:\(info.peer)")
            
            if info.svcCallAction == .incomingCallCancel {
                stopSound()
                if self.invitationView != nil {
                    self.invitationView?.removeFromSuperview()
                    self.invitationView = nil
                }
                return
            }
            
            self.videoVC?.meetingNumberLb.isHidden = info.svcCallType == .P2P ? true : false

            if getSetParameter(enableAutoAnswer) != nil {
                if getSetParameter(enableAutoAnswer)! {
                    self.dialCall(sipNumber: info.conference_number, isVideoMode: true, disPlayName: "", withPassword: info.password, callType: .conf)
                }else {
                    if self.invitationView == nil {
                        self.invitationView = (Bundle.main.loadNibNamed("InvitationView", owner: nil, options: nil)![0] as! InvitationView)
                        self.invitationView?.invatationNameLb.text = info.peer
                        self.invitationView?.contentLb.text = info.svcCallType == .conf ? "\("alert.invitedMeeting".localized)\(info.conference_number)" : "alert.p2pinvited".localized
                        self.invitationView?.btnblock = { flag in
                            if flag {
                                self.dialCall(sipNumber: info.conference_number, isVideoMode: true, disPlayName: "", withPassword: info.password, callType: .conf)
                            }else {
                                self.appDelegate.evengine.declineIncommingCall(info.conference_number)
                            }
                            stopSound()
                            self.invitationView?.removeFromSuperview()
                            self.invitationView = nil
                        }
                        self.invitationView!.frame = UIScreen.main.bounds
                        self.view.addSubview(self.invitationView!)
                    }
                }
            }else {
                if self.invitationView == nil {
                    self.p2pName = info.peer
                    self.invitationView = (Bundle.main.loadNibNamed("InvitationView", owner: nil, options: nil)![0] as! InvitationView)
                    self.invitationView?.invatationNameLb.text = info.peer
                    self.invitationView?.contentLb.text = info.svcCallType == .conf ? "\("alert.invitedMeeting".localized)\(info.conference_number)" : "alert.p2pinvited".localized
                    self.invitationView?.btnblock = { flag in
                        if flag {
                            self.dialCall(sipNumber: info.conference_number, isVideoMode: true, disPlayName: "", withPassword: info.password, callType: .P2P)
                        }else {
                            self.appDelegate.evengine.declineIncommingCall(info.conference_number)
                        }
                        stopSound()
                        self.invitationView?.removeFromSuperview()
                        self.invitationView = nil
                    }
                    self.invitationView!.frame = UIScreen.main.bounds
                    self.view.addSubview(self.invitationView!)
                }
            }
        }
    }
    
    func onContent_(_ info: EVContentInfo) {
        DispatchQueue.main.async {
            self.videoVC?.onContent(info)
        }
    }
    
    func onNetworkQuality_(_ quality_rating: Float) {
        DispatchQueue.main.async {
            self.videoVC?.onNetworkQuality(quality_rating)
        }
    }
    
    func onWarn_(_ warn: EVWarn) {
        DispatchQueue.main.async {
            self.videoVC?.onWarn(warn)
        }
    }
    
    func onLayoutIndication_(_ layout: EVLayoutIndication) {
        DispatchQueue.main.async {
            self.videoVC?.onLayoutIndication(layout)
        }
    }
    
    func onLayoutSpeakerIndication_(_ speaker: EVLayoutSpeakerIndication) {
        DispatchQueue.main.async {
            self.videoVC?.onLayoutSpeakerIndication(speaker)
        }
    }
    
    func onLayoutSiteIndication_(_ site: EVSite) {
        DispatchQueue.main.async {
            self.videoVC?.onLayoutSiteIndication(site)
        }
    }
    
    func onMessageOverlay_(_ msg: EVMessageOverlay) {
        DispatchQueue.main.async {
            self.videoVC?.onMessageOverlay(msg)
        }
    }
    
    func onRecordingIndication_(_ info: EVRecordingInfo) {
        DispatchQueue.main.async {
            self.videoVC?.onRecordingIndication(info)
        }
    }
    
    func onParticipant_(_ number: Int32) {
        DispatchQueue.main.async {
            self.videoVC?.onParticipant(number)
        }
    }
    
    func onMuteSpeakingDetected_() {
        DispatchQueue.main.async {
            self.videoVC?.onMuteSpeakingDetected()
        }
    }
    
    func onMicMutedShow_(_ mic_muted: Int32) {
        DispatchQueue.main.async {
            self.videoVC?.onMicMutedShow(mic_muted)
        }
    }

    // MARK: EMSDK
    func onMessageReciveData_(_ message: MessageBody) {
        DispatchQueue.main.async {
            DDLogWrapper.logInfo("onMessageReciveData content:\(message.content) from:\(message.from)")
            message.time = Utils.userVisibleDateTimeString(forRFC3339DateTime: message.time)
            
            EMMessageManager.sharedInstance().insertNewEntity(message, success: {
                
            }) { (_) in
                
            }

            EMManager.sharedInstance().delegates.onMessageReciveData(message)
        }
    }
    
    func onEMError_(_ err: EMError) {
        DispatchQueue.main.async {
            DDLogWrapper.logInfo("IM onEMError:\(err.reason)")
            EMManager.sharedInstance().delegates.onEMError(err)
        }
    }
    
    func onLoginSucceed_() {
        DispatchQueue.main.async {
            DDLogWrapper.logInfo("IM onLoginSucceed")
            DDLogWrapper.logInfo("getIMGroupID:\(self.appDelegate.evengine.getIMGroupID())")
            self.appDelegate.emengine.joinNewGroup(self.appDelegate.evengine.getIMGroupID())
        }
    }
    
    func onMessageSendSucceed_(_ messageState: MessageState) {
        DispatchQueue.main.async {
            DDLogWrapper.logInfo("IM onMessageSendSucceed")
            EMManager.sharedInstance().delegates.onMessageSendSucceed(messageState)
        }
    }
    
    func onGroupMemberInfo_(_ groupMemberInfo: EMGroupMemberInfo) {
        DispatchQueue.main.async {
            let info = Utils.getContactInfo(groupMemberInfo.evuserId)
            if info.evstatus == 0 {
                groupMemberInfo.imageUrl = info.imageUrl
                groupMemberInfo.name = info.displayName
                
                EVUserIdManager.sharedInstance().insertNewEntity(groupMemberInfo, success: nil, fail: nil)
                EMManager.sharedInstance().delegates.onGroupMemberInfo(groupMemberInfo)
                
                DDLogWrapper.logInfo("IM onGroupMemberInfo imageUrl:\(groupMemberInfo.imageUrl) name:\(groupMemberInfo.name)")
            }
        }
    }
    
}

