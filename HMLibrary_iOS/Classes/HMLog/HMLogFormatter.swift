//
//  HMLogFormatter.swift
//  HMLibrary_iOS
//
//  Created by CNCEMN188807 on 2023/12/24.
//

import CocoaLumberjack

fileprivate let dateFormatter = DateFormatter()

/// 日志格式
public class HMLogFormatter: NSObject, DDLogFormatter {
    
    public func format(message logMessage: DDLogMessage) -> String? {
        var logFlag = "all"
        switch logMessage.flag {
        case .debug:
            logFlag = "Debug"
        case .error:
            logFlag = "Error"
        case .info:
            logFlag =  "Info"
        case .verbose:
            logFlag = "Verbose"
        case .warning:
            logFlag = "Warning"
        default:
            logFlag = "all"
        }

        dateFormatter.dateFormat = "MM-dd HH:mm:ss"
        let timeStamp = dateFormatter.string(from: Date())

        let formatLog = "\(timeStamp)\n \(logFlag)\n file: \(logMessage.fileName)\n fuction: \(logMessage.function ?? "")\n line: \(logMessage.line)\n message: \(logMessage.message)"
        return formatLog
    }
}

/// 重写文件名
class HMLogFileManager: DDLogFileManagerDefault {

    override var newLogFileName: String {
        get {
            dateFormatter.dateFormat = "MM-dd HH:mm:ss"
            let fileName = dateFormatter.string(from: Date())
            return "\(fileName).log"
        }
    }
}
