//
//  AppDelegate+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/3.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

extension AppDelegate {
    // MARK: IQKeyboardManager
    func setIQKeyboardManager() {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().toolbarTintColor = UIColor.init(formHexString: "0x4381ff")
    }
    
    // MARK: WXApi
    func registeredWeChat() {
        var universalLinke = getInfoString("Universal_link")
        universalLinke = universalLinke.replacingOccurrences(of: "\\/", with: "/")
        WXApi.registerApp(getInfoString("WXapp_Id"), universalLink: universalLinke)
    }
    
    // MARK: JPUSH
    func registeredJpush(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity()
        if #available(iOS 12.0, *) {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue|UNAuthorizationOptions.providesAppNotificationSettings.rawValue)
        } else {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue)
        }

        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self as? JPUSHRegisterDelegate)
         
        let infoDictionary = Bundle.main.infoDictionary!
        
        JPUSHService.setup(withOption: launchOptions, appKey: infoDictionary["Jpush_key"] as? String, channel: "App Store", apsForProduction: true, advertisingIdentifier: "")
    }
    
    // MARK: EVSDK
    func setEVSDK() {
        let path = FileTools.getDocumentsFailePath()
        let logPath = path + "/Log"
        
        setDDLog(withPath: logPath)
        
        DDLogWrapper.logInfo("++++++++++++++++++++++++++++++ app start ++++++++++++++++++++++++++++++")
        
        evengine.setLog(EVLogLevel.message, path: logPath, file: "evsdk", size: 20*20*1024)
        DDLogWrapper.logInfo("evengine.setLog")
        evengine.enableLog(true)
        DDLogWrapper.logInfo("evengine.enableLog")
        evengine.initialize(path, filename: "config")
        DDLogWrapper.logInfo("evengine.initialize")
        evengine.setMaxRecvVideo(4)
        DDLogWrapper.logInfo("evengine.setMaxRecvVideo(4)")
        evengine.enablePreview(false)
        DDLogWrapper.logInfo("evengine.enablePreview(false)")
        evengine.setRootCA(FileTools.bundleFile("rootca.pem"))
        DDLogWrapper.logInfo("evengine.setRootCA")
        evengine.setBandwidth(2048)
        DDLogWrapper.logInfo("evengine.setBandwidth(2048)")
        evengine.getDevice(.videoCapture)
        DDLogWrapper.logInfo("evengine.getDevice(.videoCapture)")
        evengine.getDevice(.audioCapture)
        DDLogWrapper.logInfo("evengine.getDevice(.audioCapture)")
        
        evengine.setUserAgent("HexMeet", version: getInfoString("CFBundleVersion"))
        
        if getSetParameter(enableMicphone) == nil {
            let setInfo = getSetPlist()
            setInfo.setValue(false, forKey: enableMicphone)
            PlistUtils.savePlistFile(setInfo as! [AnyHashable : Any], withFileName: setPlist)
        }
    }
    
    // MARK: EMSDK
    func setEMSDK() {
        let path = FileTools.getDocumentsFailePath()
        let logPath = path + "/EMLog"
        emengine.initialize(path, filename: "config")
        emengine.setLog(.message, path: logPath, file: "emsdk", size: 1024*1024*20)
        emengine.enableLog(true)
        
        DDLogWrapper.logInfo("emsdk-macos: applicationDidFinishLaunching end")
    }
    
    // MARK: DDLog
    func setDDLog(withPath path:String) {
        DDLog().add(DDASLLogger.sharedInstance)
        DDLog().add(DDTTYLogger.sharedInstance)
        
        let fileManager = DDLogFileWrapper(logsDirectory: path, fileName: "EVUILOG.log")
        let fileLogger = DDFileLogger.init(logFileManager: fileManager)
        
        fileLogger.rollingFrequency = 60 * 60 * 24 * 1000
        fileLogger.maximumFileSize = 40 * 1024 * 1024
        fileLogger.logFileManager.maximumNumberOfLogFiles = 1
        
        DDLog.add(fileLogger)
        
        if !FileTools.isExist(withFile: path) {
            try? FileManager().createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        
        if FileTools.isExist(withFile: path + "/EVUILOG.log") {
            if FileTools.getFileSize(path + "/EVUILOG.log") > 20000000 {
                FileTools.deleteTheFile(withFilePath: (path + "/EVUILOG2.log"))
                saveFile(withPath: path)
                FileTools.deleteTheFile(withFilePath: (path + "/EVUILOG.log"))
            }
        }
    }
    
    func saveFile(withPath path:String) {
        let dataPath = path + "/EVUILOG2.log"
        let srcPath = path + "/EVUILOG.log"
        
        try? FileManager.default.copyItem(atPath: srcPath, toPath: dataPath)
    }
    
    // MARK: ConnectWindow
    func creatConnectWindow() {
        connectWindow = UIWindow()
        connectWindow?.frame = UIScreen.main.bounds
        connectWindow?.backgroundColor = UIColor.red
        connectWindow?.isUserInteractionEnabled = true
        let connectVC = ConnectingVC()
        connectWindow?.rootViewController = connectVC
        connectWindow?.isHidden = true
    }
    
    func showConnectWindow() {
        playSound()
        
        connectWindow?.isHidden = false
        let connectVC = connectWindow?.rootViewController as! ConnectingVC
        connectVC.creatRippleAnimationView()
    }
    
    func hiddenConnectWindow() {
        stopSound()
        connectWindow?.isHidden = true
        let connectVC = connectWindow?.rootViewController as! ConnectingVC
        connectVC.removeRippleAnimationView()
    }
    
    // MARK: NetworkWindow
    func creatNetworkWindow() {
        networkWindow = UIWindow()
        networkWindow?.windowLevel = .normal
        networkWindow?.backgroundColor = UIColor.clear
        networkWindow?.isUserInteractionEnabled = true
        let networkVC = NetworkVC()
        networkWindow?.rootViewController = networkVC
        networkWindow?.isHidden = true
    }
    
    func showNetworkWindow() {
        let vc = UIViewControllerCJHelper.findCurrentShowingViewController()
        networkWindow?.frame = CGRect(x: 0, y: (vc?.navigationController?.navigationBar.frame.height ?? 64) + UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 40)
        networkWindow?.isHidden = false
    }
    
    func hiddenNetworkWindow() {
        networkWindow?.isHidden = true
    }
    
    func changeConnectWindowSipNumber(_ sip:String) {
        let connectVC = connectWindow?.rootViewController as! ConnectingVC
        connectVC.sipNumberLb.text = sip
    }
    
    func getPermissionInAdvance() {
        
        //MARK: APP启动时候，判断用户是否授权使用相机
        if (AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .notDetermined) {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (statusFirst) in
                if statusFirst {
                    //用户首次允许
                    DDLogWrapper.logInfo("camera is permitted by user!")
                } else {
                    DDLogWrapper.logInfo("camera permission is denied by user, call will not send any audio sample to remote!")
                }
            })
        }
       
        // MARK: APP启动时候，判断用户是否授权使用麦克风
        if (AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) == .notDetermined) {
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (statusFirst) in
                if statusFirst {
                    //用户首次允许
                    DDLogWrapper.logInfo("micphone is permitted by user!")
                } else {
                    DDLogWrapper.logInfo("micphone permission is denied by user, call will not send any audio sample to remote!")
                }
            })
        }
    }
    
    // MARK: WebJoinMeetingAction
    func openURL(_ url:URL) {
        if url.absoluteString.contains("hexmeethjt") {
            DDLogWrapper.logInfo("openURL url:\(url.absoluteString)")
            
            tabBar = window?.rootViewController as? BaseTabBarVC
            if tabBar!.videoWidow!.isHidden {
                webJoinMeetingAction(url)
            }
        }
    }
    
    func webJoinMeetingAction(_ url:URL) {
        
        let dict = Utils.getURLParameters(url.absoluteString)
        
        if dict["confid"] == nil {
            return
        }
        
        dict.setValue(url.host, forKey: "server")
        
        let userInfo = NSDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(userPlist))
        if userInfo[loginState] != nil && userInfo[loginState] as! String == "YES" {
            webJoin(dict, url, userInfo)
        }else {
            anonymousWebJoin(dict)
        }
    }
    
    func webJoin(_ dict: NSMutableDictionary, _ url:URL, _ userInfo:NSDictionary) {
        if url.host == "\(userInfo[server] ?? "")" {
            if evengine.getUserInfo() != nil {
                tabBar?.dialCall(sipNumber: "\(dict["confid"]!)", isVideoMode: true, disPlayName: "\(userInfo[displayName]!)", withPassword: "\(dict["password"]!)", callType: .conf)
            }else {
                tabBar?.needDelayJoin = true
                tabBar?.meetingIdStr = "\(dict["confid"]!)"
                tabBar?.passwordStr = "\(dict["password"]!)"
            }
        }else {
            loginOut(dict)
        }
    }
    
    func anonymousWebJoin(_ dict: NSMutableDictionary) {
        var vc = UIViewControllerCJHelper.findCurrentShowingViewController() as! BaseViewController
        vc.whetherTheLogin()
        vc = UIViewControllerCJHelper.findCurrentShowingViewController() as! BaseViewController
        vc.PresentAnonymousLinkVCPage(animated: true, presentStyle: .pageSheet, dict: dict)
    }
    
    func loginOut(_ dict: NSMutableDictionary) {
        let user = NSMutableDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(userPlist))
        user.setValue("NO", forKey: loginState)
        PlistUtils.savePlistFile(user as! [AnyHashable : Any], withFileName: userPlist)
        
        let vc = UIViewControllerCJHelper.findCurrentShowingViewController() as! BaseViewController
        evengine.logout()
        DDLogWrapper.logInfo("evengine.logout() for loginOut");
        
        vc.whetherTheLogin()
        
        vc.poptoRootPage(animated: true)
        vc.tabBarController?.selectedIndex = 0
        
        let loginVC = UIViewControllerCJHelper.findCurrentShowingViewController() as! BaseViewController
        loginVC.PresentAnonymousLinkVCPage(animated: true, presentStyle: .pageSheet, dict: dict)
    }
}
