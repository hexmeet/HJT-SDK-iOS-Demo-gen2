//
//  LoginSettingVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/4.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class LoginSettingVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tab: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initContent()
    }
    
    //MARK: UITableViewDataSource+UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingCell.cellWithTableViewForLogin(tableView, indexRow: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath.row == 0 ? PresentSettingVC(animated: true, presentStyle: .pageSheet) : PresentAboutVC(animated: true, presentStyle: .pageSheet)
    }

}
