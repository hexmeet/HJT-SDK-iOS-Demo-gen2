//
//  SwitchCell.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/6.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc static func cellWithTableView(_ tableView: UITableView, indexRow: IndexPath) -> SwitchCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as? SwitchCell
        if (cell == nil) {
            cell = (Bundle.main.loadNibNamed("SwitchCell", owner: self, options: nil)?.first as? UITableViewCell as! SwitchCell)
        }
        
        let setInfo = getSetPlist()
        
        if indexRow.section == 2 {
            cell?.cellTitle.text = "1080P"
            if setInfo[enable1080P] != nil {
                cell?.switchBtn.isOn = setInfo[enable1080P] as! Bool
            }else {
                cell?.switchBtn.isOn = false
            }
        }else if indexRow.section == 3 {
            cell?.cellTitle.text = "set.enablehighframerate".localized
            if setInfo[enableHeightFramRate] != nil {
                cell?.switchBtn.isOn = setInfo[enableHeightFramRate] as! Bool
            }else {
                cell?.switchBtn.isOn = false
            }
        }else if indexRow.section == 4 {
            cell?.cellTitle.text = "set.disableprompt".localized
            if setInfo[enableCloseTip] != nil {
                cell?.switchBtn.isOn = setInfo[enableCloseTip] as! Bool
            }else {
                cell?.switchBtn.isOn = false
            }
        }else if indexRow.section == 5 {
            cell?.cellTitle.text = "set.autoanswer".localized
            if setInfo[enableAutoAnswer] != nil {
                cell?.switchBtn.isOn = setInfo[enableAutoAnswer] as! Bool
            }else {
                cell?.switchBtn.isOn = false
            }
        }
        
        cell?.switchBtn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cell?.switchBtn.tag = indexRow.section;

        return cell!
    }
    
    @IBAction func switchActionForSeetingVC(_ sender: UISwitch) {
        let setInfo = getSetPlist()
        
        switch sender.tag {
        case 2:
            setInfo.setValue(sender.isOn, forKey: enable1080P)
            appDelegate.evengine.enableHD(sender.isOn)
            
            DDLogWrapper.logInfo("enableHD:\(sender.isOn)")
            break
        case 3:
            setInfo.setValue(sender.isOn, forKey: enableHeightFramRate)
            appDelegate.evengine.enableHighFPS(sender.isOn)
            
            DDLogWrapper.logInfo("enableHighFPS:\(sender.isOn)")
            break
        case 4:
            setInfo.setValue(sender.isOn, forKey: enableCloseTip)
            break
        case 5:
            setInfo.setValue(sender.isOn, forKey: enableAutoAnswer)
            break
        default:
            break
        }
        
        PlistUtils.savePlistFile(setInfo as! [AnyHashable : Any], withFileName: setPlist)
    }
    
}
