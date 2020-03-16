//
//  AnonymousLinkVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/20.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class AnonymousLinkVC: BaseViewController {
    
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

}
