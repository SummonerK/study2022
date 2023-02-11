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
        listDataInsert(keyWork: "RxSwift-绑定属性", content: showBindVC())
        listDataInsert(keyWork: "RxSwift-Subjects", content: showRxSubjectsVC())
        listDataInsert(keyWork: "RxSwift-变换操作", content: showRxTransMapVC())
        listDataInsert(keyWork: "RxSwift-过滤操作", content: showRxFilterVC())
        listDataInsert(keyWork: "RxSwift-条件操作", content: showRxConditionalVC())
        listDataInsert(keyWork: "RxSwift-特征序列（ControlProperty）", content: showRxcontrolPropertyVC.init())
    }
}
