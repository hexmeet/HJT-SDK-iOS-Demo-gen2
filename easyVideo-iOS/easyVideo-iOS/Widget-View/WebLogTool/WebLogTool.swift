//
//  WebLogTool.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/3/1.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

private let kSwiftWebLogPath: String = FileTools.getDocumentsFailePath() + "/Log/weblog.log"
private let kSwiftWebLogPath2: String = FileTools.getDocumentsFailePath() + "/Log/weblog2.log"

class WebLogTool {
    class func startWebLog() {
        // 检查本地是否存在
        if  !FileTools.isExist(withFile: kSwiftWebLogPath) {
            let str = "文件"
            try? str.write(toFile: kSwiftWebLogPath, atomically: true, encoding: .utf8)
        }else {
            if FileTools.getFileSize(kSwiftWebLogPath) > 20000000 {
                FileTools.deleteTheFile(withFilePath: (kSwiftWebLogPath2))
                saveFile()
                FileTools.deleteTheFile(withFilePath: (kSwiftWebLogPath))
            }
        }
    }
    
    class private func saveFile() {
        try? FileManager.default.copyItem(atPath: kSwiftWebLogPath, toPath: kSwiftWebLogPath2)
    }
    
    class public func saveLog(_ log: String) {
        let fileHandle = FileHandle.init(forUpdatingAtPath: kSwiftWebLogPath)
        fileHandle?.seekToEndOfFile()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH: mm: ss: SSS"
        let logStr = "\n\(timeFormatter.string(from: Date()))" + "  " + log
        let data = logStr.data(using: .utf8)
        fileHandle?.write(data!)
        fileHandle?.closeFile()
    }
}
