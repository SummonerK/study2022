//
//  LFPop.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/24.
//

import UIKit
enum popInType {
    case center
    case bottom
}

//let kscreenW = UIScreen.main.bounds.size.width
//let kscreenH = UIScreen.main.bounds.size.height

class PopWindowView: NSObject {
    ///弹窗背景
    private var bgView:UIView!
    ///弹窗内容
    private var contentView:UIView!
    ///弹窗布局type
    private var type:popInType!
    ///偏移
    private var offSet:CGPoint = .zero
    
    static func initPopWindowView(with contentView:UIView,type:popInType = .center,offSet:CGPoint = .zero) -> PopWindowView{
        let popWindow = PopWindowView()
        popWindow.type = type
        popWindow.offSet = offSet
        popWindow.bgView = UIView(frame: CGRect(x: 0, y: 0, width: kscreenW, height: kscreenH))
        popWindow.bgView.backgroundColor = UIColor.hexStringColor(hexString: "000000",alpha: 0)
        popWindow.contentView = contentView
        popWindow.contentView.frame.origin.y = popWindow.bgView.frame.size.height
        popWindow.bgView.addSubview(popWindow.contentView)
        popWindow.bgView.layer.masksToBounds = true
        
        return popWindow
    }
    /// 弹窗展现
    /// - Parameter Pop: 主体Object
    static func showPopWindow(with Pop:PopWindowView){
        guard let keyWindow = UIWindow.keyWindow else { return }
        keyWindow.addSubview(Pop.bgView)
        switch Pop.type{
        case .bottom:
            do {
                Pop.contentView.frame.origin.y = Pop.bgView.frame.size.height
                Pop.contentView.layoutIfNeeded()
                Pop.bgView.backgroundColor = UIColor.hexStringColor(hexString: "000000",alpha: 0)
                UIView.animate(withDuration: 0.25, animations: {
                    Pop.bgView.backgroundColor = UIColor.hexStringColor(hexString: "000000",alpha: 0.3)
                    Pop.contentView.frame.origin.y = Pop.bgView.frame.size.height - Pop.contentView.frame.size.height
                    Pop.contentView.layoutIfNeeded()
                }) { (finished) in
                    
                }
            }
            break
        case .center:
            do {
                Pop.contentView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                Pop.contentView.alpha = 0
                Pop.contentView.center = CGPoint(x: Pop.bgView.center.x+Pop.offSet.x, y: Pop.bgView.center.y+Pop.offSet.y)
                Pop.contentView.layoutIfNeeded()
                Pop.bgView.backgroundColor = UIColor.hexStringColor(hexString: "000000",alpha: 0)
                UIView.animate(withDuration: 0.25, animations: {
                    Pop.bgView.backgroundColor = UIColor.hexStringColor(hexString: "000000",alpha: 0.3)
                    Pop.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    Pop.contentView.alpha = 1
                    Pop.contentView.layoutIfNeeded()
                }) { (finished) in
                    
                }
            }
            break
        case .none:
            print("")
        }
    }
    
    /// 弹窗消失
    /// - Parameter Pop: 主体Object
    static func dismissPopWindow(with Pop:PopWindowView){
        switch Pop.type{
        case .bottom:
            do {
                Pop.bgView.backgroundColor = UIColor.hexStringColor(hexString: "000000",alpha: 0.3)
                UIView.animate(withDuration: 0.25, animations: {
                    Pop.bgView.backgroundColor = UIColor.hexStringColor(hexString: "000000",alpha: 0)
                    Pop.contentView.frame.origin.y = Pop.bgView.frame.size.height
                    Pop.contentView.layoutIfNeeded()
                }) { (finished) in
                    Pop.bgView.removeFromSuperview()
                }
            }
            break
        case .center:
            do {
                Pop.bgView.backgroundColor = UIColor.hexStringColor(hexString: "000000",alpha: 0.3)
                UIView.animate(withDuration: 0.25, animations: {
                    Pop.bgView.backgroundColor = UIColor.hexStringColor(hexString: "000000",alpha: 0)
                    Pop.contentView.alpha = 0
                    Pop.contentView.layoutIfNeeded()
                }) { (finished) in
                    Pop.bgView.removeFromSuperview()
                }
            }
            break
        case .none:
            print("")
        }
    }
}
