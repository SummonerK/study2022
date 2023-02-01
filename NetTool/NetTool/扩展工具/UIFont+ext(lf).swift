//
//  UIFont+ext(lf).swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/9.
//

import Foundation
import UIKit

public enum PingFangFontType: String {
    case regular = "PingFangSC-Regular"
    case medium = "PingFangSC-Medium"
    case semibold = "PingFangSC-Semibold"
}

public extension UIFont {

    /// 获取苹方字体
    ///
    /// - Parameters:
    ///   - type: 字体粗细类型
    ///   - size: 字体大小
    /// - Returns: 字体
    static func pingfangSC(type:PingFangFontType = .regular, size: CGFloat) -> UIFont {
        switch type {
        case .regular:
            return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        default:
            return UIFont(name: type.rawValue, size: size) ?? UIFont.boldSystemFont(ofSize: size)
        }
    }

    /// 数字字体
    static func DINAlternate(size: CGFloat) -> UIFont {
        return UIFont(name: "DIN Alternate", size: size) ?? UIFont.pingfangSC(type: .semibold, size: size )
    }
}
