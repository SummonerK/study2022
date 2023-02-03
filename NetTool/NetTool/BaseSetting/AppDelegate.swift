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
        
        ///外围设备列表
        // if waked up by the system, with bluetooth identifier in parameter :
        // We need to initialize a central manager, with same name.
        // a bluetooth event accoured.
        //
        if let peripheralManagerIdentifiers: [String] = launchOptions?[UIApplication.LaunchOptionsKey.bluetoothPeripherals] as? [String]{
            if peripheralManagerIdentifiers.count == 1 {
                // only one central Manager to initialize again
                let identifier = peripheralManagerIdentifiers.first
                print("UIApplicationLaunchOptionsKey.bluetoothPeripherals] : ")
                print("App was closed by system. will restore the peripheral manager")
                print("--> " + identifier!)
            }
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarC()
        window?.makeKeyAndVisible()
        
        sleep(2)
        return true
    }


}

