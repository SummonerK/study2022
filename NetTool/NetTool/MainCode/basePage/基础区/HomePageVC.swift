//
//  HomePageVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/10/24.
//


import UIKit
import RxSwift
import RxCocoa
import JKSwiftExtension
import SwiftyJSON

let gaodeKey = "8a5259c56a2d3bf889a9a099511b1a2a"

class HomePageVC: BaseListVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setListData() -> Void {
        listDataInsert(keyWork: "basic（API）", content: BasicShowVC())
        listDataInsert(keyWork: "basic（system）", content: BasicSystemFucVC())
        listDataInsert(keyWork: "basic（layout）", content: BasicLayoutVC())
        listDataInsert(keyWork: "basic（算法）", content: basicAndAlgorithmVC())
    }
    
}


