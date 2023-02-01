//
//  MainTabBarC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/17.
//

import Foundation
import ESTabBarController_swift


class MainTabBarC: ESTabBarController {
    
    let NorMal_Color:UIColor = UIColor.init(hexString: "#999999", alpha: 1.0) ?? .green
    let Selected_Color:UIColor = UIColor.init(hexString: "#3B3B3B", alpha: 1.0) ?? .orange
    
    var tabBGView:UIView?///设置Bab背景
    let tabTitles:[String] = ["实验区","基础区","扩展区","第三方"]
    let tabImages:[String] = ["tab_tool_n","tab_home_n","tab_tool_n","tab_tool_n"]
    let tabSImages:[String] = ["tab_tool_s","tab_home_s","tab_tool_s","tab_tool_s"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFormalTab()
        
        let v1 = BaseNaviController(rootViewController: NumTwoVC())
        let v2 = BaseNaviController(rootViewController: HomePageVC())
        let v3 = BaseNaviController(rootViewController: NumThreeVC())
        let v4 = BaseNaviController(rootViewController: NumFourVC())
        
        v1.tabBarItem = getItem(index: 0)
        v2.tabBarItem = getItem(index: 1)
        v3.tabBarItem = getItem(index: 2)
        v4.tabBarItem = getItem(index: 3)
        
        tabBar.barTintColor = UIColor.white
        //移除顶部线条
//        tabBar.shadowImage = UIImage()
        
        viewControllers = [v1,v2,v3,v4];
    }
    
    func getItem(index:Int) -> ESTabBarItem {
        
        var img = UIImage(named: tabImages[index]) ?? UIImage()
        img = img.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        var selectedImg = UIImage(named:tabSImages[index]) ?? UIImage()
        selectedImg = selectedImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let tabBarItem = ESTabBarItem.init(title: tabTitles[index], image: img, selectedImage: selectedImg);
        tabBarItem.contentView?.highlightTextColor = Selected_Color
        tabBarItem.contentView?.textColor = NorMal_Color
        tabBarItem.contentView?.itemContentMode = .alwaysOriginal
        tabBarItem.contentView?.renderingMode = .alwaysOriginal
        
        return tabBarItem
    }
    
    func initFormalTab(){
        for view in tabBar.subviews{
            if type(of: view).description() == "_UIBarBackground"{
                view.alpha = 0
            }
        }
        if tabBGView != nil{
            return
        }
        tabBGView = UIView()
        tabBGView?.backgroundColor = .white
        tabBar.addSubview(tabBGView!)
        tabBGView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tabBar.insertSubview(tabBGView!, at: 1)
    }

}
