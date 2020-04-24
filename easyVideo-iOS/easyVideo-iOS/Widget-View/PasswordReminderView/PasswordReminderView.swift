//
//  PasswordReminderView.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/19.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class PasswordReminderView: UIView {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    public var joinblock : ((_ str:String)->())?
    
    override func draw(_ rect: CGRect) {
        backView.setCornerRadius(4, .allCorners)
        leftBtn.setBorder(4, .BorderTypeAllCorners, UIColor.init(formHexString: "0xc1c1c1"), 1)
        passwordTF.setCornerRadius(4, .allCorners)
        rightBtn.setCornerRadius(4, .allCorners)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        removeFromSuperview()
    }
    
    @IBAction func joinAction(_ sender: Any) {
        if passwordTF.text?.count != 0 {
            if joinblock != nil {
                joinblock!(passwordTF.text!)
            }
        }
    }
}
