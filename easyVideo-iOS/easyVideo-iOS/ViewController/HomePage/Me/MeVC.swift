//
//  MeVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/3.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class MeVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var disPlayNameLb: UILabel!
    @IBOutlet weak var accoutLb: UILabel!
    @IBOutlet weak var pushMeDetailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDisplayContent()
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingCell.cellWithTableViewForME(tableView, indexRow: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView_(tableView, didSelectRowAt: indexPath)
    }
    
}
