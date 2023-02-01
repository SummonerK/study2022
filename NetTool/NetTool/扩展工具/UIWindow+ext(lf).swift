//
//  UIWindow+ext(lf).swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/13.
//

import Foundation

extension UIWindow {
    static var keyWindow: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            if let window = UIApplication.shared.delegate?.window as? UIWindow {
                return window
            } else {
                for window in UIApplication.shared.windows where window.windowLevel == .normal && !window.isHidden {
                    return window
                }
                return UIApplication.shared.windows.first
            }
        }
    }
    
    func topMostWindowController()->UIViewController? {
        var topController = rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }
    
    func currentTabBarController() -> UIViewController? {
        let currentViewController = topMostWindowController()
        if currentViewController is UITabBarController{
            return currentViewController
        }
        return currentViewController
    }
    
    func currentViewController()->UIViewController? {
        var currentViewController = topMostWindowController()
        if currentViewController is UITabBarController{
            currentViewController = (currentViewController as! UITabBarController).selectedViewController
        }
        while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        
        return currentViewController
    }
}

