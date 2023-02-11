//
//  RxShowSwitchVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/10.
//

import UIKit
import RxSwift
import RxCocoa

class RxShowSwitchVC: BaseVC {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var switch_rx: UISwitch!
    @IBOutlet weak var segmentedControl_rx: UISegmentedControl!
    @IBOutlet weak var bton_show: UIButton!
    @IBOutlet weak var label_show: UILabel!
    
    let arrayData:Array<String> = ["热门","美妆","居家","百货"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindFuncs()
        
    }
    
    func setupBindFuncs() -> Void {
        
        bton_show.jk.addCorner(conrners: .allCorners, radius: 6)
        let attrsB = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                     .foregroundColor: UIColor.black]
        let attrsN = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                     .foregroundColor: baseTextColor99]
        segmentedControl_rx.setTitleTextAttributes(attrsN, for: .normal)
        segmentedControl_rx.setTitleTextAttributes(attrsB, for: .selected)
        
        
        switch_rx.rx.isOn.asObservable()
            .subscribe(onNext: { isOn in
                LKPrint(isOn ? "打开" : "关闭" )
            })
            .disposed(by: disposeBag)
        
        segmentedControl_rx.rx.selectedSegmentIndex.asObservable()
            .subscribe(onNext: { selectedIndex in
                LKPrint("分段选择器 -- index -- \(selectedIndex)")
            })
            .disposed(by: disposeBag)
        
        switch_rx.rx.isOn
            .bind(to: bton_show.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let showImageObservable:Observable<String> = segmentedControl_rx.rx.selectedSegmentIndex.asObservable().map { index in
            let item = self.arrayData[index]
            return "第\(index+1)序列\n\(item)"
        }
        
        showImageObservable.bind(to: label_show.rx.text)
            .disposed(by: disposeBag)
        
    }
    
}
