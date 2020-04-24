//
//  Me+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension MeVC {
    func initContent() {
        pushMeDetailBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        
        customNavItem()
    }
    
    func tableView_(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            pushSettingVC(animated: true)
            break
        case 1:
            modifyPasswordAction()
            break
        case 2:
            pushInvitaVC(animated: true)
            break
        case 3:
            pushAboutVC(animated: true)
            break
        default:
            break
        }
    }
    
    func setDisplayContent() {
        let headPath = "\(FileTools.getDocumentsFailePath())/header.jpg"
        let data = getSize(url: URL.init(string: headPath) ?? URL.init(string: "")!)
        if data != 0 {
            userImg.image = UIImage.init(contentsOfFile: headPath)
        }else {
            userImg.image = UIImage.init(named: "default_photo")
        }
        
        let userInfo = PlistUtils.loadPlistFilewithFileName(userPlist)
        accoutLb.text = userInfo[username] as? String
        disPlayNameLb.text = userInfo[displayName] as? String
    }
    
    func modifyPasswordAction() {
        let alert = UIAlertController(title: "alert.pwd.pop.title".localized, message: "alert.pwd.pop.content".localized, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "alert.password".localized
            textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "alert.cancel".localized, style: .default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "alert.sure".localized, style: .default, handler: { (_) in
            let textField = alert.textFields![0]
            if textField.text?.count != 0 {
                if textField.text == getUserParameter(password) {
                    self.pushModifyPasswordVC(animated: true)
                }else {
                    self.showHud("alert.passwordError".localized, self.view, .MBProgressHUBPositionBottom, 3)
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func buttonMethod(sender: UIButton) {
        switch sender {
        case pushMeDetailBtn:
            pushUserInformationVC(animated: true)
            break
        default: break
        }
    }
}
