//
//  NormalWithLbCell.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/7.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class NormalWithLbCell: UITableViewCell {

    @IBOutlet weak var cellTitleLb: UILabel!
    @IBOutlet weak var cellDetailLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc static func cellWithTableViewForUserInformationVC(_ tableView: UITableView, indexRow row: Int) -> NormalWithLbCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NormalWithLbCell") as? NormalWithLbCell
        if (cell == nil) {
            cell = (Bundle.main.loadNibNamed("NormalWithLbCell", owner: self, options: nil)?.first as? UITableViewCell) as? NormalWithLbCell
        }
    
        if row == 2 {
            cell?.cellTitleLb.text = "me.account".localized
            cell?.cellDetailLb.text = PlistUtils.loadPlistFilewithFileName(userPlist)[username] as? String
        }else if row == 3 {
            cell?.cellTitleLb.text = "me.mobile".localized
            cell?.cellDetailLb.text = PlistUtils.loadPlistFilewithFileName(userPlist)[cellphone] as? String
        }else if row == 4 {
            cell?.cellTitleLb.text = "me.email".localized
            cell?.cellDetailLb.text = PlistUtils.loadPlistFilewithFileName(userPlist)[email] as? String
        }else if row == 5 {
            cell?.cellTitleLb.text = "me.company".localized
            cell?.cellDetailLb.text = PlistUtils.loadPlistFilewithFileName(userPlist)[org] as? String
        }else if row == 6 {
            cell?.cellTitleLb.text = "me.dep".localized
            cell?.cellDetailLb.text = PlistUtils.loadPlistFilewithFileName(userPlist)[dept] as? String
        }
        
        return cell!
    }
    
}
