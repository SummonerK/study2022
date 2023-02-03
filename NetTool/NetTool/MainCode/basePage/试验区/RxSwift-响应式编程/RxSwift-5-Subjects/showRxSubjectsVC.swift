//
//  showRxSubjectsVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/3.
//

import UIKit
import RxSwift
import RxCocoa

class showRxSubjectsVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBtonBaseNext()

        // Do any additional setup after loading the view.
    }
    
    override func registBaseAlertCActions(withAlertC alertC: UIAlertController) {
        alertC.addAction("PublishSubject🚀", .default) {
            self.func_testPublishSubject()
        }
        
        alertC.addAction("BehaviorSubject🚀", .default) {
            self.func_testBehaviorSubject()
        }
        
        alertC.addAction("ReplaySubject🚀", .default) {
            self.func_testReplaySubject()
        }
        
        alertC.addAction("BehaviorReplay-accept", .default) {
            self.func_testBehaviorReplay()
        }
        
        alertC.addAction("BehaviorReplay-accept-value", .default) {
            self.func_testBehaviorReplayValue()
        }
        
    }

}

extension showRxSubjectsVC{
    
    // MARK: - PublishSubject
    /*
     基本介绍
     PublishSubject 是最普通的 Subject，它不需要初始值就能创建。
     PublishSubject 的订阅者从他们开始订阅的时间点起，可以收到订阅后 Subject 发出的新 Event，而不会收到他们在订阅前已发出的 Event。
     */
    
