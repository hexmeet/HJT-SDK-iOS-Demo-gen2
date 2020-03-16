//
//  StatisticalVC.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/16.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class StatisticalVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statisLb: UILabel!
    @IBOutlet weak var tab: UITableView!
    var timerSecond: Timer?
    var sgnalArr: Array<EVStreamStats> = []
    let dataArray = NSMutableArray.init(capacity: 1)
    let codecsArr = NSMutableArray.init(capacity: 1)
    let rateArr = NSMutableArray.init(capacity: 1)
    let fblArr = NSMutableArray.init(capacity: 1)
    let loseArr = NSMutableArray.init(capacity: 1)
    let loseNum = NSMutableArray.init(capacity: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContent()
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StatisticalCell.cellWithTableView(tableView, indexPath, "\(dataArray[indexPath.row])", "\(codecsArr[indexPath.row])", "\(rateArr[indexPath.row])", "\(fblArr[indexPath.row])", "(\(loseNum[indexPath.row]))\(loseArr[indexPath.row])%")
        return cell
    }

}
