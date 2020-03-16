//
//  VideoView.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class VideoView: NibView {

    @IBOutlet weak var videoV: UIView!
    @IBOutlet weak var layerBg: UIView!
    @IBOutlet weak var videoStateView: UIView!
    @IBOutlet weak var muteImg: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var nameConstraint: NSLayoutConstraint!
    
    func setActiveSpeaker() {
        layerBg.layer.borderColor = UIColor.init(formHexString: "0xffae00").cgColor
    }
    
    func setNormolSpeaker() {
        layerBg.layer.borderColor = UIColor.clear.cgColor
    }
    
    func setLocalBorderColor() {
        layerBg.layer.borderColor = UIColor.init(formHexString: "0x4381ff").cgColor
    }

}
