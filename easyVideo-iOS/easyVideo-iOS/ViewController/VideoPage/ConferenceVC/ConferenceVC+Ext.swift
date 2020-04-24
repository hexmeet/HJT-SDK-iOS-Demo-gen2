//
//  ConferenceVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation
import WebKit

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


