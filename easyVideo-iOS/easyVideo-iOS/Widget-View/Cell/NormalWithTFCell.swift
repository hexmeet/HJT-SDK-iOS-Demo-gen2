//
//  NormalWithTFCell.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/9.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class NormalWithTFCell: UITableViewCell {

    @IBOutlet weak var cellTitleLb: UILabel!
    @IBOutlet weak var cellTF: UITextField!
    @IBOutlet weak var line: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc static func cellWithTableViewForModifyPasswordVC(_ tableView: UITableView, _ indexPath: IndexPath) -> NormalWithTFCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NormalWithTFCell") as? NormalWithTFCell
        if (cell == nil) {
            cell = (Bundle.main.loadNibNamed("NormalWithTFCell", owner: self, options: nil)?.first as? UITableViewCell) as? NormalWithTFCell
        }
        
        return cell!
    }
    
}
