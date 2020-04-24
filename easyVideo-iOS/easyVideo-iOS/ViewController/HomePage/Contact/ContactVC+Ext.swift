//
//  ContactVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation
import WebKit

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
