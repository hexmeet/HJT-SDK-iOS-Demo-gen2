//
//  Extentionkeyboard.swift
//  HexMeet
//
//  Created by quanhao huang on 2019/11/20.
//  Copyright © 2019 fo. All rights reserved.
//

import UIKit

typealias ExtentionVideoBlock = () -> Void
typealias ExtentionAudioBlock = () -> Void
class Extentionkeyboard: UIView {

    @objc var extentionVideoBlock: ExtentionVideoBlock!
    @objc var extentionAudioBlock: ExtentionAudioBlock!
    
    @IBAction func audioAction(_ sender: Any) {
        if self.extentionAudioBlock != nil {
            self.extentionAudioBlock!()
        }
    }
    
    @IBAction func videoAction(_ sender: Any) {
        if self.extentionVideoBlock != nil {
            self.extentionVideoBlock!()
        }
    }
    
}
