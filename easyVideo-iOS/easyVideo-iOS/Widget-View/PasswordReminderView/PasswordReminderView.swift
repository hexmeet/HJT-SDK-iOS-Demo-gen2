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
        backView.layer.cornerRadius = 4
        backView.layer.masksToBounds = true
        
        leftBtn.layer.cornerRadius = 4
        leftBtn.layer.borderWidth = 1
        leftBtn.layer.borderColor = UIColor.init(formHexString: "0xc1c1c1").cgColor
        leftBtn.layer.masksToBounds = true
        
        passwordTF.layer.cornerRadius = 4
        
        rightBtn.layer.cornerRadius = 4
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func joinAction(_ sender: Any) {
        if passwordTF.text?.count != 0 {
            if joinblock != nil {
                joinblock!(passwordTF.text!)
            }
        }
    }
}
