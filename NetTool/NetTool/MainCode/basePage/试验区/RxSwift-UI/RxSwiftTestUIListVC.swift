//
//  RxSwiftTestUIListVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/10.
//

import UIKit

class RxSwiftTestUIListVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setListData() -> Void {
        listDataInsert(keyWork: "RxUI-UISwitch", content: RxShowSwitchVC())
        listDataInsert(keyWork: "RxUI-ActivityIndicator", content: RxShowUIActivityIndicatorViewVC())
        listDataInsert(keyWork: "RxUI-Stepper", content: RxShowStepperVC())
        
    }

}
