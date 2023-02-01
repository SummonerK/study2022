//
//  NumFourVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/17.
//

import UIKit
import RxSwift
import RxCocoa
import JKSwiftExtension
import SwiftyJSON

class NumFourVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setListData() -> Void {
        listDataInsert(keyWork: "数学公式-iosMath", content: showMathLabelVC())
        listDataInsert(keyWork: "展示富文本点击", content: fullTextViewShowLink())
        listDataInsert(keyWork: "缓存管理之YYCache", content: YYCacheUseVC())
        listDataInsert(keyWork: "组件-刮刮卡", content: MarkCardVC())
        listDataInsert(keyWork: "组件-彩虹进度条", content: RainbowProgressVC())
        listDataInsert(keyWork: "组件-水波纹", content: RadarAnimationVC())
        listDataInsert(keyWork: "组件-波浪", content: WaveShowVC())
    }

}

// MARK: - 扩展属性
private var activityShowFlagKey: Void?

extension NumFourVC{
    var activityShowFlag: Bool? {
        get { return jk_getAssociatedObject(self, &activityShowFlagKey) }
        set { jk_setRetainedAssociatedObject(self, &activityShowFlagKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}
