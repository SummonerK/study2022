//
//  BaseNaviController.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/17.
//

import UIKit

let baseBGColor = UIColor.hexStringColor(hexString: "F5F5F5")
let baseLightColor = UIColor.hexStringColor(hexString: "7D78FF")
let baseTextColor33 = UIColor.hexStringColor(hexString: "333333")
let baseTextColor66 = UIColor.hexStringColor(hexString: "666666")
let baseTextColor99 = UIColor.hexStringColor(hexString: "999999")
let baseToastBGColor = UIColor.hexStringColor(hexString: "000000",alpha: 0.4)

class BaseNaviController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    var popBlock = {()in}
    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
    var popToRootBlock = {()}
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        return super.popToRootViewController(animated: animated)
    }

}
