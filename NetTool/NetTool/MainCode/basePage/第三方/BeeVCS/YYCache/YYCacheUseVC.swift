//
//  YYCacheUseVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/17.
//

import UIKit

class YYCacheUseVC: BaseFuncListVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setListData() {
        listDataInsert(keyWork: "Hello YYCache",
                               content: "testCacheUse")
        listDataInsert(keyWork: "YYCache -- 基本使用",
                               content: "cacheUse_baseUse")
    }
    
    @objc func testThread() -> Void {
        MBHud.showInfoWithMessage("正常")
    }
    
    
}


extension YYCacheUseVC{
    
    @objc func testCacheUse() -> Void {
        LKPrint("Hello YYCache")
    }
    
    @objc func cacheUse_baseUse() -> Void {
        showRegistFuncs()
    }
    
    
    
    
}

extension YYCacheUseVC{
    // MARK: - 基本使用
    
    func showRegistFuncs() -> Void {
        let alertC = UIAlertController.init(title: "功能列表", message: nil,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("YYCache - 同步", .default) {
            self.funcCacheForSync()
        }
    }
    
    func funcCacheForSync() -> Void {
        let str_default:NSString = "I want to know how to use YYCache"
        let key_default = "cacheKey"
        
        let myCache = YYCache(name: "LFCache")
        
        myCache?.setObject(str_default, forKey: key_default)
        
        let isContain = myCache?.containsObject(forKey: key_default)
        
        let containResult = isContain ?? false ? "有值" : "无值"
        
        LKPrint("\(containResult)")
        
        // ???: YYCache Swift 取值 崩溃
        
//        let value = myCache?.value(forKey: key_default)
//
//        LKPrint("\(String(describing: value))")
        
        myCache?.removeObject(forKey: key_default)
        
        myCache?.removeAllObjects()
    }
    
}
