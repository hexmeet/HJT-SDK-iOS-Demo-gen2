//
//  AdvancedSettingVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/4.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class AdvancedSettingVC: BaseViewController {

    @IBOutlet weak var portTF: UITextField!
    @IBOutlet weak var httpSwitch: UISwitch!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContent()
    }

}
