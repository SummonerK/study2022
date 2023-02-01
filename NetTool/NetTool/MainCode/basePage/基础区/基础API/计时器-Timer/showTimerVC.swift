//
//  showTimerVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/1.
//

import UIKit
import RxSwift

class showTimerVC: BaseFuncListVC {
    
    var timer: Timer!
    var gcdTimer: DispatchSourceTimer!
    var cadTimer: CADisplayLink!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    // MARK: - 列表数据
    override func setListData() -> Void {
        listDataInsert(keyWork: "Timer（normal）",
                       content: "func_Timer_normal")
        listDataInsert(keyWork: "Timer（GCD）",
                       content: "func_Timer_GCD")
        listDataInsert(keyWork: "Timer（CADisplayLink）",
                       content: "func_Timer_CADisplayLink")
        listDataInsert(keyWork: "Timer（RxSwift）",
                       content: "func_Timer_RxSwift")
    }

}

extension showTimerVC{
    
    @objc func timerFire(){
        LKPrint("")
    }
    
    // MARK: - 1 Timer - 简单使用
    @objc func func_Timer_normal() -> Void {
        timer = Timer.init(timeInterval: 1, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .default)
    }
    
    // MARK: - 2 Timer - GCD
    @objc func func_Timer_GCD() -> Void {
        gcdTimer = DispatchSource.makeTimerSource()
        gcdTimer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1))
        gcdTimer?.setEventHandler(handler: {
            print("hello GCD")
        })
        gcdTimer?.resume()
    }
    
    // MARK: - 3 Timer - CADisplayLink
    @objc func func_Timer_CADisplayLink() -> Void {
        cadTimer = CADisplayLink(target: self, selector: #selector(timerFire))
        cadTimer?.preferredFramesPerSecond = 1
        cadTimer?.add(to: RunLoop.current, forMode: .default)
        cadTimer?.isPaused = true
    }
    
    // MARK: - 4 Timer - RxSwift
    @objc func func_Timer_RxSwift() -> Void {
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(5)
        
        observable.subscribe(onNext:{ element in
            LKPrint(element)
        },onCompleted: {
            LKPrint("completed")
        },onDisposed: {
            LKPrint("disposed")
        })
    }
    
}
