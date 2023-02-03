//
//  focusAnimationVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/2.
//

import UIKit

class focusAnimationVC: BaseVC {
    
    @IBOutlet weak var view_top: UIView!
    @IBOutlet weak var view_mid: UIView!
    @IBOutlet weak var view_bottom: UIView!
    
    @IBOutlet weak var view_content: UIView!
    
    /// 新图层-layer
    var keyLayer: CALayer!
    
    var aniFlag = true
    
    var closeBlock={()in}


    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    func initViews() -> Void {
        view_top.backgroundColor = baseTextColor99
        view_mid.backgroundColor = baseTextColor99
        view_bottom.backgroundColor = baseTextColor99
        
        view_content.backgroundColor = .randomColor
        
        view_content.jk.addActionClosure { [weak self] _, _, _  in
            guard let self = self else { return }
            self.showAnimationWithNew()
        }
        
        self.closeBlock = { [weak self] in
            guard let self = self else { return }
            self.keyLayer.removeFromSuperlayer()
            self.aniFlag = !self.aniFlag
            self.closeView()
        }
        
    }
    
    

}

extension focusAnimationVC{
    ///直接操作图层
    func showAnimation() -> Void {
        let focusAnimation = self.animationForFocus { maker in
            maker.fromPoint = self.view_content.center
            maker.targetPoint = self.view_top.center
        }
        guard let keyAni = focusAnimation else{ return }
        //动画添加在图层上
        self.view_content.layer.add(keyAni, forKey: nil)
    }
    ///新建图层操作
    func showAnimationWithNew() -> Void {
        let focusAnimation = self.animationForFocus { maker in
            maker.fromPoint = self.view_content.center
            maker.targetPoint = self.view_top.center
        }
        keyLayer = CALayer()
        keyLayer.contents = self.view_content.jk.toImage()?.cgImage
//        keyLayer.backgroundColor = UIColor.randomColor.cgColor
        keyLayer.contentsGravity = .resizeAspectFill
        keyLayer.bounds = self.view_content.frame
        keyLayer.position = self.view_content.center
        self.view.layer.addSublayer(keyLayer)
        guard let keyAni = focusAnimation else{ return }
        //动画添加在图层上
        keyLayer.add(keyAni, forKey: nil)
    }
    
    func closeView() -> Void {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.weakView(toView: self.view_top,duration: 0.6)
        }
    }
}


class FocusParams{
    var fromPoint:CGPoint = CGPoint.zero
    var targetPoint:CGPoint = CGPoint.zero
}

//动画完成
extension focusAnimationVC:CAAnimationDelegate{
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        LKPrint("动画结束了")
        self.closeBlock()
    }
    
    func animationForFocus(_ block:(_ maker:FocusParams) ->Void) -> CAAnimationGroup? {
        let maker = FocusParams()
        block(maker)
//        缩放
        //1.创建动画
        let PTD_anim = CABasicAnimation(keyPath: "transform.scale")
        //2.设置动画属性
        PTD_anim.fromValue = 1
        PTD_anim.toValue = 0.02
        PTD_anim.repeatCount = 0
        
        //平移
        let animation_Position = CABasicAnimation.init(keyPath: "position")
        animation_Position.fromValue = maker.fromPoint
        animation_Position.toValue = maker.targetPoint
        
        /// 旋转动画
//        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
//        rotateAnimation.fromValue = 0
//        rotateAnimation.toValue = 2*CGFloat.pi
//        PTD_anim.repeatCount = 0
        
        //组合动画
        let animationGroup:CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [PTD_anim,animation_Position]
//        animationGroup.animations = [PTD_anim,animation_Position,rotateAnimation]
        animationGroup.duration = 1
        animationGroup.delegate = self
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.isRemovedOnCompletion = true
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        
        return animationGroup
    }
    
    func weakView(toView:UIView,duration:CFTimeInterval) -> Void {
        
        //连续动画组
//        let animation = CABasicAnimation.init(keyPath: "transform.scale")
//        animation.fromValue = 1
//        animation.toValue = NSNumber.init(value: 1.5)
//        animation.duration = duration
//        animation.fillMode = CAMediaTimingFillMode.forwards;
//        animation.isRemovedOnCompletion = false //切出界面再回来动画不会停止
//
//        let animation2 = CABasicAnimation.init(keyPath: "transform.scale")
//        animation2.fromValue = 1.5
//        animation2.toValue = NSNumber.init(value: 1.0)
//        animation2.duration = duration
//        animation2.fillMode = CAMediaTimingFillMode.forwards;
//        animation2.isRemovedOnCompletion = false //切出界面再回来动画不会停止
//        animation2.beginTime = duration
//
//        //组合动画
//        let animationGroup:CAAnimationGroup = CAAnimationGroup()
//        animationGroup.animations = [animation,animation2]
//        animationGroup.duration = duration*2
//        animationGroup.fillMode = CAMediaTimingFillMode.both;
//        animationGroup.isRemovedOnCompletion = false
//        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
//
//        toView.layer.add(animationGroup, forKey: nil)
        
        
        //回覆动画实现闪烁效果
        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = NSNumber.init(value: 1.2)

        //组合动画
        let animationGroup:CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [animation]
        animationGroup.duration = duration
        animationGroup.autoreverses = true //自动还原
        animationGroup.fillMode = CAMediaTimingFillMode.backwards
        animationGroup.isRemovedOnCompletion = false
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        toView.layer.add(animationGroup, forKey: nil)
    }
}

