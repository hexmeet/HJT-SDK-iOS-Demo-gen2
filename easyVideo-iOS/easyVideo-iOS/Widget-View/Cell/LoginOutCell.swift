//
//  LoginOutCell.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/7.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class LoginOutCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc static func cellWithTableView(_ tableView: UITableView, indexRow row: Int) -> LoginOutCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LoginOutCell") as? LoginOutCell
        if (cell == nil) {
            cell = (Bundle.main.loadNibNamed("LoginOutCell", owner: self, options: nil)?.first as? UITableViewCell) as? LoginOutCell
        }
        
        return cell!
    }
    
}
