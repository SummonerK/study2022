//
//  headAndMorePage.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/10.
//

import UIKit
import LTScrollView

class headAndMorePage: UIViewController {
    
    private lazy var pageManager:LTSimpleManager = {
        let pageManager = LTSimpleManager(frame: rect_page, viewControllers: pages, titles: titles, currentViewController: self, layout: pageLayout)
        /* 设置代理 监听滚动 */
        pageManager.delegate = self
        return pageManager
    }()
    
    private lazy var pageLayout:LTLayout = {
        let layout = LTLayout()
        
        return layout
    }()
    
    private let rect_page:CGRect = {
        return CGRect(x: 0, y: 100, width: IBScreenW, height: IBScreenH-100-34)
    }()
    
    private var titles:Array<String> = {
        var array = Array<String>()
        array.append("淘宝")
        array.append("京东")
        array.append("拼多多")
        return array
    }()
    
    private lazy var pages:Array<UIViewController> = {
        var array = Array<UIViewController>()
        var arrar_titles = titles
        for name in arrar_titles {
            let vc = listPagesVC.setupVC(withContent: name)
            array.append(vc)
        }
        return array
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageManager()
    }

}

extension headAndMorePage{
    func setupPageManager() -> Void {
        view.addSubview(pageManager)
        //MARK: headerView设置
        pageManager.configHeaderView {[weak self] in
            guard let self = self else { return UIView() }
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 0, width: IBScreenW, height: 180)
            headerView.backgroundColor = UIColor.randomColor
//            headerView
            return headerView
        }
        
        //MARK: pageView点击事件
        pageManager.didSelectIndexHandle { (index) in
            print("点击了 \(index) 😆")
        }
    }
}

extension headAndMorePage: LTSimpleScrollViewDelegate {
    
    //MARK: 滚动代理方法
    func glt_scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("offset -> ", scrollView.contentOffset.y)
    }
    
    //MARK: 控制器刷新事件代理方法
    func glt_refreshScrollView(_ scrollView: UIScrollView, _ index: Int) {
        
    }
}
