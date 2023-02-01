//
//  BasicLayoutVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/1.
//

import UIKit

class BasicLayoutVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setListData() -> Void {
        listDataInsert(keyWork: "拖动编辑 Collection", content: ManagerCollectionVC())
        listDataInsert(keyWork: "一些常用布局", content: normalMaxVC())
        listDataInsert(keyWork: "一些常用效果", content: imageExchangeVC())
        listDataInsert(keyWork: "自定义相机", content: showCameraListVC())
        listDataInsert(keyWork: "常用弹窗", content: showPopWindowVC())
        listDataInsert(keyWork: "图像处理", content: ImageBeautifyVC())
        listDataInsert(keyWork: "Lottie", content: LottieVC())
        listDataInsert(keyWork: "SVGShow", content: SVGShowVC())
        listDataInsert(keyWork: "富文本show", content: FullTextShowVC())
    }

}
