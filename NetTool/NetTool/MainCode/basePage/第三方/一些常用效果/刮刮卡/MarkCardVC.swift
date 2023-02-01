//
//  MarkCardVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/29.
//

import UIKit

class MarkCardVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = baseBGColor
        
        
        
        setUpMarkCard()
        // Do any additional setup after loading the view.
    }
    
    func setUpMarkCard() -> Void {
        //创建刮刮卡组件
        let scratchCard = ScratchCard(frame: CGRect(x:(kscreenW-241)/2, y:100, width:241, height:106),
                                       couponImage: UIImage(named: "coupon.png")!,
                                       maskImage: UIImage(named: "mask.png")!)
        //设置代理
        scratchCard.delegate = self
        self.view.addSubview(scratchCard)
    }

}

extension MarkCardVC:ScratchCardDelegate{
    //滑动开始
    func scratchBegan(point: CGPoint) {
        print("开始刮奖：\(point)")
    }
    
    //滑动过程
    func scratchMoved(progress: Float) {
        print("当前进度：\(progress)")
        //显示百分比
        let percent = String(format: "%.1f", progress * 100)
    }
    
    //滑动结束
    func scratchEnded(point: CGPoint) {
        print("停止刮奖：\(point)")
    }
}
