//
//  SwiftCrashTool.swift
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/2/26.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

import Foundation

private let kSwiftCrashPath: String = FileTools.getDocumentsFailePath() + "/Log/crash.txt"

class SwiftCrashTool {
    
    /// 启动异常捕获监听
    class func startCrashListener() {
        // 检查本地是否存在
        if  !FileTools.isExist(withFile: kSwiftCrashPath) {
            let str = "文件"
            try? str.write(toFile: kSwiftCrashPath, atomically: true, encoding: .utf8)
        }
        SwiftCrashTool.registerSignalHandler()
        SwiftCrashTool.registerExceptionHandle()
    }
    
    /// 注册iOS异常崩溃回调
    class private func registerExceptionHandle() {
        NSSetUncaughtExceptionHandler { (exception) in
            let fileHandle = FileHandle.init(forUpdatingAtPath: kSwiftCrashPath)
            fileHandle?.seekToEndOfFile()
            let reason = exception.reason ?? "未知原因"
            let arr = exception.callStackSymbols
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd' at 'HH:mm:ss.SSS"
            let dealStr = "======异常崩溃报告======\ndate: \(timeFormatter.string(from: Date()))\nname: \(exception.name)\nreason: \(reason)\ncallStackSymbols:\n\(arr.joined(separator: "\n"))"
            let data = dealStr.data(using: .utf8)
            fileHandle?.write(data!)
            fileHandle?.closeFile()
        }
    }
    /// 注册swift信号崩溃回调
    class private func registerSignalHandler() {
        
        func SignalExceptionHandler(signal:Int32) -> Void {
            var mstr: String = ""
            //增加错误信息
            for symbol in Thread.callStackSymbols {
                mstr = mstr.appendingFormat("%@\r\n", symbol)
            }
            if !mstr.isEmpty {
                try? mstr.write(toFile: kSwiftCrashPath, atomically: true, encoding: .utf8)
            }
            exit(signal)
        }
        // 注册程序由于abort()函数调用发生的程序中止信号
        signal(SIGABRT, SignalExceptionHandler)
        // 注册程序由于非法指令产生的程序中止信号
        signal(SIGILL, SignalExceptionHandler)
        // 注册程序由于无效内存的引用导致的程序中止信号
        signal(SIGSEGV, SignalExceptionHandler)
        // 注册程序由于内存地址未对齐导致的程序中止信号
        signal(SIGBUS, SignalExceptionHandler)
        // 注册程序由于浮点数异常导致的程序中止信号
        signal(SIGFPE, SignalExceptionHandler)
        // 程序通过端口发送消息失败导致的程序中止信号
        signal(SIGPIPE, SignalExceptionHandler)
    }
}
