//
//  SettingVC+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension SettingVC {
    func initContent() {
        title = "title.parametersetting".localized
        
        createBackItem()
    }
    
    func tableView_(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = NormalCell.cellWithTableViewForSeetingVC(tableView, IndexPath: indexPath)
            return cell
        }else if indexPath.section == 1 {
            let cell = NormalCell.cellWithTableViewForSeetingVC(tableView, IndexPath: indexPath)
            return cell
        }else {
            let cell = SwitchCell.cellWithTableView(tableView, indexRow: indexPath)
            return cell
        }
    }
    
    override func goBack() {
        if backBool {
            navigationController?.popViewController(animated: true)
        }else {
            dismiss(animated: true, completion: nil)
        }
    }
}
