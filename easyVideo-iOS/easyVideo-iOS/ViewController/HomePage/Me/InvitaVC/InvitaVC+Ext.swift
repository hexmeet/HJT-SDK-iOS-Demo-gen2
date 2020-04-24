//
//  InvitaVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

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
