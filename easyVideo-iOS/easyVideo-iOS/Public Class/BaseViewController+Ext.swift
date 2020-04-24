//
//  BaseViewController+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation
import WebKit
import MessageUI

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
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNav() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func hiddenTabBar() {
        let views: NSArray = tabBarController!.view.subviews as NSArray
        let tabbarView: UIView = views[0] as! UIView
        let tabbar = UITabBarController()
        let tabBarHeight: CGFloat = tabbar.tabBar.frame.size.height
        
        tabbarView.height -= tabBarHeight
        tabBarController?.tabBar.isHidden = true
    }
    
    func showTabBar() {
        let views: NSArray = tabBarController!.view.subviews as NSArray
        let tabbarView: UIView = views[0] as! UIView
        let tabbar = UITabBarController()
        let tabBarHeight: CGFloat = tabbar.tabBar.frame.size.height

        tabbarView.height += tabBarHeight
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func customNavItem() {
        let navTitleFont = UIFont.boldSystemFont(ofSize: 17)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(formHexString: "0x313131") as Any, NSAttributedString.Key.font: navTitleFont as Any]
        UIBarButtonItem.appearance().tintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
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
        navigationItem.leftBarButtonItems = [space, backButtonItem]
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
        navigationController?.popViewController(animated: true)
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
            showHud("alert.emailnotSet".localized, view, .MBProgressHUBPositionBottom, 2)
        }
    }
}

// MARK: LoginVC+Ext
extension LoginVC {
    func initContent() -> Void {
        let companyGest = UITapGestureRecognizer(target: self, action: #selector(companyTap))
        let cloudGest = UITapGestureRecognizer(target: self, action: #selector(cloudTap))
        
        companyImg.addGestureRecognizer(companyGest)
        cloudImg.addGestureRecognizer(cloudGest)
        
        companyLb.text = "CompanyName".infoPlist
        
        navigationController?.setNavigationBarHidden(true, animated: true)
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
