//
//  NormalWithImgCell.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/7.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class NormalWithImgCell: UITableViewCell {
    
    @IBOutlet weak var cellTitleLb: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImg.layer.cornerRadius = 20
        cellImg.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc static func cellWithTableViewForUserInformationVC(_ tableView: UITableView, indexRow row: Int) -> NormalWithImgCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NormalWithImgCell") as? NormalWithImgCell
        if (cell == nil) {
            cell = (Bundle.main.loadNibNamed("NormalWithImgCell", owner: self, options: nil)?.first as? UITableViewCell) as? NormalWithImgCell
        }
        
        cell?.cellTitleLb.text = "me.headimg".localized
        let headPath = "\(FileTools.getDocumentsFailePath())/header.jpg"
        
        let data = getSize(url: URL.init(string: headPath) ?? URL.init(string: "")!)
        if data != 0 {
            cell?.cellImg.image = UIImage.init(contentsOfFile: headPath)
        }else {
            cell?.cellImg.image = UIImage.init(named: "default_photo")
        }
        
        return cell!
    }
    
}
