//
//  RainbowProgressVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/30.
//

import UIKit

class RainbowProgressVC: BaseVC {
    
    //滑块组件
    @IBOutlet weak var slider: UISlider!
    
    //开关组件
    @IBOutlet weak var uiSwitch: UISwitch!
    
    //彩虹进度条组件
    var rainbowProgress:RainbowProgress!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = baseBGColor
        
        setUpRainbowProgress()
        
        setUpActions()

        // Do any additional setup after loading the view.
    }
    
    func setUpActions() -> Void {
        slider.jk.setHandle { [weak self] progressValue in
            guard let self = self else { return }
            //设置进度
            self.rainbowProgress.progressValue = CGFloat(progressValue ?? 0)
        }
        
        uiSwitch.jk.setHandle { [weak self] isOn in
            guard let self = self else { return }
            let switchValue = isOn ?? false
            if switchValue{
                //开始播放彩虹动画
                self.rainbowProgress.startAnimating()
            }else{
                //停止播放彩虹动画
                self.rainbowProgress.stopAnimating()
            }
        }
    }
    
    func setUpRainbowProgress() -> Void {
        //创建彩虹进度条
        
        //创建彩虹进度条
        let frame = CGRect(x:0, y:50, width:self.view.frame.width, height:4)
        rainbowProgress = RainbowProgress(frame: frame)

        //开始播放彩虹动画
        rainbowProgress.startAnimating()
    
        //将彩虹进度条添加到界面上
        self.view.addSubview(rainbowProgress)
    }

}
