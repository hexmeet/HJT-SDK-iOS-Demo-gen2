//
//  BaseViewController.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/3.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit
import MessageUI

class BaseViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var hud:MBProgressHUD! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createUI()
        
        setRootViewAttribute()
        
        setBackGroudColor(color: UIColor.white)
    }
    
    /// 创建UI
    func createUI() {
        
    }
    
    /// 设置属性
    func setRootViewAttribute() {
        
    }
    
    /// 设置背景颜色
    func setBackGroudColor(color:UIColor) {
        view.backgroundColor = color
    }

    //MARK: Mail composer for sending logs
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true) {
            if result == .sent {
                self.showHud("alert.sendSuccess".localized, self.view, .MBProgressHUBPositionBottom, 2)
                DDLogWrapper.logInfo("send email success")
            }else if result == .cancelled {
                self.showHud("alert.cancelled".localized, self.view, .MBProgressHUBPositionBottom, 2)
                DDLogWrapper.logInfo("send email cancelled")
            }else if result == .saved {
                self.showHud("alert.saved".localized, self.view, .MBProgressHUBPositionBottom, 2)
                DDLogWrapper.logInfo("send email saved")
            }else if result == .failed {
                self.showHud("alert.sendFailure".localized, self.view, .MBProgressHUBPositionBottom, 2)
                DDLogWrapper.logError("Failed to send email")
            }
        }
    }
}
