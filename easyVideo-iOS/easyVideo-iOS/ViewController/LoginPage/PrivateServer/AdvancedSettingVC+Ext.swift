//
//  AdvancedSettingVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension AdvancedSettingVC {
    func initContent() {
        portTF.setBorder(4, .BorderTypeAllCorners, UIColor.init(formHexString: "0xc1c1c1")!, 1)
        
        httpSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        httpSwitch.isOn = getSetParameter(enableHttps) != nil ? getSetParameter(enableHttps)! : false
        portTF.text = getUserParameter(port) != nil ? getUserParameter(port) : ""
    }
    
    @objc func switchAction(sender: UISwitch) {
        let setInfo = getSetPlist()
        setInfo.setValue(sender.isOn, forKey: enableHttps)
        appDelegate.evengine.enableSecure(sender.isOn)
        PlistUtils.savePlistFile(setInfo as! [AnyHashable : Any], withFileName: setPlist)
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveAction() {
        let userInfo = NSMutableDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(userPlist))
        
        portTF.text?.count != 0 ? userInfo.setValue(portTF.text, forKey: port):userInfo.setValue("", forKey: port)
        PlistUtils.savePlistFile(userInfo as! [AnyHashable : Any], withFileName: userPlist)
        
        backAction()
    }
}
