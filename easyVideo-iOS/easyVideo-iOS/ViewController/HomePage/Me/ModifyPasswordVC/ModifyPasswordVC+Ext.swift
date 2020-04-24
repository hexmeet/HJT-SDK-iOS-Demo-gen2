//
//  ModifyPasswordVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension ModifyPasswordVC {
    func initContent() {
        title = "title.modifyPassword".localized
        
        let buttonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(modifyPasswordAction))
        buttonItem.tintColor = UIColor.init(formHexString: "0xf04848")
        navigationItem.rightBarButtonItem = buttonItem
        
        self.view.backgroundColor = UIColor.init(formHexString: "0xf7f7f7")
        
        createBackItem()
    }
    
    func tableView_(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NormalWithTFCell.cellWithTableViewForModifyPasswordVC(tableView, indexPath)
        if indexPath.section == 0 {
            cell.cellTitleLb.text = "alert.modifyp.accout".localized
            cell.cellTF.text = PlistUtils.loadPlistFilewithFileName(userPlist)[username] as? String
            cell.cellTF.isEnabled = false
        }else {
            if indexPath.row == 0 {
                cell.cellTitleLb.text = "alert.modifyp.password".localized
                cell.cellTF.placeholder = "alert.modifyp.input".localized
                cell.cellTF.isSecureTextEntry = true
            }else if indexPath.row == 1 {
                cell.cellTitleLb.text = "alert.modifyp.againpassword".localized
                cell.cellTF.placeholder = "alert.modifyp.agintinput".localized
                cell.cellTF.isSecureTextEntry = true
            }
        }
        return cell
    }
    
    @objc func modifyPasswordAction() {
        let cell = tab.cellForRow(at: NSIndexPath.init(row: 0, section: 1) as IndexPath) as! NormalWithTFCell
        let cell2 = tab.cellForRow(at: NSIndexPath.init(row: 1, section: 1) as IndexPath) as! NormalWithTFCell
        
        if cell.cellTF.text?.count == 0 || cell2.cellTF.text?.count == 0 {
            showHud("alert.pass.note.writeNew".localized, self.view, .MBProgressHUBPositionBottom, 3)
        }else if !CheckString(cell.cellTF.text!, 4, 16) {
            showHud("alert.pass.note.format".localized, self.view, .MBProgressHUBPositionBottom, 3)
        }else if cell.cellTF.text != cell2.cellTF.text {
            showHud("alert.pass.note.notMatch".localized, self.view, .MBProgressHUBPositionBottom, 3)
        }else {
            if appDelegate.evengine.changePassword(appDelegate.evengine.encryptPassword(PlistUtils.loadPlistFilewithFileName(userPlist)[password] as! String), newpassword: appDelegate.evengine.encryptPassword(cell.cellTF.text!)) == 0 {

                showHud("alert.changepasswordok".localized, self.view, .MBProgressHUBPositionBottom, 3)
                perform(#selector(loginOut), with: self, afterDelay: 1)
            }
        }
    }
    
    func CheckString(_ str: String, _ minLen: Int, _ maxLen: Int) -> Bool {
        if str.count > maxLen || str.count < minLen {
            return false
        }
        
        return true
    }
    
    @objc func loginOut() {
        if block != nil {
            block!()
        }
    }
}
