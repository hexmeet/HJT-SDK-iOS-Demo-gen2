//
//  AboutVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

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

