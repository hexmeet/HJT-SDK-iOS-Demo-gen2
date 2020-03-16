//
//  ConnectingVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/15.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class ConnectingVC: BaseViewController {
    
    @IBOutlet weak var callImg: UIImageView!
    @IBOutlet weak var sipNumberLb: UILabel!
    @IBOutlet weak var hangUpBtn: UIButton!

    var animationView :RippleAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animationView?.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        animationView?.center = callImg.center
    }

}
