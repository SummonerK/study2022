//
//  WaveShowVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/31.
//

import UIKit

class WaveShowVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        initWaveView()
        // Do any additional setup after loading the view.
    }
    
    
    func initWaveView() -> Void {
        
        // 创建波浪视图
        let waveView = WaveView(frame: CGRect(x: 0, y: 100, width: kscreenW,
                                              height: 130))
        // 波浪动画回调
        waveView.closure = {centerY in
            // 同步更新文本标签的y坐标
        }
        
        self.view.addSubview(waveView)
        
        // 开始播放波浪动画
        waveView.startWave()
    }

}
