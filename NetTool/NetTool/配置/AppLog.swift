
//
// 打印通用封装 - lofi

import Foundation

// MARK: - Log
#if DEBUG// Debug 环境配置
// 1.获取打印所在的文件
let LKfile = (#file as NSString).lastPathComponent
   
// 2.获取打印所在的方法
let LKfuncName = #function
   
// 3.获取打印所在行数
let LKlineNum = #line

/// 详细打印 - debug打印
/// - Parameters:
///   - message: 打印信息
///   - file: 完整路径
///   - funcName: 方法名称
///   - lineNum: 打印所在行
func LKLog<T>(_ message:T ,file:String = #file ,funcName:String = #function,lineNum:Int = #line) {
    let LKfile = (file as NSString).lastPathComponent
    let dateString = StringFormatterUtils.dateToString(Date(), dateFormat: "yyyy/MM/dd HH:mm:ss")
    print("\(dateString)🗂class:\(LKfile)🗂\t🔐func:\(funcName)🔐\t📎lineNum:(\(lineNum)行)📎\n✏️log:\(message)")
}
/// 基础打印 - debug打印
/// - Parameter message: 打印基础内容
func LKPrint<T>(_ message:T){
    print("✏️log:\(message)")
}
#else

/// 详细打印 - debug打印
/// - Parameters:
///   - message: 打印信息
///   - file: 完整路径
///   - funcName: 方法名称
///   - lineNum: 打印所在行
func LKLog<T>(_ message:T ,file:String = #file ,funcName:String = #function,lineNum:Int = #line) {
}
/// 基础打印 - debug打印
/// - Parameter message: 打印基础内容
func LKPrint<T>(_ message:T){
}
//code
#endif

private struct StringFormatterUtils {
    static func stringToDate(_ string: String, dateFormat: String = "yyyyMMdd") -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date
    }

    static func dateToString(_ date: Date, dateFormat: String = "yyyy/MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }

    static func stringToDateString(_ string: String, fromFormat: String = "yyyyMMdd", toFormat: String = "yyyy/MM/dd") -> String {
        let fromFormatter = DateFormatter()
        fromFormatter.locale = Locale(identifier: "en_US_POSIX")
        fromFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        fromFormatter.dateFormat = fromFormat
        let date = fromFormatter.date(from: string)

        let toFormatter = DateFormatter()
        toFormatter.locale = Locale(identifier: "en_US_POSIX")
        toFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        toFormatter.dateFormat = toFormat

        let dateStr = toFormatter.string(from: date ?? Date())
        return dateStr
    }
}
