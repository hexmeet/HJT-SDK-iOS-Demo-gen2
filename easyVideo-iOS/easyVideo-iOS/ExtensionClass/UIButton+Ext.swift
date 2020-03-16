//
//  UIButton+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/2/18.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

class EnlargeEdgeButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let margin: CGFloat = 20
        let area = self.bounds.insetBy(dx: -margin, dy: -margin) //负值是方法响应范围
        return area.contains(point)
    }
}
