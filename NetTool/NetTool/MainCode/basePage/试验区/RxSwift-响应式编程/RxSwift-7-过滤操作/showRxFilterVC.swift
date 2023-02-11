//
//  showRxFilterVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/6.
//

import UIKit
import RxCocoa
import RxSwift

class showRxFilterVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBtonBaseNext()

        // Do any additional setup after loading the view.
    }
    
    override func registBaseAlertCActions(withAlertC alertC: UIAlertController) {
        alertC.addAction("过滤操作符（Filter）", .default) {
            self.func_testMapFilter()
        }
        
        alertC.addAction("过滤操作符（DistinctUntilChanged）", .default) {
            self.func_testMapDistinctUntilChanged()
        }
        
        alertC.addAction("过滤操作符（ElementAt）", .default) {
            self.func_testMapElementAt()
        }
        
    }

}

// MARK: - 过滤操作指的是从源 Observable 中选择特定的数据发送。

extension showRxFilterVC{
    
    /*
     过滤操作符（Filter）
     该操作符就是用来过滤掉某些不符合要求的事件。
     */
    func func_testMapFilter() -> Void {
        
        let disposeBag = DisposeBag()
         
        Observable.of(2, 30, 22, 5, 60, 3, 40 ,9)
            .filter {
                $0 > 10
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    
    
    /*
     过滤操作符（distinctUntilChanged）
     - 该操作符用于过滤掉连续重复的事件。
     */
    func func_testMapDistinctUntilChanged() -> Void {
        
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 1, 1, 4)
            .distinctUntilChanged()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    /*
     过滤操作符（elementAt）
     - 该方法实现只处理在指定位置的事件。
     */
    func func_testMapElementAt() -> Void {
        let disposeBag = DisposeBag()
         
        Observable.of(1, 2, 3, 4)
            .element(at: 2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    /*
     过滤操作符（IgnoreElements）
     - 该操作符可以忽略掉所有的元素，只发出 error 或 completed 事件。
     如果我们并不关心 Observable 的任何元素，只想知道 Observable 在什么时候终止，那就可以使用 ignoreElements 操作符。
     */
    func func_testMapIgnoreElements() -> Void {
        
        let disposeBag = DisposeBag()
         
        Observable.of(1, 2, 3, 4)
            .ignoreElements()
            .subscribe{
                print($0)
            }
            .disposed(by: disposeBag)
    }
    
    /*
     过滤操作符（take）
     - 该方法实现仅发送 Observable 序列中的前 n 个事件，在满足数量之后会自动 .completed。
     */
    func func_testMapTake() -> Void {
        let disposeBag = DisposeBag()
         
        Observable.of(1, 2, 3, 4)
            .take(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    /*
     过滤操作符（takeLast）
     - 该方法实现仅发送 Observable 序列中的最后 n 个事件，在满足数量之后会自动 .completed。
     */
    func func_testMapTakeLast() -> Void {
        let disposeBag = DisposeBag()
         
        Observable.of(1, 2, 3, 4)
            .takeLast(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    /*
     过滤操作符（Skip）
     - 该方法用于跳过源 Observable 序列发出的前 n 个事件。
     */
    func func_testMapSkip() -> Void {
        let disposeBag = DisposeBag()
         
        Observable.of(1, 2, 3, 4)
            .skip(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    /*
     过滤操作符（Sample）
     - Sample 除了订阅源 Observable 外，还可以监视另外一个 Observable， 即 notifier 。
     - 每当收到 notifier 事件，就会从源序列取一个最新的事件并发送。而如果两次 notifier 事件之间没有源序列的事件，则不发送值。
     */
    func func_testMapSample() -> Void {
        
        let disposeBag = DisposeBag()
         
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
         
        source
            .sample(notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        source.onNext(1)
         
        //让源序列接收接收消息
        notifier.onNext("A")
         
        source.onNext(2)
         
        //让源序列接收接收消息
        notifier.onNext("B")
        notifier.onNext("C")
         
        source.onNext(3)
        source.onNext(4)
         
        //让源序列接收接收消息
        notifier.onNext("D")
         
        source.onNext(5)
         
        //让源序列接收接收消息
        notifier.onCompleted()
    }
    
    
    /*
     过滤操作符（Debounce）
     - debounce 操作符可以用来过滤掉高频产生的元素，它只会发出这种元素：该元素产生后，一段时间内没有新元素产生。
     - 换句话说就是，队列中的元素如果和下一个元素的间隔小于了指定的时间间隔，那么这个元素将被过滤掉。
     - debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件。
     */
    func func_testMapDebounce() -> Void {
        
    }
}