    func func_testPublishSubject() -> Void {
        let disposeBag = DisposeBag()
        
        //创建一个PublishSubject
        let subject = PublishSubject<String>()
        
        //由于当前没有任何订阅者，所以这条信息不会输出到控制台
        subject.onNext("111")
        
        //第1次订阅subject
        subject.subscribe(onNext: { value in
            LKPrint("第1次订阅"+value)
        },onCompleted: {
            LKPrint("第1次订阅"+"onCompleted")
        },onDisposed: {
            LKPrint("第1次订阅"+"onDisposed")
        }).disposed(by: disposeBag)
        
        //当前有1个订阅，则该信息会输出到控制台
        subject.onNext("222")
        
        //第2次订阅subject
        subject.subscribe(onNext: { value in
            LKPrint("第2次订阅"+value)
        },onCompleted: {
            LKPrint("第2次订阅"+"onCompleted")
        },onDisposed: {
            LKPrint("第2次订阅"+"onDisposed")
        }).disposed(by: disposeBag)
        
        //当前有2个订阅，则该信息会输出到控制台
        subject.onNext("333")
         
        //让subject结束
        subject.onCompleted()
         
        //subject完成后会发出.next事件了。
        subject.onNext("444")
         
        //subject完成后它的所有订阅（包括结束后的订阅），都能收到subject的.completed事件，
        subject.subscribe(onNext: { string in
            print("第3次订阅：", string)
        }, onCompleted:{
            print("第3次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
    }
    
    /*
     BehaviorSubject
     （1）基本介绍
     BehaviorSubject 需要通过一个默认初始值来创建。
     当一个订阅者来订阅它的时候，这个订阅者会立即收到 BehaviorSubjects 上一个发出的 event。之后就跟正常的情况一样，它也会接收到 BehaviorSubject 之后发出的新的 event。
     */
    
    func func_testBehaviorSubject() -> Void {
        let disposeBag = DisposeBag()
        let subject = BehaviorSubject<String>.init(value: "111")
        
        subject.subscribe(onNext: { value in
            LKPrint("第1次订阅"+value)
        },onCompleted: {
            LKPrint("第1次订阅"+"onCompleted")
        },onDisposed: {
            LKPrint("第1次订阅"+"onDisposed")
        }).disposed(by: disposeBag)
        
        subject.onNext("2222")
        
        subject.subscribe(onNext: { value in
            LKPrint("第2次订阅"+value)
        },onCompleted: {
            LKPrint("第2次订阅"+"onCompleted")
        },onDisposed: {
            LKPrint("第2次订阅"+"onDisposed")
        }).disposed(by: disposeBag)
        
        subject.onCompleted()
        
        subject.onNext("3333")
        subject.subscribe(onNext: { string in
            LKPrint("第3次订阅："+string)
        }, onCompleted:{
            LKPrint("第3次订阅：onCompleted")
        }).disposed(by: disposeBag)
    }
    
    /*
     ReplaySubject
     （1）基本介绍
     ReplaySubject 在创建时候需要设置一个 bufferSize，表示它对于它发送过的 event 的缓存个数。
     比如一个 ReplaySubject 的 bufferSize 设置为 2，它发出了 3 个 .next 的 event，那么它会将后两个（最近的两个）event 给缓存起来。此时如果有一个 subscriber 订阅了这个 ReplaySubject，那么这个 subscriber 就会立即收到前面缓存的两个 .next 的 event。
     如果一个 subscriber 订阅已经结束的 ReplaySubject，除了会收到缓存的 .next 的 event 外，还会收到那个终结的 .error 或者 .complete 的 event。
     */
    
    func func_testReplaySubject() -> Void {
        
        let disposeBag = DisposeBag()
        
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        subject.subscribe(onNext: { value in
            LKPrint("第1次订阅"+value)
        },onCompleted: {
            LKPrint("第1次订阅"+"onCompleted")
        },onDisposed: {
            LKPrint("第1次订阅"+"onDisposed")
        }).disposed(by: disposeBag)
        
        subject.onNext("444")
        
        subject.subscribe(onNext: { value in
            LKPrint("第2次订阅"+value)
        },onCompleted: {
            LKPrint("第2次订阅"+"onCompleted")
        },onDisposed: {
            LKPrint("第2次订阅"+"onDisposed")
        }).disposed(by: disposeBag)
        
        //让subject结束
        subject.onCompleted()
         
        //第3次订阅subject
        subject.subscribe { event in
            LKPrint("第3次订阅："+event)
        }.disposed(by: disposeBag)
        
        
    }
    
    func func_testVariable() -> Void {
        let disposeBag = DisposeBag()
        /*
         Variable 已废弃
         */
        
        
    }
    
    /*
     BehaviorRelay
     （1）基本介绍
     BehaviorRelay 是作为 Variable 的替代者出现的。它的本质其实也是对 BehaviorSubject 的封装，所以它也必须要通过一个默认的初始值进行创建。
     BehaviorRelay 具有 BehaviorSubject 的功能，能够向它的订阅者发出上一个 event 以及之后新创建的 event。
     与 BehaviorSubject 不同的是，不需要也不能手动给 BehaviorReply 发送 completed 或者 error 事件来结束它（BehaviorRelay 会在销毁时也不会自动发送 .complete 的 event）。
     BehaviorRelay 有一个 value 属性，我们通过这个属性可以获取最新值。而通过它的 accept() 方法可以对值进行修改。
     */
    
    func func_testBehaviorReplay() -> Void {
        let disposeBag = DisposeBag()
        
        let subject = BehaviorRelay<String>.init(value: "1111")
//        let subject1 = BehaviorRelay<String>(value: "22222")
        
        subject.accept("222")
        
        subject.subscribe(onNext: { value in
            LKPrint("第1次订阅"+value)
        },onCompleted: {
            LKPrint("第1次订阅"+"onCompleted")
        },onDisposed: {
            LKPrint("第1次订阅"+"onDisposed")
        }).disposed(by: disposeBag)
        
        subject.accept("333")
        
        subject.subscribe(onNext: { value in
            LKPrint("第2次订阅"+value)
        },onCompleted: {
            LKPrint("第2次订阅"+"onCompleted")
        },onDisposed: {
            LKPrint("第2次订阅"+"onDisposed")
        }).disposed(by: disposeBag)
        
        subject.accept("444")
        
    }
    func func_testBehaviorReplayValue() -> Void {
        let disposeBag = DisposeBag()
        
        let subject = BehaviorRelay<[String]>.init(value: ["1"])
//        let subject1 = BehaviorRelay<String>(value: "22222")
        
        subject.accept(subject.value + ["2"])
        
        subject.subscribe(onNext: { value in
            LKPrint("第1次订阅\(value)")
        },onCompleted: {
            LKPrint("第1次订阅"+"onCompleted")
        },onDisposed: {
            LKPrint("第1次订阅"+"onDisposed")
        }).disposed(by: disposeBag)
        
        subject.accept(subject.value + ["3"])
        
        subject.subscribe(onNext: { value in
            LKPrint("第2次订阅\(value)")
        },onCompleted: {
            LKPrint("第2次订阅"+"onCompleted")
        },onDisposed: {
            LKPrint("第2次订阅"+"onDisposed")
        }).disposed(by: disposeBag)
        
        subject.accept(subject.value + ["4"])
        
    }
    
}


/*
 1，Subjects 基本介绍
 （1）Subjects 既是订阅者，也是 Observable：
 说它是订阅者，是因为它能够动态地接收新的值。
 说它又是一个 Observable，是因为当 Subjects 有了新的值之后，就会通过 Event 将新值发出给他的所有订阅者。

 （2）一共有四种 Subjects，分别为：PublishSubject、BehaviorSubject、ReplaySubject、Variable。他们之间既有各自的特点，也有相同之处：
 首先他们都是 Observable，他们的订阅者都能收到他们发出的新的 Event。
 直到 Subject 发出 .complete 或者 .error 的 Event 后，该 Subject 便终结了，同时它也就不会再发出 .next 事件。
 对于那些在 Subject 终结后再订阅他的订阅者，也能收到 subject 发出的一条 .complete 或 .error 的 event，告诉这个新的订阅者它已经终结了。
 他们之间最大的区别只是在于：当一个新的订阅者刚订阅它的时候，能不能收到 Subject 以前发出过的旧 Event，如果能的话又能收到多少个。

 （3）Subject 常用的几个方法：
 onNext(:)：是 on(.next(:)) 的简便写法。该方法相当于 subject 接收到一个 .next 事件。
 onError(:)：是 on(.error(:)) 的简便写法。该方法相当于 subject 接收到一个 .error 事件。
 onCompleted()：是 on(.completed) 的简便写法。该方法相当于 subject 接收到一个 .completed 事件。
 
 */
