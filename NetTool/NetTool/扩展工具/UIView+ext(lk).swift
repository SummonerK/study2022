//
//  UIView+ext.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/23.
//

import Foundation
import UIKit
import DeviceKit

let kscreenW = UIScreen.main.bounds.size.width
let kscreenH = UIScreen.main.bounds.size.height

extension UIView {
    
    /// 加载xib
    func loadViewFromNib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    /// 竖屏
    var safeInsets: UIEdgeInsets {
        if Device.current.isTenSeries {
            return UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0)
        }else if Device.current.isLoadDynamicIsland {
            return UIEdgeInsets(top: 54, left: 0, bottom: 34, right: 0)
        }
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
}

extension Device {
    
    var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var height: CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    ///状态条高度：x系列 44；灵动岛 54；默认20
    var heightOfStatusBar: CGFloat{
        if Device.current.isTenSeries {
            return 44
        }else if Device.current.isLoadDynamicIsland {
            return 54
        }
        return 20
    }
    
    ///底部状态条高度：x系列 34；灵动岛 34；默认0
    var heightOfBottomBar: CGFloat{
        if Device.current.isTenSeries {
            return 34
        }else if Device.current.isLoadDynamicIsland {
            return 34
        }
        return 0
    }
    
    /// 导航条高度：默认44 高度
    var heightOfNaviBar: CGFloat{
        return 44
    }
    
    /// 是否iPhoneX系列
    var isTenSeries: Bool {
        switch self {
        case .simulator(let d):
            return d.isTenSeries
        default:
            break
        }
        return self == .iPhoneX || self == .iPhoneXR || self == .iPhoneXS || self == .iPhoneXSMax || self == .iPhone11 || self == .iPhone11Pro || self == .iPhone11ProMax || self == .iPhone12 || self == .iPhone12Pro || self == .iPhone12ProMax || self == .iPhone12Mini || self == .iPhone13 || self == .iPhone13Mini || self == .iPhone13Pro || self == .iPhone13ProMax || self == .iPhone14 || self == .iPhone14Plus
    }
    
    /// 是否需要适配 灵动岛
    var isLoadDynamicIsland: Bool{
        return  self == .iPhone14Pro || self == .iPhone14ProMax
    }
    ///是否是四英寸设备
    var isFourInchScreen: Bool {
        switch self {
        case .simulator(let d):
            return d.isFourInchScreen
        default:
            break
        }
        return self == .iPhone5 || self == .iPhone5c || self == .iPhoneSE || self == .iPhone5s
    }
}
