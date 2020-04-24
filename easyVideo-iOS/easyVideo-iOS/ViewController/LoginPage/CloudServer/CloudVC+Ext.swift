//
//  CloudVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension CloudVC {
    func initContent() {
        backBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        joinMeetingBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
        setBtn.addTarget(self, action: #selector(buttonMethod(sender:)), for: .touchUpInside)
    }
    
    func viewWillAppear() {
        DispatchQueue.once(token: "CloudVC", block: {
            if getUserParameter(loginMethod) != nil {
                PresentCloudLoginVCPage(animated: false, presentStyle: .fullScreen)
            }
        })
    }
    
    @objc func buttonMethod(sender: UIButton) {
        switch sender {
        case backBtn:
            dismiss(animated: true, completion: nil)
            break
        case joinMeetingBtn:
            PresentCloudJoinVCCPage(animated: true, presentStyle: .fullScreen)
            break
        case loginBtn:
            PresentCloudLoginVCPage(animated: true, presentStyle: .fullScreen)
            break
        case setBtn:
            PresentLoginSettingVCPage(animated: true, presentStyle: .fullScreen)
            break
        default: break
        }
    }
}
