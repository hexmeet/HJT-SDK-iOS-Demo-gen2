//
//  TermsServiceVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/13.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class TermsServiceVC: BaseViewController {
    @objc var isPravicy: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        inintContent()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        createWKWebView()
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
         
    }
    

}
