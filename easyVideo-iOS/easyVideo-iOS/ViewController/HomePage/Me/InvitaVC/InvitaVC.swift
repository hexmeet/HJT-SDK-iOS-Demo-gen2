//
//  InvitaVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/6.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class InvitaVC: BaseViewController {

    @IBOutlet weak var wxShareImg: UIImageView!
    @IBOutlet weak var shareToOneBtn: UIButton!
    @IBOutlet weak var shareToGroupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContent()
    }

}
