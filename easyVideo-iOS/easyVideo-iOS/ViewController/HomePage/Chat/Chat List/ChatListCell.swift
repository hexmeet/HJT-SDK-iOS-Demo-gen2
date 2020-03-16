//
//  ChatListCell.swift
//  HexMeet
//
//  Created by quanhao huang on 2019/11/19.
//  Copyright © 2019 fo. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet weak var userHeadImg: UIImageView!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var messageTitleLb: UILabel!
    @IBOutlet weak var messageTimeLb: UILabel!
    @IBOutlet weak var unreadMessageBg: UIView!
    
    @IBOutlet weak var unreadMessageNumberTf: UILabel!
    @IBOutlet weak var reminderImg: UIImageView!
    @IBOutlet weak var reminderBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        unreadMessageBg.layer.insertSublayer(Utils.addgradientLayer(UIColor.init(formHexString: "ffab47"), withEnd: UIColor.init(formHexString: "ff4646"), view: self.unreadMessageBg), at: 0)
        reminderBg.layer.addSublayer(Utils.addgradientLayer(UIColor.init(formHexString: "ffab47"), withEnd: UIColor.init(formHexString: "ff4646"), view: self.reminderBg))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc static func cellWithTableView(_ tableview: UITableView) -> ChatListCell {
        let identifier = "listCell"
        var cell = tableview.dequeueReusableCell(withIdentifier: identifier)
        if (cell == nil) {
            cell = Bundle.main.loadNibNamed("ChatListCell", owner: self, options: nil)?.first as? UITableViewCell
        }
        return cell as! ChatListCell
    }
    
}
