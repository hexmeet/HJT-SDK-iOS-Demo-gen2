//
//  InvitationView.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/19.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class InvitationView: UIView {

    @IBOutlet weak var invatationNameLb: UILabel!
    @IBOutlet weak var contentLb: UILabel!
    @IBOutlet weak var headImg: UIImageView!
    
    public var btnblock : ((_ flag:Bool)->())?
    
    override func draw(_ rect: CGRect) {
        headImg.setCornerRadius(50, .allCorners)
        playSound()
    }

    @IBAction func hangUpAction(_ sender: Any) {
        stopSound()
        if btnblock != nil {
            btnblock!(false)
        }
    }
    
    @IBAction func answerAction(_ sender: Any) {
        if btnblock != nil {
            btnblock!(true)
        }
    }
    
}
