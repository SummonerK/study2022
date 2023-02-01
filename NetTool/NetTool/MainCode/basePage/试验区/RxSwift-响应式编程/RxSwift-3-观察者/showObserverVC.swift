//
//  showObserverVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/1.
//

import UIKit
import RxSwift
import RxCocoa

class showObserverVC: BaseFuncListVC {
    let disposeBag = DisposeBag()
    var timerDisposable: Disposable? = nil
    
    @IBOutlet weak var view_float: UIView!
    @IBOutlet weak var label_result: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.bringSubviewToFront(view_float)
        
        view_float.jk.addActionClosure { [weak self]  _, _, _ in
            guard let self = self else { return }
            if (self.timerDisposable != nil){
                self.label_result.text = "手动停止了"
                self.timerDisposable?.dispose()
                self.timerDisposable = nil
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - 列表数据
    override func setListData() -> Void {
        listDataInsert(keyWork: "观察者（Observer）",
                       content: "func_testObserver")
        listDataInsert(keyWork: "观察者（Observer 销毁）",
                       content: "func_testObserverDispose")
    }

}

extension showObserverVC{
    // MARK: - 1 观察者 - 简单使用
    @objc func func_testObserver() -> Void {
        
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(10)
        
        observable.map { count in
            "当前索引\(count)"
        }.bind { [weak self] result in
            guard let self = self else { return }
//            LKPrint(result)
            self.label_result.text = result
        }.disposed(by: disposeBag)
        
    }
    
    // MARK: - 2 观察者 - 销毁
    /*
     代码中使用DispatchSource.makeTimerSource创建的Timer,足以说明RxSwift的Timer使用的是GCD的Timer
     */
    @objc func func_testObserverDispose() -> Void {
        
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(10)
        
        timerDisposable = observable.map { count in
            "当前索引\(count+1)"
        }.bind { [weak self] result in
            guard let self = self else { return }
            LKPrint(result)
            self.label_result.text = result
        }
        
    }
}
