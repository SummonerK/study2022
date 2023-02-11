//
//  RxSwiftTextBindListVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/10.
//

import UIKit

class RxSwiftTextBindListVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func setListData() -> Void {
        listDataInsert(keyWork: "RxVM-双向绑定", content: RxshowBothWayBindVC())
        
    }

}
