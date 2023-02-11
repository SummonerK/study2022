//
//  showRxConditionalVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/6.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - 条件和布尔操作会根据条件发射或变换 Observables，或者对他们做布尔运算。
//原文出自：www.hangge.com  转载请保留原文链接：https://www.hangge.com/blog/cache/detail_1948.html

class showRxConditionalVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBtonBaseNext()
        
    }
    
    override func registBaseAlertCActions(withAlertC alertC: UIAlertController) {
        alertC.addAction("过滤操作符（Amb）", .default) {
            self.func_testMapAmb()
        }
        
    }

}

extension showRxConditionalVC{
    
    /*
     过滤操作符（Amb）
     该操作符就是用来过滤掉某些不符合要求的事件。
     */
    func func_testMapAmb() -> Void {
        
        let disposeBag = DisposeBag()
         
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
         
        subject1
            .amb(subject2)
            .amb(subject3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject2.onNext(1)
        subject1.onNext(20)
        subject2.onNext(2)
        subject1.onNext(40)
        subject3.onNext(0)
        subject2.onNext(3)
        subject1.onNext(60)
        subject3.onNext(0)
        subject3.onNext(0)
        
    }
    
}
