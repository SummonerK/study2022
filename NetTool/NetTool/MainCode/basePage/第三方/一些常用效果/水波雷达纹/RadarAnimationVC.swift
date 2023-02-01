//
//  RadarAnimationVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/30.
//

import UIKit

class RadarAnimationVC: BaseVC {
    
    //开关组件
    @IBOutlet weak var uiSwitch: UISwitch!
    //水波纹组件
    var viewRad:ViewRadar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewRadar()
        
        setUpActions()

        // Do any additional setup after loading the view.
    }
    
    func setUpActions() -> Void {
        
        uiSwitch.jk.setHandle { [weak self] isOn in
            guard let self = self else { return }
            let switchValue = isOn ?? false
            if switchValue{
                //开始播放彩虹动画
                self.viewRad.startAnimating()
            }else{
                //停止播放彩虹动画
                self.viewRad.stopAnimating()
            }
        }
    }
    
    func setUpViewRadar() -> Void {
        //创建彩虹进度条
        
        //创建彩虹进度条
        let frame = CGRect(x:50, y:100, width:120, height:120)
        viewRad = ViewRadar(frame: frame,isRound: true)

        //开始播放彩虹动画
        viewRad.startAnimating()
    
        //将彩虹进度条添加到界面上
        self.view.addSubview(viewRad)
    }

}
