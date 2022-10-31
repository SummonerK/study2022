//
//  AppDelegate.swift
//  NetTool
//
//  Created by luoke_ios on 2022/8/11.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let naviC = UINavigationController(rootViewController: HomePageVC())
        window?.rootViewController = naviC
        window?.makeKeyAndVisible()
        
        return true
    }


}

