//
//  ConnectingVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension ConnectingVC {
    func initContent() {
        hangUpBtn.addTarget(self, action: #selector(hangUpAction), for: .touchUpInside)
    }
    
    func creatRippleAnimationView() {
        if !(animationView != nil) {
            animationView = RippleAnimationView(frame: CGRect(x: 0, y: 0, width: 75, height: 75), animationType: .withBackground)!
        }
        
        view.addSubview(animationView!)
        view.bringSubviewToFront(callImg)
        view.bringSubviewToFront(sipNumberLb)
    }
    
    func removeRippleAnimationView() {
        if animationView != nil {
            animationView?.removeFromSuperview()
            animationView = nil
        }
    }
    
    @objc func hangUpAction() {
        appDelegate.hiddenConnectWindow()
    }
}
