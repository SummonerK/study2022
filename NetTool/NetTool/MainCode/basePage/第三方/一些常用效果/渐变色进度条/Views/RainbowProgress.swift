//
//  RainbowProgress.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/30.
//

import UIKit

class RainbowProgress: UIView, CAAnimationDelegate {
    
    //当前正在播放动画
    var isAnimating = false
    
    //渐变层
    var gradientLayer: CAGradientLayer!
    
    //遮罩层
    var maskLayer:CAShapeLayer!
    
    //初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //创建彩虹渐变层
        gradientLayer =  CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x:0, y:0)
        gradientLayer.endPoint = CGPoint(x:1, y:0)
        gradientLayer.frame = self.frame
        
        //设置渐变层的颜色
        var rainBowColors:[CGColor] = []
        var hue:CGFloat = 0
        while hue <= 360 {
            let color = UIColor(hue: 1.0*hue/360.0, saturation: 1.0, brightness: 1.0,
                                alpha: 1.0)
            rainBowColors.append(color.cgColor)
            hue += 5
        }
        gradientLayer.colors = rainBowColors
        
        //添加渐变层
        self.layer.addSublayer(gradientLayer)
        
        //创建遮罩层（使用贝塞尔曲线绘制）
        let shapePath = UIBezierPath()
        shapePath.move(to: CGPoint(x:0, y:0))
        shapePath.addLine(to: CGPoint(x:self.bounds.size.width, y:0))
        
        maskLayer = CAShapeLayer()
        maskLayer.path = shapePath.cgPath
        maskLayer.lineWidth = self.frame.height
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.black.cgColor
        //遮罩层的起始、终止位置均为0
        maskLayer.strokeStart = 0
        maskLayer.strokeEnd = 0
        
        //设置遮罩
        gradientLayer.mask = maskLayer
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //执行动画
    func performAnimation(){
        //更新渐变层的颜色
        let fromColors = gradientLayer.colors as! [CGColor]
        let toColors = self.shiftColors(colors: fromColors)
        gradientLayer.colors = toColors
        //创建动画实现渐变颜色从左向右移动的效果
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 0.08
        //动画完成后是否要移除
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name:
                                                            CAMediaTimingFunctionName.linear)
        animation.delegate = self
        //将动画添加到图层中
        layer.add(animation, forKey: "animateGradient")
    }
    
    //动画播放结束后的响应
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //根据isAnimating属性判断是否还有继续播放动画
        if isAnimating {
            self.performAnimation()
        }
    }
    
    //将颜色数组中的最后一个元素移到数组的最前面
    func shiftColors(colors:[CGColor]) -> [CGColor] {
        //复制一个数组
        var newColors: [CGColor] = colors.map{($0.copy()!) }
        //获取最后一个元素
        let last: CGColor = newColors.last!
        //将最后一个元素删除
        newColors.removeLast()
        //将最后一个元素插入到头部
        newColors.insert(last, at: 0)
        //返回新的颜色数组
        return newColors
    }
    
    //开始播放动画
    func startAnimating() {
        if !isAnimating {
            self.isAnimating = true
            self.performAnimation()
        }
        
    }
    
    //停止播放动画
    func stopAnimating(){
        if isAnimating {
            self.isAnimating = false
        }
        
    }
    
    //当前进度
    var _progressValue:CGFloat = 0
    var progressValue:CGFloat {
        get{
            return _progressValue
        }
        set{
            _progressValue = newValue > 1 ? 1 : newValue
            _progressValue = newValue < 0 ? 0 : newValue
            self.maskLayer.strokeEnd = _progressValue
        }
    }
}
