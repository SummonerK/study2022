//
//  showRxBaseSubscribeVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/1.
//

import UIKit
import RxSwift

//    有了 Observable，我们还要使用 subscribe() 方法来订阅它，接收它发出的 Event。

class showRxBaseSubscribeVC: BaseFuncListVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - 列表数据
    override func setListData() -> Void {
        listDataInsert(keyWork: "订阅 Observable",
                       content: "func_textObservable")
        listDataInsert(keyWork: "订阅 Observable-block",
                       content: "func_textObservableWithBlock")
        listDataInsert(keyWork: "订阅 Observable-life",
                       content: "func_textObservableWithLife")
        listDataInsert(keyWork: "订阅 Observable-dispose",
                       content: "func_textObservableDispose")
        listDataInsert(keyWork: "订阅 Observable-disposebag",
                       content: "func_textObservableDisposeBag")
    }

}

extension showRxBaseSubscribeVC{
    
    // MARK: - 1 订阅简单使用
    @objc func func_textObservable() -> Void {
        //使用 subscribe() 订阅了一个 Observable 对象，
        //该方法的 block 的回调参数就是被发出的 event 事件，我们将其直接打印出来。
        /*
         （1）一个 Observable 序列被创建出来后它不会马上就开始被激活从而发出 Event，而是要等到它被某个人订阅了才会激活它。
         （2）而 Observable 序列激活之后要一直等到它发出了 .error 或者 .completed 的 event 后，它才被终结。
         */
        let observable = Observable<String>.of("A","B","C")
        
        observable.subscribe { event in
            LKPrint(event)
        }
        
        observable.subscribe { event in
            LKPrint(event.element ?? "")
        }
    }
    
    // MARK: - 2 订阅，通过不同的 block 回调处理不同类型的 event。
    @objc func func_textObservableWithBlock() -> Void {
        let observable = Observable<String>.of("A","B","C")
        
        observable.subscribe(onNext:{ element in
            LKPrint(element)
        },onError: {_ in
            LKPrint("error")
        },onCompleted: {
            LKPrint("completed")
        },onDisposed: {
            LKPrint("disposed")
        })
        
    }
    
    // MARK: - 3 订阅-监听生命周期
    /*
    （1）我们可以使用 doOn 方法来监听事件的生命周期，它会在每一次事件发送前被调用。
    （2）同时它和 subscribe 一样，可以通过不同的 block 回调处理不同类型的 event。比如：
    do(onNext:) 方法就是在 subscribe(onNext:) 前调用
    而 do(onCompleted:) 方法则会在 subscribe(onCompleted:) 前面调用。
     */
    @objc func func_textObservableWithLife() -> Void {
        
        let observable = Observable<String>.of("A","B")
        
        observable
            .do(onNext:{ element in
                LKPrint(element)
            },onError: {_ in
                LKPrint("error")
            },onCompleted: {
                LKPrint("completed")
            },onDispose: {
                LKPrint("onDispose")
            })
            .subscribe(onNext:{element in
                LKPrint(element)
            },onError: {_ in
                LKPrint("error")
            },onCompleted: {
                LKPrint("completed")
            },onDisposed: {
                LKPrint("disposed")
            })
        
    }
    
    // MARK: - 4 订阅取消订阅
    @objc func func_textObservableDispose() -> Void {
        let observable = Observable<String>.of("A","B","C")
        
        let subscription = observable.subscribe(onNext:{ element in
            LKPrint(element)
        })
        
        //调用这个订阅的dispose()方法
        subscription.dispose()
    }
    
    // MARK: - 5 订阅取消订阅- DisposeBag
    @objc func func_textObservableDisposeBag() -> Void {
        let disposeBag = DisposeBag()
        let observable = Observable<String>.of("A","B","C")
        
        observable.subscribe(onNext:{ element in
            LKPrint(element)
        },onError: {_ in
            LKPrint("error")
        },onCompleted: {
            LKPrint("completed")
        },onDisposed: {
            LKPrint("disposed")
        }).disposed(by: disposeBag)
    }
}
