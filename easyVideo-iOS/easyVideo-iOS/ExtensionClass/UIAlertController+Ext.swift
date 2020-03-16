//
//  UIAlertController+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/3/2.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension UIAlertController {
    func creatAlertController(_ title: String, _ message: String, _ style: Style) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        alert.addAction(UIAlertAction(title: "alert.sure".localized, style: .default, handler: { (_) in
        }))
        
        return alert
    }
}
