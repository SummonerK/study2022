//
//  BasicSystemFucVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/1.
//

import UIKit

class BasicSystemFucVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setListData() -> Void {
        listDataInsert(keyWork: "规范注释", content: normalMarkVC())
        listDataInsert(keyWork: "系统功能", content: sysFuncVC())
        listDataInsert(keyWork: "下标脚本方法", content: subscriptFuncVC())
        listDataInsert(keyWork: "Data转（bytes数组）", content: DataTransVC())
    }

}
