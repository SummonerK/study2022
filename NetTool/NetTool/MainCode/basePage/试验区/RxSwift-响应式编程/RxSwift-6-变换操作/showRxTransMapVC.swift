//
//  showRxTransMapVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/6.
//

import UIKit
import RxSwift
import RxCocoa

class showRxTransMapVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBtonBaseNext()
        
    }
    
    override func registBaseAlertCActions(withAlertC alertC: UIAlertController) {
        alertC.addAction("变换操作符（buffer）", .default) {
            self.func_testTransBuffer()
        }
        
        alertC.addAction("变换操作符（window）", .default) {
            self.func_testTransWindow()
        }
        
        alertC.addAction("变换操作符（map）", .default) {
            self.func_testTransMap()
        }
        
        alertC.addAction("变换操作符（flatMap）", .default) {
            self.func_testTransFlatMap()
        }
        
        alertC.addAction("变换操作符（ConcatMap）", .default) {
            self.func_testTransConcatMap()
        }
        
        alertC.addAction("变换操作符（scan）", .default) {
            self.func_testTransScan()
        }
        
        alertC.addAction("变换操作符（groupBy）", .default) {
            self.func_testTransGroupBy()
        }
        
    }

}

extension showRxTransMapVC{
    
    /*
     buffer 方法作用是缓冲组合，第一个参数是缓冲时间，第二个参数是缓冲个数，第三个参数是线程。
     该方法简单来说就是缓存 Observable 中发出的新元素，
     当元素达到某个数量，或者经过了特定的时间，它就会将这个元素集合发送出来。
     */
    
    func func_testTransBuffer() -> Void {
        
        let disposeBag = DisposeBag()
        
        let subject = PublishSubject<String>()
        
        //每缓存3个元素则组合起来一起发出。
        //如果1秒钟内不够3个也会发出（有几个发几个，一个都没有发空数组 []）
        subject.buffer(timeSpan: RxTimeInterval.seconds(1), count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: {element in
                LKPrint(element)
        },onCompleted: {
            LKPrint("onCompleted")
        },onDisposed: {
            LKPrint("onDisposed")
        }).disposed(by: disposeBag)
        
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        subject.onNext("A")
        subject.onNext("B")
        subject.onNext("C")
        
        subject.onCompleted()
        
    }
    
    func func_testTransWindow() -> Void {
        
        let disposeBag = DisposeBag()
        
        let subject = PublishSubject<String>()
        
        //每3个元素作为一个子Observable发出。
        subject.window(timeSpan: RxTimeInterval.seconds(1), count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] element in
                LKPrint(element)
                element.asObservable().subscribe(onNext: {
                    LKPrint($0)
                }).disposed(by: disposeBag)
        },onCompleted: {
            LKPrint("onCompleted")
        },onDisposed: {
            LKPrint("onDisposed")
        })
        
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        subject.onNext("A")
        subject.onNext("B")
        subject.onNext("C")
        
        subject.onCompleted()
        
    }
    
    /*
     该操作符通过传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列。
     */
    func func_testTransMap() -> Void {
        let disposeBag = DisposeBag()
        
        let obserable = Observable<Int>.of(1,2,3)
        
        obserable.map { element in
           return element * 10
        }.subscribe(onNext: {element in
            LKPrint(element)
        }).disposed(by: disposeBag)
        
    }
    
    /*
     map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列。
     而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
     这个操作符是非常有用的。比如当 Observable 的元素本生拥有其他的 Observable 时，我们可以将所有子 Observables 的元素发送出来。
     */
    
    /*
     flatMapLatest 与 flatMap 的唯一区别是：flatMapLatest 只会接收最新的 value 事件。
     */
    
    /*
     flatMapFirst 与 flatMapLatest 正好相反：flatMapFirst 只会接收最初的 value 事件。
     */
    
    func func_testTransFlatMap() -> Void {
        let disposeBag = DisposeBag()
         
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
         
        let variable = BehaviorRelay(value: subject1)
         
//        variable.asObservable()
//            .flatMap { $0 }
//            .subscribe(onNext: { print($0) })
//            .disposed(by: disposeBag)
        
//        variable.asObservable()
//            .flatMapLatest { $0 }
//            .subscribe(onNext: { print($0) })
//            .disposed(by: disposeBag)
        
        variable.asObservable()
            .flatMapFirst { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext("B")
        variable.accept(subject2)
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    /*
     concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。
     */
    
    func func_testTransConcatMap() -> Void {
        let disposeBag = DisposeBag()
         
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
         
        let variable = BehaviorRelay(value: subject1)
        
        variable.asObservable()
            .concatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext("B")
        variable.accept(subject2)
        subject2.onNext("2")
        subject1.onNext("C")
        subject1.onCompleted()
    }
    
    /*
     scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作。
     */
    func func_testTransScan() -> Void {
        let disposeBag = DisposeBag()
         
        Observable.of(1, 2, 3, 4, 5)
            .scan(0) { acum, elem in
                acum + elem
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    /*
     groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来。
     也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来。
     */
    func func_testTransGroupBy() -> Void {
        
        let disposeBag = DisposeBag()
         
        //将奇数偶数分成两组
        Observable<Int>.of(0, 1, 2, 3, 4, 5)
            .groupBy(keySelector: { (element) -> String in
                return element % 2 == 0 ? "偶数" : "基数"
            })
            .subscribe { (event) in
                switch event {
                case .next(let group):
                    group.asObservable().subscribe(onNext: { (event) in
                        print("key：\(group.key)    event：\(event)")
                    })
                    .disposed(by: disposeBag)
                default:
                    print("")
                }
            }
        .disposed(by: disposeBag)
        
    }
    
    
}
