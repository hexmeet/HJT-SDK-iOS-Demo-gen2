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

extension UIButton{
    private struct RuntimeKey {
        static let clickEdgeInsets = UnsafeRawPointer.init(bitPattern: "clickEdgeInsets".hashValue)
    }
    public var hw_clickEdgeInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        var bounds = self.bounds
        if (hw_clickEdgeInsets != nil) {
            let x: CGFloat = -(hw_clickEdgeInsets?.left ?? 0)
            let y: CGFloat = -(hw_clickEdgeInsets?.top ?? 0)
            let width: CGFloat = bounds.width + (hw_clickEdgeInsets?.left ?? 0) + (hw_clickEdgeInsets?.right ?? 0)
            let height: CGFloat = bounds.height + (hw_clickEdgeInsets?.top ?? 0) + (hw_clickEdgeInsets?.bottom ?? 0)
            bounds = CGRect(x: x, y: y, width: width, height: height) //负值是方法响应范围
        }
        return bounds.contains(point)
    }
}
