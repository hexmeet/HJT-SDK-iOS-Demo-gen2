//
//  AnonymousLinkVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension AnonymousLinkVC {
    func initContent() {
        cameraBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        micPhoneBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        cameraBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        micPhoneBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        joinBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)

        micPhoneBtn.isSelected = getSetParameter(enableMicphone) != nil ? !getSetParameter(enableMicphone)! : false
        cameraBtn.isSelected = getSetParameter(enableCamera) != nil ? !getSetParameter(enableCamera)! : false
        
        disPlayNameLb.setBorder(4, .BorderTypeAllCorners, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
        bgView.setCornerRadius(4, .allCorners)
        bgView.setAroundshadow(UIColor.black, CGSize(width: 0, height: 4), 0.3, 5)
        
        disPlayNameLb.text = Utils.judge(UIDevice.current.name)
        meetingNumberLb.text = "\(dict["confid"]!)"
    }
    
    @objc func buttonMethod(sender: UIButton) {
        let setInfo = getSetPlist()
        
        switch sender {
        case joinBtn:
            if "\(dict["protocol"] ?? "")" == "https"{
                appDelegate.evengine.enableSecure(true)
            }else {
                appDelegate.evengine.enableSecure(false)
            }
            
            if !checkCameraPermission() {
                let alert = UIAlertController.init(title: "“\("CFBundleDisplayName".infoPlist)”\("alert.access.camera".localized)", message: "alert.open.camera".localized, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "alert.noallow".localized, style: .default, handler: { (_) in
                    
                }))
                alert.addAction(UIAlertAction(title: "alert.ok".localized, style: .default, handler: { (_) in
                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                }))
                
                UIViewControllerCJHelper.findCurrentShowingViewController()?.present(alert, animated: true, completion: nil)
                return
            }else if !checkMicphonePermission() {
                let alert = UIAlertController.init(title: "“\("CFBundleDisplayName".infoPlist)”\("alert.access.micphone".localized)", message: "alert.open.micphone".localized, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "alert.noallow".localized, style: .default, handler: { (_) in
                    
                }))
                alert.addAction(UIAlertAction(title: "alert.ok".localized, style: .default, handler: { (_) in
                    UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
                }))
                
                UIViewControllerCJHelper.findCurrentShowingViewController()?.present(alert, animated: true, completion: nil)
                return
            }
            
            getTabBarVC().anonymousDialCall("\(dict["server"] ?? "")", "\(dict["port"] ?? "")", "\(dict["confid"] ?? "")", true, disPlayNameLb.text ?? "", "\(dict["password"] ?? "")", .conf)
            dismiss(animated: true, completion: nil)
            break
        case cancelBtn:
            dismiss(animated: true, completion: nil)
            break
        case cameraBtn:
            cameraBtn.isSelected = !cameraBtn.isSelected
            setInfo.setValue(!cameraBtn.isSelected, forKey: enableCamera)
            break
        case micPhoneBtn:
            micPhoneBtn.isSelected = !micPhoneBtn.isSelected
            setInfo.setValue(!micPhoneBtn.isSelected, forKey: enableMicphone)
            break
        default:
            break
        }
        
        PlistUtils.savePlistFile(setInfo as! [AnyHashable : Any], withFileName: setPlist)
    }
}
