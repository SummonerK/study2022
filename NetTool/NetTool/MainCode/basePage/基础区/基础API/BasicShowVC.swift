//
//  BasicShowVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/1.
//

import UIKit

class BasicShowVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setListData() -> Void {
        listDataInsert(keyWork: "swift GCD|Operation", content: TestGCDVC())
        listDataInsert(keyWork: "swift GCD|使用到的一些线程事例", content: ThreadUseVC())
        listDataInsert(keyWork: "面向协议编程", content: OOProtocolVC())
        listDataInsert(keyWork: "关键字（where）", content: WhereUseVC())
        listDataInsert(keyWork: "计时器（Timer）", content: showTimerVC())
        listDataInsert(keyWork: "关键字（Mutating）", content: MutatingShowVC())
    }

}
