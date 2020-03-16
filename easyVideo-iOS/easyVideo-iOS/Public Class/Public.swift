//
//  Public.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/21.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

public func getInfoString(_ str: String) -> String {
    let infoDictionary = Bundle.main.infoDictionary
    if infoDictionary?[str] == nil {
        return ""
    }else{
        return (infoDictionary![str] as? String)!
    }
}

public func getUserPlist() -> NSMutableDictionary {
    return NSMutableDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(userPlist))
}

public func getUserParameter(_ parameter: String) -> String? {
    if getUserPlist()[parameter] != nil {
        return "\(getUserPlist()[parameter]!)"
    }else {
        return nil
    }
}

public func getSetPlist() -> NSMutableDictionary {
    return NSMutableDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(setPlist))
}

public func getSetParameter(_ parameter: String) -> Bool? {
    if getSetPlist()[parameter] != nil {
        return (getSetPlist()[parameter] as! Bool)
    }else {
        return nil
    }
}

public func getFeatureSupportPlist() -> NSMutableDictionary {
    return NSMutableDictionary.init(dictionary: PlistUtils.loadPlistFilewithFileName(featureSupportPlist))
}

public func getFeatureSupportParameter(_ parameter: String) -> Bool {
    if getFeatureSupportPlist()[parameter] != nil {
        return (getFeatureSupportPlist()[parameter] as! Bool)
    }else {
        return false
    }
}
