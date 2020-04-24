//
//  UIView+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/3.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - 常用位置属性
    public var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
        }
    }
    
    public var top:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newTop) {
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }
    
    public var width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var right:CGFloat {
        get {
            return self.left + self.width
        }
    }
    
    public var bottom:CGFloat {
        get {
            return self.top + self.height
        }
    }
    
    public var centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    public var centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
    
    func setCornerRadius(_ cornerRadius: CGFloat, _ clipType: CornerClipType) {
        self.openClip = true
        self.radius = cornerRadius
        self.clipType = clipType
    }
    
    func setBorder(_ borderRadius: CGFloat?, _ borderType: CornerBorderType,  _ borderColor: UIColor, _ borderWidth: CGFloat) {
        self.openBorder = true
        self.borderType = borderType
        if borderRadius != nil {
            self.borderRadius = borderRadius!
        }
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
//    func setLayer(_ masksToBounds_: Bool, _ cornerRadius_: CGFloat, _ borderColor_: UIColor?, _ borderWidth_: CGFloat?){
////        if #available(iOS 11.0, *) {
////            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner];
////        }
//        self.layer.mask = nil
//        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius_, height: cornerRadius_))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = self.bounds
//        maskLayer.path = path.cgPath
//
//        if borderColor_ != nil && borderWidth_ != nil {
//            let borderLayer = CAShapeLayer()
//            borderLayer.frame = self.bounds
//            borderLayer.lineWidth = borderWidth_!
//            borderLayer.strokeColor = borderColor_?.cgColor
//            borderLayer.fillColor = UIColor.clear.cgColor
//            borderLayer.path = path.cgPath;
//            self.layer.insertSublayer(borderLayer, at: 0)
//        }
//        self.layer.mask = maskLayer
//    }
    
    func setAddshadow(_ color: UIColor, _ size: CGSize, _ shadowOpacity_: Float) {
        self.layer.shadowColor = color.cgColor
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = shadowOpacity_
    }
    
    func setAroundshadow(_ color: UIColor, _ size: CGSize, _ shadowOpacity_: Float, _ shadowRadius_: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = shadowOpacity_
        self.layer.shadowRadius = shadowRadius_
    }
}

