//
//  CloudLoginVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/4.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class CloudLoginVC: BaseViewController, ManagerDelegate {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var accoutTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        autoLogin()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Manager.shared().removeDelegate(self)
    }
    
    // MARK: ManagerDelegate
    func onLoginSucceed(forMg user: EVUserInfo) {
        userLoginSucceed(user)
    }
    
    func onError(forMg err: EVError) {
        onError_(forMg: err)
    }

}
