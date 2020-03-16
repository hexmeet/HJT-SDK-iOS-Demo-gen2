//
//  TermsServiceVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/13.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class TermsServiceVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        inintContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createWKWebView()
    }

}
