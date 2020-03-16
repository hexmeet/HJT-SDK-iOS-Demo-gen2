//
//  DispatchQueue+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/8.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension DispatchQueue {
    private static var _onceToken = [String]()
    
    class func once(token: String = "\(#file):\(#function):\(#line)", block: ()->Void) {
        objc_sync_enter(self)
        
        defer
        {
            objc_sync_exit(self)
        }

        if _onceToken.contains(token)
        {
            return
        }

        _onceToken.append(token)
        block()
    }
}
