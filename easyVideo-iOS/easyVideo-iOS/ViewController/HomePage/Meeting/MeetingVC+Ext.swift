//
//  MeetingVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation
import WebKit

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
        
        webKit = WKWebView(frame: view.frame, configuration: webConfiguration)
        webKit.navigationDelegate = self
        
        view.addSubview(webKit)
        
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
        
        view.addSubview(maskView!)
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
        let body = "\(message.body)"
        if body.contains("$") {
            let isshowNav = ((message.body as! String).components(separatedBy: "$") as Array)[1]
            if isshowNav == "false" {
                hiddenTabBar()
            }else {
                showTabBar()
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
            showHud("alert.wechat.notInstalled".localized, view, .MBProgressHUBPositionBottom, 2)
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
