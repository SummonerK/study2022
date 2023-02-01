//
//  MBHud.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/6.
//

import Foundation

class MBHud: NSObject {
    fileprivate class func config(hud:MBProgressHUD){
        hud.animationType = .zoomOut
        hud.label.numberOfLines = 10
        hud.label.font = UIFont(name: "PingFangSC-Regular", size: 14.0)
        hud.margin = 16
        hud.contentColor = .white
        hud.bezelView.layer.cornerRadius = 8
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor(white: 0, alpha: 0.7)
    }
    
    class func showInfoWithMessage(view : UIView? = UIApplication.shared.keyWindow,_ message:String){
        guard let supview = view ?? UIApplication.shared.keyWindow else { return }
        let hud = MBProgressHUD.showAdded(to: supview, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = message
        hud.hide(animated: true, afterDelay: 2)
        hud.isUserInteractionEnabled = false
        config(hud: hud)
    }
}
