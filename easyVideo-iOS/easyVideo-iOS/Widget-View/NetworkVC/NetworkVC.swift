//
//  NetworkVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/2/29.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class NetworkVC: BaseViewController {

    @IBOutlet weak var alertTitleLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        alertTitleLb.text = "alert.networkunavailable".localized
    }
    
}
