//
//  HistoryCallCell.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/21.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class HistoryCallCell: UITableViewCell {

    @IBOutlet weak var callNumberLb: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var line: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
