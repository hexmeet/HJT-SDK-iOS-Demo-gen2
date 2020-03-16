//
//  StatisticalCell.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/16.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class StatisticalCell: UITableViewCell {

    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var codecLb: UILabel!
    @IBOutlet weak var bandwidth_Lb: UILabel!
    @IBOutlet weak var rateLb: UILabel!
    @IBOutlet weak var lossrateLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc static func cellWithTableView(_ tableView: UITableView, _ indexPath: IndexPath, _ name:String, _ codec:String, _ bandwidth:String, _ rate:String, _ lossrate:String) -> StatisticalCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "StatisticalCell") as? StatisticalCell
        if (cell == nil) {
            cell = (Bundle.main.loadNibNamed("StatisticalCell", owner: self, options: nil)?.first as? UITableViewCell) as? StatisticalCell
        }
        
        cell?.nameLb.text = name
        cell?.codecLb.text = codec
        cell?.bandwidth_Lb.text = bandwidth
        cell?.rateLb.text = rate
        cell?.lossrateLb.text = lossrate
        
        return cell!
    }
    
}
