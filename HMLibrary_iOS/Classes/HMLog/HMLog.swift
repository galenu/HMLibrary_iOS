//
//  HMLog.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/23.
//

import CocoaLumberjack

/// 日志
public class HMLog {
    
    /// Log日志配置
    /// - Parameters:
    ///   - isAddConsoleLog: 是否添加控制台打印日志
    ///   - isAddFileLog: 是否添加文件日志
    ///   - fileLogPath: 文件日志磁盘路径
    ///   - maxHour: log文件在maxHour小时内有效
    ///   - maxNumberOfLogFiles: 最多保存log文件个数
    ///   - logFilesDiskSize: 磁盘日志最大多少兆
    ///   - logFormatter: 日志打印格式
    public static func configLog(isAddConsoleLog: Bool = true,
                                 isAddFileLog: Bool = true,
                                 fileLogPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/Logs"),
                                 maxHour: TimeInterval = 24,
                                 maxNumberOfLogFiles: UInt = 1, 
                                 logFilesDiskSize: UInt64 = 200,
                                 logFormatter: DDLogFormatter = HMLogFormatter()) {
        
        if isAddConsoleLog {
            // 添加控制台打印
            DDLog.add(DDOSLogger.sharedInstance)
        }
        if isAddFileLog {
            debugPrint("--- 日志文件存放路径 ---: \(String(describing: fileLogPath))")
            
            let fileManager = HMLogFileManager(logsDirectory: fileLogPath)
            let fileLogger = DDFileLogger(logFileManager: fileManager)
            
            // log文件在maxHour小时内有效，超过时间创建新log文件(默认值是24小时)
            fileLogger.rollingFrequency = 60 * 60 * maxHour
            // 最多保存maxNumberOfLogFiles个log文件
            fileLogger.logFileManager.maximumNumberOfLogFiles = maxNumberOfLogFiles
            // log文件夹最多保存logFilesDiskSize兆
            fileLogger.logFileManager.logFilesDiskQuota = 1024 * 1024 * logFilesDiskSize
            // 设置日志格式
            fileLogger.logFormatter = logFormatter
            
            // 添加文件日志
            DDLog.add(fileLogger)
        }
    }
}

extension HMLog {
    
    public class func debug(_ message: @autoclosure () -> Any,
                            file: StaticString = #file,
                            function: StaticString = #function,
                            line: UInt = #line) {
        DDLogDebug(message(),
                   file: file,
                   function: function,
                   line: line)
    }

    public class func info(_ message: @autoclosure () -> Any,
                           file: StaticString = #file,
                           function: StaticString = #function,
                           line: UInt = #line) {
        DDLogInfo(message(),
                  file: file,
                  function: function,
                  line: line)
    }

    public class func warn(_ message: @autoclosure () -> Any,
                           file: StaticString = #file,
                           function: StaticString = #function,
                           line: UInt = #line) {
        DDLogWarn(message(),
                  file: file,
                  function: function,
                  line: line)
    }

    public class func verbose(_ message: @autoclosure () -> Any,
                              file: StaticString = #file,
                              function: StaticString = #function,
                              line: UInt = #line) {
        DDLogVerbose(message(),
                     file: file,
                     function: function,
                     line: line)
    }

    public class func error(_ message: @autoclosure () -> Any,
                            file: StaticString = #file,
                            function: StaticString = #function,
                            line: UInt = #line) {
        DDLogError(message(),
                   file: file,
                   function: function,
                   line: line)
    }
}
