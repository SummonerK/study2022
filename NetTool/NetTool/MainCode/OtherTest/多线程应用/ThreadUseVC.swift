//
//  ThreadUseVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/11.
//

import UIKit

class ThreadUseVC: BaseFuncListVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setListData() {
        listDataInsert(keyWork: "测试线程是否阻塞",
                               content: "testThread")
        listDataInsert(keyWork: "[abc-abc-abc-end]",
                               content: "func_perform_listSource")
        listDataInsert(keyWork: "[100 task progress]",
                               content: "func_perform_list100Source")
    }
    
    @objc func testThread() -> Void {
        MBHud.showInfoWithMessage("正常")
    }

    func tranProgress(value:CGFloat) -> Void {
        let toastStr = String(format: "数据已发送%@", value.progressTrans())
        LKPrint(toastStr)
    }
}


extension ThreadUseVC{
    // MARK: - [abc-abc-abc-end]
    @objc func func_perform_listSource(){
        LKPrint("调用了方法")
        let queue = getSerial(label: "queue_performQueuesUseASynchronization_devicePrint")
        let semaphoreLock = DispatchSemaphore(value: 0)
        let array = ["a","b","c"]
        
        for i in 0..<3{
            queue.async { [weak self] in
                guard let self = self else { return }
                self.funcListSourceItem(with: array) { success in
                    if success{
                        LKPrint("完成--第\(i+1)份-✅")
                        semaphoreLock.signal() ///开锁 🔓
                    }
                }
//                DispatchQueue.jk.asyncDelay(1) {
//                    LKPrint("完成--第\(i+1)份-✅")
//                    semaphoreLock.signal() ///开锁 🔓
//                }
                semaphoreLock.wait() ///上锁🔒
            }
        }
        
//        queue.sync {
//            // MARK: - 在信号量释放前，阻塞线程。
//            LKPrint("完成了全部 🚩")
//        }
        
        queue.async {
            // MARK: - 在信号量释放前，阻塞线程。
            LKPrint("完成了全部 🚩")
        }
    }
    
    func funcListSourceItem(with array:[String],completion:@escaping (_ success:Bool)->Void){
        let queue = getSerial(label: "queue_devicePrint_pic")
        let semaphoreLock = DispatchSemaphore(value: 0)
        
        for i in 0..<array.count{
            queue.async {
                DispatchQueue.jk.asyncDelay(1) {
                    LKPrint("执行任务---\(array[i])")
                    semaphoreLock.signal() ///开锁 🔓
                }
                semaphoreLock.wait() ///加锁 🔓
            }
        }
        
        queue.async {
            LKPrint("完成-✅")
            completion(true)
        }
    }
    
    // MARK: - 顺序100份执行完成
    @objc func func_perform_list100Source(){
        let queue = getSerial(label: "queue_performQueuesUseASynchronization_devicePrint")
        let semaphoreLock = DispatchSemaphore(value: 0)
        
        for i in 0..<100{
            queue.async { [weak self] in
                guard let self = self else { return }
                DispatchQueue.jk.asyncDelay(0.01) {
                    let progress:CGFloat = CGFloat(i+1)/100
                    self.tranProgress(value: progress)
                    semaphoreLock.signal() ///开锁 🔓
                }
                semaphoreLock.wait() ///上锁🔒
            }
        }
        
        queue.async {
            // MARK: - 在信号量释放前，阻塞线程。
            LKPrint("完成了全部 🚩")
        }
        
    }
}
