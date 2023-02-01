//
//  NumThreeVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/17.
//

import UIKit
import RxSwift
import RxCocoa
import JKSwiftExtension
import SwiftyJSON


class NumThreeVC: BaseListVC {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setListData() -> Void {
        listDataInsert(keyWork: "扩展（）", content: exampleVC())
    }
}

