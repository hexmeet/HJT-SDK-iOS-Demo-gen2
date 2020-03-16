//
//  PrivateVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/3.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class PrivateVC: BaseViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var joinMeetingBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var setBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppear()
    }
    
}
