//
//  AnonymousLinkVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/20.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class AnonymousLinkVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var meetingNumberLb: UILabel!
    @IBOutlet weak var disPlayNameLb: LimitTextField!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var micPhoneBtn: UIButton!
    
    var dict = NSMutableDictionary.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContent()
    }
    
    // MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == disPlayNameLb {
            if !Utils.judgeSpecialCharacter(["\"", "<", ">"], withStr: string) {
                self.view.endEditing(true)
                showHud("alert.specialcharacter".localized, self.view, .MBProgressHUBPositionBottom, 2)
            }
            return Utils.judgeSpecialCharacter(["\"", "<", ">"], withStr: string)
        }
        return true
    }

}
