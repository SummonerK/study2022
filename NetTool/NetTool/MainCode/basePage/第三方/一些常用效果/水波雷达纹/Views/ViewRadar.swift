//
//  ViewRadar.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/30.
//

import UIKit

class ViewRadar: UIView {
    private let radarAnimation = "radarAnimation"
    private var animationLayer: CALayer?
    private var animationGroup: CAAnimationGroup?

    //初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //初始化方法
    convenience init(frame: CGRect,isRound:Bool = false) {
//        super.init(frame: frame)
        self.init(frame: frame)
        // 1. 一个动态波
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = frame
        // showRect 最大内切圆
        if isRound {
            shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)).cgPath
        } else {
            // 矩形
            shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), cornerRadius: 10).cgPath
        }

        shapeLayer.fillColor = UIColor.hexStringColor(hexString: "F5DEB3").cgColor
        // 默认初始颜色透明度
        shapeLayer.opacity = 0.0

        animationLayer = shapeLayer

        // 2. 需要重复的动态波，即创建副本
        let replicator = CAReplicatorLayer()
        replicator.frame = shapeLayer.bounds
        replicator.instanceCount = 4
        replicator.instanceDelay = 1
        replicator.addSublayer(shapeLayer)

        // 3. 创建动画组
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(floatLiteral: 1.0)  // 开始透明度
        opacityAnimation.toValue = NSNumber(floatLiteral: 0)      // 结束时透明底

        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        if isRound {
            scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.4, 0.4, 0))      // 缩放起始大小
        } else {
            scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0))      // 缩放起始大小
        }
        scaleAnimation.toValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 0))      // 缩放结束大小

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [opacityAnimation, scaleAnimation]
        animationGroup.duration = 3.0       // 动画执行时间
        animationGroup.repeatCount = HUGE   // 最大重复
        animationGroup.autoreverses = false

        self.animationGroup = animationGroup

        shapeLayer.add(animationGroup, forKey: radarAnimation)
        
        self.layer.addSublayer(replicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //开始播放动画
    func startAnimating() {
        animationLayer?.add(animationGroup!, forKey: radarAnimation)
    }
    
    //停止播放动画
    func stopAnimating(){
        animationLayer?.removeAnimation(forKey: radarAnimation)
    }
}
