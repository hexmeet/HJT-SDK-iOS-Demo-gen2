//
//  NormalCell.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/6.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class NormalCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDetailLb: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var line: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc static func cellWithTableViewForSeetingVC(_ tableView: UITableView, IndexPath indexPath: IndexPath) -> NormalCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell") as? NormalCell
        if (cell == nil) {
            cell = (Bundle.main.loadNibNamed("NormalCell", owner: self, options: nil)?.first as? UITableViewCell) as? NormalCell
        }
        
        if indexPath.section == 0 {
            cell?.cellTitle.text = "set.senddiagnostics".localized
        }else {
            cell?.cellTitle.text = "set.feedback".localized
        }
        cell?.bottomConstraint.constant = 10
        cell?.line.isHidden = true
        
        return cell!
    }
    
    @objc static func cellWithTableViewForAboutVC(_ tableView: UITableView, indexRow row: Int) -> NormalCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell") as? NormalCell
        if (cell == nil) {
            cell = (Bundle.main.loadNibNamed("NormalCell", owner: self, options: nil)?.first as? UITableViewCell) as? NormalCell
        }
    
        if row == 0 {
            cell?.cellTitle.text = "set.about.licenceAndServiceAgreement".localized
        }else if row == 1 {
            cell?.cellTitle.text = "set.about.PrivacyPolicy".localized
        }else if row == 2 {
            cell?.cellTitle.text = "set.about.checkversion".localized
        }
        cell?.bottomConstraint.constant = 0
        cell?.line.isHidden = false
        
        return cell!
    }
    
    @objc static func cellWithTableViewForUserInformationVC(_ tableView: UITableView, indexRow row: Int) -> NormalCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell") as? NormalCell
        if (cell == nil) {
            cell = (Bundle.main.loadNibNamed("NormalCell", owner: self, options: nil)?.first as? UITableViewCell) as? NormalCell
        }

        cell?.bottomConstraint.constant = 0
        cell?.line.isHidden = false
        cell?.cellTitle.text = "me.name".localized
        cell?.cellDetailLb.isHidden = false
        cell?.cellDetailLb.text = PlistUtils.loadPlistFilewithFileName(userPlist)[displayName] as? String
        
        return cell!
    }
    
}
