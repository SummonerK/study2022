//
//  BaseVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/10/24.
//

import UIKit
import SnapKit

class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.backgroundColor = UIColor.hexStringColor(hexString: "f5f5f5")
        setNavigationView()
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //启用滑动返回（swipe back）
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        
        // MARK: - 如果是webView，左滑手势又会失效，新增一个左滑手势
        //新建一个滑动手势
//        let tap = UISwipeGestureRecognizer(target:self, action:nil)
//        tap.delegate = self
//        self.webView.addGestureRecognizer(tap)
    }
    
    //返回true表示所有相同类型的手势辨认都会得到处理
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer:
        UIGestureRecognizer) -> Bool {
        return true
    }
    
    //是否允许手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer) {
            //只有二级以及以下的页面允许手势返回
            return self.navigationController!.viewControllers.count > 1
        }
        return true
    }
    
    func setNavigationView() -> Void {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
             //设置取消按钮的字
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: baseTextColor33]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        } else {
            UINavigationBar.appearance().barTintColor = baseTextColor33
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().tintColor = .white
        }
        
        setUpBackItem()
        
        
//        let setBtnItem: UIBarButtonItem = UIBarButtonItem.init(customView: self.setBtn)
//        let negativeSpacer: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        negativeSpacer.width = 20
//        self.navigationItem.rightBarButtonItems = [UIBarButtonItem](arrayLiteral: negativeSpacer, setBtnItem)
        
        
    }
    
    func setClearBar() -> Void {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    func setUpBackItem() -> Void {
        let view = UIView()
        view.frame = CGRectMake(0, 0, 60, 44)
        view.backgroundColor = UIColor.clear
        
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.hexStringColor(hexString: "333333")
        view.addSubview(label)
        label.frame = CGRectMake(0, 0, 60, 44)
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "返回"
        
        
        let setBtnItem: UIBarButtonItem = UIBarButtonItem.init(customView: view)
        let negativeSpacer: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = 8
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem](arrayLiteral: negativeSpacer, setBtnItem)
        
        view.jk.addActionClosure { tap, aview, num in
            self.navigationController?.popViewController(animated: true)
        }
    }
    

}
