//
//  NumTwoVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/17.
//

import UIKit
import RxSwift
import RxCocoa
import JKSwiftExtension
import SwiftyJSON

class NumTwoVC: BaseListVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setListData() -> Void {
        listDataInsert(keyWork: "BlueTooth 蓝牙", content: LXBlueToothVC())
        listDataInsert(keyWork: "RxSwift-响应式编程", content: RxSwiftTestListVC())
    }
}

