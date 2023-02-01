//
//  RxSwiftTestListVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/1.
//

import UIKit

class RxSwiftTestListVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func setListData() -> Void {
        listDataInsert(keyWork: "RxSwift-Demo", content: showRxBaseVC())
        listDataInsert(keyWork: "RxSwift-订阅", content: showRxBaseSubscribeVC())
        listDataInsert(keyWork: "RxSwift-观察者", content: showObserverVC())
    }
}
