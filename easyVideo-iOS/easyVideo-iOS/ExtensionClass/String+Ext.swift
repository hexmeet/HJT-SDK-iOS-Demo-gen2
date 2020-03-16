//
//  String+Ext.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/8.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

extension String {
    func getiPhoneName() -> String {
        return ""
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    var infoPlist: String {
        return Bundle.main.object(forInfoDictionaryKey: self) as! String
    }
}

extension UITextField {
    func selectedRange() -> NSRange {
        let beginning = self.beginningOfDocument
        let selectedRange = self.selectedTextRange
        let selectionStart = selectedRange?.start
        let selectionEnd = selectedRange?.end
        
        let location = self.offset(from: beginning, to: selectionStart!)
        let length = self.offset(from: selectionStart!, to: selectionEnd!)
        
        return NSMakeRange(location, length)
    }
    
    func setSelectedRange(_ range:NSRange) {
        let beginning = self.beginningOfDocument
        let startPosition = self.position(from: beginning, offset: range.location)
        let endPosition = self.position(from: beginning, offset: range.location + range.length)
        let selectionRange:UITextRange = self.textRange(from: startPosition!, to: endPosition!)!
        
        selectedTextRange = selectionRange
    }
}
