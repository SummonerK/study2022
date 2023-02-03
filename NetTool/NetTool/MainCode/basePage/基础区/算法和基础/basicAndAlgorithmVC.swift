//
//  basicAndAlgorithmVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/1.
//

import UIKit

class basicAndAlgorithmVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setListData() -> Void {
        listDataInsert(keyWork: "算法（）", content: exampleVC())
        listDataInsert(keyWork: "算法（二叉树）", content: binaryTreeNoteVC())
        listDataInsert(keyWork: "算法（两数之和）", content: TwoNumSumVC())
        listDataInsert(keyWork: "算法（二分查找）", content: halfFindVC())
    }
    
}
