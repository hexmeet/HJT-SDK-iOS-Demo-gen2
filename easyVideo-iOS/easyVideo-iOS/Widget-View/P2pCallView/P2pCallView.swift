//
//  P2pCallView.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/20.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class P2pCallView: UIView {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var callLb: UILabel!
    var animationView:RippleAnimationView?
    
    public var btnblock : (()->())?
    
    override func draw(_ rect: CGRect) {
        playSound()
        
        headImg.setCornerRadius(50, .allCorners)
        
        appDelegate.evengine.setLocalVideoWindow(Unmanaged.passUnretained(videoView).toOpaque())
        DDLogWrapper.logInfo("setLocalVideoWindow")
        
        animationView = RippleAnimationView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50), animationType: .withBackground)
        animationView?.center = headImg.center
        addSubview(animationView!)
        bringSubviewToFront(animationView!)
        bringSubviewToFront(headImg)
        bringSubviewToFront(nameLb)
        bringSubviewToFront(callLb)
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        
        animationView?.center = headImg.center
    }
    
    @IBAction func hangUpAction(_ sender: Any) {
        stopSound()
        
        if btnblock != nil {
            btnblock!()
        }
    }
}
