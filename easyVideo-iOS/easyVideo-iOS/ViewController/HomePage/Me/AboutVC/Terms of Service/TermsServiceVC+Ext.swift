//
//  TermsServiceVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation
import WebKit

extension TermsServiceVC {
    func inintContent() {
        
       
        if isPravicy {
            title = "title.Privacy".localized
        }else{
            title = "title.termsservice".localized
        }
        
  
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
        webKit.y = 0
        
        if isPravicy {
            
            let url = getInfoString("Pravicy_url").replacingOccurrences(of: "\\/", with: "/")
            webKit.load(URLRequest.init(url: URL.init(string: url)!))
            
        }else{
            webKit.load(URLRequest.init(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "licenseServer", ofType: "html")!)))
        }
       
        view.addSubview(webKit)
    }
    
    func back() -> String? {
        return nil
    }
}
