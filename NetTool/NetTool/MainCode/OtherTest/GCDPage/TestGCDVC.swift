//
//  TestGCDVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/10/22.
//

import UIKit
import RxSwift
import RxCocoa

class TestGCDVC: BaseVC {
    @IBOutlet weak var tableV_main:UITableView!
    var viewModel:GCDListModel = GCDListModel()
    var arrayData:Array<GCDModel> = []
    
    let bag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let obbgColor = Observable.just(UIColor.hexStringColor(hexString: "f1f1f1"))
        obbgColor.bind(to:self.view.rx.backgroundColor).disposed(by: bag)
        initTableView()
        registData()
        setLsitData()
        
        // Do any additional setup after loading the view.
    }
    func initTableView() -> Void {
        tableV_main.register(TCellNormal.self, forCellReuseIdentifier: "TCellNormal")
        tableV_main.backgroundColor = UIColor(hexString: "f3e1f1")
        tableV_main.bounces = false
        if #available(iOS 15.0, *) {
            tableV_main.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableV_main.rx.setDelegate(self).disposed(by: bag)
        
        // 监听cell的点击，获取那一行对应的data
        tableV_main.rx.modelSelected(GCDModel.self).subscribe(onNext: {[weak self] data in
//            print("点击了cell，对应的data为：\(data.keyWord)")
            self?.callMethod(withName: data.content)
        }).disposed(by: bag)
    }
    
    func registData() -> Void {
        viewModel.dataPub.subscribe{[weak self] (list:Array<GCDModel>) in
            self?.arrayData = list
        }.disposed(by: bag)
        
        viewModel.dataPub.bind(to: self.tableV_main.rx.items) { tableView, indexPathRow, data in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellNormal")
            cell?.selectionStyle = .none
            cell?.textLabel?.text = data.keyWord
            return cell!
        }.disposed(by: bag)
    }
    
    // MARK: - 定义数据
    func setLsitData() -> Void {
        listDataInsert(keyWork: "同步执行串行队列",
                       content: "func_performQueuesUseSynchronization_serial")
        listDataInsert(keyWork: "同步执行并行方法",
                       content: "func_performQueuesUseSynchronization_concurrent")
        listDataInsert(keyWork: "异步执行串行方法",
                       content: "func_performQueuesUseASynchronization_serial")
        listDataInsert(keyWork: "异步执行并行方法",
                       content: "func_performQueuesUseASynchronization_concurrent")
        listDataInsert(keyWork: "延时执行",
                       content: "func_performQueuesDefer")
        listDataInsert(keyWork: "优先级",
                       content: "func_performQueuesQos")
        listDataInsert(keyWork: "任务组-group",
                       content: "func_performQueuesGroup")
        listDataInsert(keyWork: "队列的循环、挂起、恢复【有些方法没了】",
                       content: "func_performQueuesApply")
        listDataInsert(keyWork: "任务栅栏",
                       content: "func_performQueuesBarrier")
        listDataInsert(keyWork: "锁的使用-NSLock-对象锁",
                       content: "func_performQueuesNSLock")
        listDataInsert(keyWork: "锁的使用-NSRecursiveLock-递归锁",
                       content: "func_performNSRecursiveLock")
        listDataInsert(keyWork: "锁的使用-NSConditionLock-互斥锁/条件锁",
                       content: "func_performNSConditionLock")
        listDataInsert(keyWork: "锁的使用-NSCondition-条件锁",
                       content: "func_performNSCondition")
        listDataInsert(keyWork: "锁的使用-关键字加锁-互斥锁",
                       content: "func_performSynchronized")
        
        listDataInsert(keyWork: "NSOperation-创建队列/添加操作",
                       content: "func_performNSOperation")
        listDataInsert(keyWork: "NSOperation-操作添加依赖",
                       content: "func_performNSOperation2")
        listDataInsert(keyWork: "NSOperation-操作监听/线程通信",
                       content: "func_performNSOperation3")
        
        
        listDataInsert(keyWork: "任务组_enter_leave_wait",
                       content: "func_performQueuesGroupDef")
        listDataInsert(keyWork: "信号量和同步锁🔒",
                       content: "func_performQueuesSemaphore")
        listDataInsert(keyWork: "信号量和同步锁🔒-group",
                       content: "func_performQueuesSemaphoreControl")
        
        
        listDataInsert(keyWork: "信号量和同步锁🔒:c wait ab",
                       content: "func_performQueuesCWaitab")
        listDataInsert(keyWork: "信号量和同步锁🔒:c wait ab 1",
                       content: "func_performQueuesCWaitab1")
        listDataInsert(keyWork: "任务组_enter_leave_wait:c wait ab 1",
                       content: "func_performQueuesCWaitab2")
        listDataInsert(keyWork: "任务组_Semaphore:c wait ab 1",
                       content: "func_performQueuesCWaitab3")
        listDataInsert(keyWork: "任务组_Semaphore2:c wait ab 1",
                       content: "func_performQueuesCWaitab4")
    }
    
    func listDataInsert(keyWork title: String,content selector: String) -> Void {
        viewModel.insertItem(withData: GCDModel(keyWord: title,content: selector))
    }
    
    func callMethod(withName selectorString:String) -> Void {
        let aselector = Selector(selectorString)
//        print(aselector)
        if responds(to: aselector){
            perform(aselector)
        }else{
            assert(false,"该方法不存在,检查确认后调用")
        }
    }
}

extension TestGCDVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

struct GCDModel {
    var keyWord:String = ""
    var content:String = ""
}

class GCDListModel{
    
    private var arrayData:Array<GCDModel> = []
    var dataPub:PublishSubject = PublishSubject<Array<GCDModel>>()
    
    func insertItem(withData item:GCDModel) -> Void {
        arrayData.append(item)
        dataPub.onNext(arrayData)
    }
    
}

extension TestGCDVC{
    // MARK: - 同步执行串行队列
    @objc func func_performQueuesUseSynchronization_serial(){
        //同步执行:FIFO
        //串行:a-b-c,顺序执行
        print("同步执行串行方法")
        let queue = getSerial(label: "queue_performQueuesUseSynchronization_serial_00")
        performQueuesUseSynchronization(queue: queue)
    }
    // MARK: - 同步执行并行方法
    @objc func func_performQueuesUseSynchronization_concurrent(){
        //同步执行:FIFO
        //并行:a｜b｜c,乱序执行
        print("同步执行并行方法")
        let queue = getConcurrent(label: "queue_performQueuesUseSynchronization_concurrent_00")
        performQueuesUseSynchronization(queue: queue)
    }
    
    // MARK: - 异步执行串行队列
    @objc func func_performQueuesUseASynchronization_serial(){
        print("异步执行串行方法")
        let queue = getSerial(label: "queue_performQueuesUseASynchronization_serial_00")
        performQueuesUseASynchronization(queue: queue)
    }
    // MARK: - 异步执行并行方法
    @objc func func_performQueuesUseASynchronization_concurrent(){
        print("异步执行并行方法")
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        performQueuesUseASynchronization(queue: queue)
    }
    
    // MARK: - 延时执行
    @objc func func_performQueuesDefer(){
        print("调用了延时方法")
        performQueueDefer(seconds: 2)
    }
    
    // MARK: - 线程优先级
    @objc func func_performQueuesQos(){
        let queue_userInteractive = getGlobalQueue(qos: .userInteractive)
        let queue_userInitiated = getGlobalQueue(qos: .userInitiated)
        let queue_default = getGlobalQueue(qos: .default)
        let queue_utility = getGlobalQueue(qos: .utility)
        let queue_background = getGlobalQueue(qos: .background)
        
        
        queue_background.async {
            print("background__1__\(getCurrentThread())")
            currentThreadSleep(seconds: 1)
            print("\(getCurrentThread())--\ntask:5__background执行完成✅")
        }
        
        queue_utility.async {
            print("utility__2__\(getCurrentThread())")
            currentThreadSleep(seconds: 1)
            print("\(getCurrentThread())--\ntask:4__utility执行完成✅")
        }
        
        queue_default.async {
            print("default__3__\(getCurrentThread())")
            currentThreadSleep(seconds: 1)
            print("\(getCurrentThread())--\ntask:3__default执行完成✅")
        }
        
        queue_userInitiated.async {
            print("userInitiated__4__\(getCurrentThread())")
            currentThreadSleep(seconds: 1)
            print("\(getCurrentThread())--\ntask:2__userInitiated执行完成✅")
        }
        
        queue_userInteractive.async {
            print("userInteractive__5__\(getCurrentThread())")
            currentThreadSleep(seconds: 1)
            print("\(getCurrentThread())--\ntask:1__userInteractive执行完成✅")
        }
    }
    
    // MARK: - 任务组
    @objc func func_performQueuesGroup(){
        let group = DispatchGroup()
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        performQueuesUseASynchronization(queue: queue,group: group)
        print("异步执行，不会阻塞当前线程")
//        1、
//        let item = DispatchWorkItem {
//            print("【group任务】--执行完成✅")
//        }
//        group.notify(queue: queue, work: item)
//        2、
        group.notify(queue: queue) {
            print("【group任务】--执行完成✅")
        }
    }
    
    // MARK: - 任务组
    @objc func func_performQueuesGroupDef(){
        let group = DispatchGroup()
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        //enter，leave。手动关联
        performQueuesUseASynchronizationDef(queue: queue,group: group)
        
        print("阻塞")
        group.wait()///阻塞当前线程，直到所有任务执行完成✅
        print("两个接口都请求完毕")
        print("不阻塞")
        group.notify(queue: queue) {
            print("【group任务】--执行完成✅")
        }
    }
    
    // MARK: - 信号量和同步锁🔒
    @objc func func_performQueuesSemaphore(){
        ///信号量
        ///可以实现线程同步
        ///如果信号量为0那么就是上锁的状态，其他线程想使用资源就得等待了。
        ///如果信号量不为零，那么就是开锁状态，开锁状态下资源就可以访问。
        ///signal 发送信号量 信号量dsema的值加1；
        ///wait 上锁 信号量dsema的值减1；
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        let semaphoreLock = DispatchSemaphore(value: 2)
        for i in 1...9{
            let randomSecond = arc4random()%4 + 1
            queue.async{
                semaphoreLock.wait() ///上锁🔒
                var log = String()
                log += String(format: "%@", getCurrentThread())
                log += "\ntask:\(i)添加完毕---定义时长【\(randomSecond)s】"
                print(log)
                currentThreadSleep(seconds: Double(randomSecond))
                print("\(getCurrentThread())--\ntask:\(i)执行完成✅--耗时：【\(randomSecond)s】")
                semaphoreLock.signal() ///开锁 🔓
            }
        }
        
        print("异步标记🚩")
    }
    
    @objc func func_performQueuesSemaphoreControl(){
        let group = DispatchGroup()
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        let semaphoreLock = DispatchSemaphore(value: 4)
        
        for i in 1...10{
            let randomSecond = arc4random()%4 + 1
            semaphoreLock.wait() ///上锁🔒
            queue.async(group: group) {
                var log = String()
                log += String(format: "%@", getCurrentThread())
                log += "\ntask:\(i)添加完毕---定义时长【\(randomSecond)s】"
                print(log)
                currentThreadSleep(seconds: Double(randomSecond))
                print("\(getCurrentThread())--\ntask:\(i)执行完成✅--耗时：【\(randomSecond)s】")
                semaphoreLock.signal() ///开锁 🔓
            }
        }
        print("阻塞了")
        group.notify(queue: queue){
            //group执行完成了
            print("执行C任务")
            queue.async{
                print("执行c任务")
                currentThreadSleep(seconds: 2)
                print("【c任务】 执行完成✅")
            }
        }
        
    }
    
    // MARK: - 【a、b】-【c】
    @objc func func_performQueuesCWaitab(){
//        1、用信号量-ab方法中信号量定义0上锁状态和开锁释放，group(ab),notify(c)
//        2、用信号量-group定义信号0上锁，notify(c)wait(ab)开锁 ab方法中开锁释放，group(ab),notify(c)
        let group = DispatchGroup()
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        queue.async(group: group){
            print("执行a任务")
            let semaphore = DispatchSemaphore(value: 0)
            currentThreadSleep(seconds: 2)
            semaphore.signal()
            print("【a任务】 执行完成✅")
        }
        queue.async(group: group){
            print("执行b任务")
            let semaphore = DispatchSemaphore(value: 0)
            currentThreadSleep(seconds: 4)
            semaphore.signal()
            print("【b任务】 执行完成✅")
        }
        print("阻塞了")
        group.notify(queue: queue){
            //group执行完成了
//            print("执行C任务")
            queue.async{
                print("执行c任务")
                currentThreadSleep(seconds: 2)
                print("【c任务】 执行完成✅")
            }
        }
    }
    
    // MARK: - 【a、b】-【c】
    @objc func func_performQueuesCWaitab1(){
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 0)
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        queue.async(group: group){
            print("执行a任务")
            currentThreadSleep(seconds: 2)
            semaphore.signal()
            print("【a任务】 执行完成✅")
        }
        queue.async(group: group){
            print("执行b任务")
            currentThreadSleep(seconds: 4)
            semaphore.signal()
            print("【b任务】 执行完成✅")
        }
        group.notify(queue: queue){
            //wait 信号减1，阻塞
            semaphore.wait()
            semaphore.wait()
            //group执行完成了
            queue.async{
                print("执行c任务")
                currentThreadSleep(seconds: 2)
                print("【c任务】 执行完成✅")
            }
        }
    }
    
    // MARK: - 【a、b】-【c】
    @objc func func_performQueuesCWaitab2(){
        let group = DispatchGroup()
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        queue.async(group: group){
            print("执行a任务")
            group.enter()
            currentThreadSleep(seconds: 2)
            print("【a任务】 执行完成✅")
            group.leave()
        }
        queue.async(group: group){
            print("执行b任务")
            group.enter()
            currentThreadSleep(seconds: 4)
            print("【b任务】 执行完成✅")
            group.leave()
        }
//        //注意会阻塞
//        group.wait()
//        //group执行完成了
//        queue.async{
//            print("执行c任务")
//            currentThreadSleep(seconds: 2)
//            print("【c任务】 执行完成✅")
//        }
        
        group.notify(queue: queue){
            //group执行完成了
            queue.async{
                print("执行c任务")
                currentThreadSleep(seconds: 2)
                print("【c任务】 执行完成✅")
            }
        }
    }
    
    // MARK: - 【a、b】-【c】
    @objc func func_performQueuesCWaitab3(){
        let group = DispatchGroup()
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        queue.async(group: group){
            print("执行a任务")
            let semaphore = DispatchSemaphore(value: 0)
            currentThreadSleep(seconds: 2)
            print("【a任务】 执行完成✅")
            semaphore.signal()
        }
        queue.async(group: group){
            print("执行b任务")
            let semaphore = DispatchSemaphore(value: 0)
            currentThreadSleep(seconds: 4)
            print("【b任务】 执行完成✅")
            semaphore.signal()
        }
        
//        group.wait()
//        //group执行完成了
//        queue.async{
//            print("执行c任务")
//            currentThreadSleep(seconds: 2)
//            print("【c任务】 执行完成✅")
//        }
        
        group.notify(queue: queue){
            //group执行完成了
//            queue.async{
//                print("执行c任务")
//                currentThreadSleep(seconds: 2)
//                print("【c任务】 执行完成✅")
//            }
            //同步执行C
            let serialQueue = getSerial(label: "queue_serial_000")
            serialQueue.sync {
                print("执行C任务")
                currentThreadSleep(seconds: 2)
                print("【C任务】 执行完成✅")
            }
            print("同步标识--异步执行C-会阻塞当前线程，直到完成同步task")
            //再异步执行D｜E
            let concurrentQueue = getConcurrent(label: "queue_concurrent_002")
            concurrentQueue.async {
                print("执行D任务")
                currentThreadSleep(seconds: 2)
                print("【D任务】 执行完成✅")
            }
            concurrentQueue.async {
                print("执行E任务")
                currentThreadSleep(seconds: 3)
                print("【E任务】 执行完成✅")
            }
            
            print("异步标识--异步执行D｜E")
        }
    }
    
    // MARK: - 【a、b】-【c】
    @objc func func_performQueuesCWaitab4(){
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 2)
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        queue.async(group: group){
            print("执行a任务")
            semaphore.wait()
            currentThreadSleep(seconds: 2)
            print("【a任务】 执行完成✅")
            semaphore.signal()
        }
        queue.async(group: group){
            print("执行b任务")
            semaphore.wait()
            currentThreadSleep(seconds: 4)
            print("【b任务】 执行完成✅")
            semaphore.signal()
        }
        
//        group.wait()
//        //group执行完成了
//        queue.async{
//            print("执行c任务")
//            currentThreadSleep(seconds: 2)
//            print("【c任务】 执行完成✅")
//        }
        
        group.notify(queue: queue){
            //group执行完成了
            queue.async{
                print("执行c任务")
                currentThreadSleep(seconds: 2)
                print("【c任务】 执行完成✅")
            }
        }
    }
    
    // MARK: - 队列的循环、挂起、恢复 ??
    @objc func func_performQueuesApply(){
        let queueConcurrent = getConcurrent(label: "queue_Concurrent_00")
        let queueSerial = getSerial(label: "queue_Serial_00")
//        dispatch_apply(2, queueSerial) { index in
//            <#code#>
//        }
//        dispatch_apply(2, queueConcurrent){(index) in
//
//        }
    }
    
    // MARK: - 栅栏函数
    @objc func func_performQueuesBarrier(){
//任务栅栏就是将队列中的任务进行隔离的，是任务能分拨的进行异步执行。我想用下方的图来介绍一下barrier的作用。
//我们假设下方是并行队列，然后并行队列中有1.1、1.2、2.1、2.2四个任务，前两个任务与后两个任务本中间的栅栏给隔开了。
//如果没有中间的栅栏的话，四个任务会在异步的情况下同时执行。但是有栅栏的拦着的话，会先执行栅栏前面的任务。
//等前面的任务都执行完毕了，会执行栅栏自带的Block ，最后异步执行栅栏后方的任务。
        let queueConcurrent = getConcurrent(label: "queue_Concurrent_00")
        performQueuesUseASynchronization(queue: queueConcurrent)
        print("第一批-异步测试")
        queueConcurrent.async(flags: .barrier) {
            print("第一批执行完，才会执行第二批")
        }
        print("第二批-异步测试")
        performQueuesUseASynchronization(queue: queueConcurrent)
    }
    
    // MARK: - 锁 NSLock
    @objc func func_performQueuesNSLock(){
        let queueConcurrent = getConcurrent(label: "queue_Concurrent_00")
        print("测试-赋值取值")
        let model = jianpiaokouModel()
        model.tacketNum = 20
        let lock = NSLock()
        ///NSLock实现了最基本的锁，遵循NSLoaking协议，通过lock和unlock来进行加锁和解锁
        ///NSRecursiveLock
        ///当发生自己调用自己的时候，或者递归的时候，需要使用递归锁NSRecursiveLock
        ///用法跟NSLock是一样的，只是使用场景可能不一样。
        
        for index in 1...10{
            queueConcurrent.async { [self] in
                lock.lock()
                if (model.tacketNum > 0){
                    print("用户【\(index)】取票一张------当前票数-\(model.tacketNum)张")
                }else{
                    print("用户【\(index)】没取到票,剩余票数-\(model.tacketNum)张")
                }
                readFile(model: model,num: index)
                currentThreadSleep(seconds: 0.1)
                lock.unlock()
            }
        }
        queueConcurrent.async(flags: .barrier) { [self] in
            print("---------补票了--------")
            writeFile(model: model)
        }
        
        for index in 1...120{
            queueConcurrent.async { [self] in
                lock.lock()
                if (model.tacketNum > 0){
                    print("用户【\(index)】取票一张------当前票数-\(model.tacketNum)张")
                }else{
                    print("用户【\(index)】没取到票,剩余票数-\(model.tacketNum)张")
                }
                readFile(model: model,num: index)
                currentThreadSleep(seconds: 0.01)
                lock.unlock()
            }
        }
    }
    
    // MARK: - 递归锁 NSRecursiveLock
    @objc func func_performNSRecursiveLock(){
        let queueConcurrent = getConcurrent(label: "queue_Concurrent_00")
        print("测试-赋值取值")
        let lock = NSRecursiveLock()
        let model = jianpiaokouModel()
        model.tacketNum = 20
        queueConcurrent.async{
            var takeTacketMethod = {()in}
            takeTacketMethod = {
                lock.lock()
                if (model.tacketNum > 10){
                    print("用户取票一张------当前票数-\(model.tacketNum)张")
                    model.tacketNum -= 1
                    currentThreadSleep(seconds: 0.1)
                    takeTacketMethod()
                    lock.unlock()
                    ///⚠️注意这里，如果是NSLock,如果没有解锁就进入下一次循环，而再次请求上锁，
                    ///阻塞了该线程，线程被阻塞了，自然后面的解锁代码不会执行，而形成了死锁。
                    ///而 NSRecursiveLock 递归锁就是为了解决这个问题。
                }else{
                    print("用户没取到票,剩余票数-\(model.tacketNum)张")
                    currentThreadSleep(seconds: 0.1)
                    lock.unlock()
                }
                
            }
            takeTacketMethod()
        }
        
        queueConcurrent.async(flags: .barrier) { [self] in
            print("---------补票了--------")
            writeFile(model: model)
        }
        
        queueConcurrent.async{
            var takeTacketMethod = {()in}
            takeTacketMethod = {
                lock.lock()
                if (model.tacketNum > 0){
                    print("用户取票一张------当前票数-\(model.tacketNum)张")
                    model.tacketNum -= 1
                    currentThreadSleep(seconds: 0.01)
                    takeTacketMethod()
                    lock.unlock()
                    ///⚠️注意这里，如果是NSLock,如果没有解锁就进入下一次循环，而再次请求上锁，
                    ///阻塞了该线程，线程被阻塞了，自然后面的解锁代码不会执行，而形成了死锁。
                    ///而 NSRecursiveLock 递归锁就是为了解决这个问题。
                }else{
                    print("用户没取到票,剩余票数-\(model.tacketNum)张")
                    currentThreadSleep(seconds: 0.01)
                    
                    lock.unlock()
                }
            }
            takeTacketMethod()
        }
        
    }
    // MARK: - NSConditionLock-互斥锁/条件锁
    @objc func func_performNSConditionLock(){
//        NSConditionLock 对象所定义的互斥锁可以在使得在某个条件下进行锁定和解锁，
//        它和 NSLock 类似，都遵循 NSLocking 协议，方法都类似，只是多了一个 condition 属性，
//        以及每个操作都多了一个关于 condition 属性的方法，例如 tryLock、tryLockWhenCondition:，
//        所以 NSConditionLock 可以称为条件锁。
//        只有 condition 参数与初始化时候的 condition 相等，lock 才能正确进行加锁操作。
//        unlockWithCondition: 并不是当 condition 符合条件时才解锁，而是解锁之后，修改 condition 的值。
        let queueConcurrent = getConcurrent(label: "queue_Concurrent_00")
        print("互斥锁/条件锁")
        print("预期【task 1】->【task 3】->【task 4】->【task 2】")
        let lock = NSConditionLock(condition: 0)
        
        queueConcurrent.async {
            let taskName = "task1"
            let taskTime = 1
            print("\(taskName):----开始执行")
            currentThreadSleep(seconds: Double(taskTime))
            lock.lock()
            defer{
                lock.unlock()
            }
            print("\(getCurrentThread())--\n\(taskName):执行完成✅--耗时：【\(taskTime)s】")
        }
        queueConcurrent.async {
            let taskName = "task2"
            let taskTime = 2
            print("\(taskName):----开始执行")
            currentThreadSleep(seconds: Double(taskTime))
            lock.lock(whenCondition: 1)
            defer{
                lock.unlock()
            }
            print("\(getCurrentThread())--\n\(taskName):执行完成✅--耗时：【\(taskTime)s】")
        }
        queueConcurrent.async {
            let taskName = "task3"
            let taskTime = 3
            print("\(taskName):----开始执行")
            currentThreadSleep(seconds: Double(taskTime))
            if lock.tryLock(whenCondition: 0){
                defer{
                    lock.unlock(withCondition: 2)
                }
                print("\(getCurrentThread())--\n\(taskName):执行完成✅--耗时：【\(taskTime)s】")
            }else{
                print("task3:----加锁失败")
            }
            
        }
        queueConcurrent.async {
            let taskName = "task4"
            let taskTime = 4
            print("\(taskName):----开始执行")
//            currentThreadSleep(seconds: Double(taskTime))
            let date = Date.init(timeInterval: 10, since: Date())
            if lock.lock(whenCondition: 2, before: date){
                defer{
                    lock.unlock(withCondition: 1)
                }
                print("\(getCurrentThread())--\n\(taskName):执行完成✅--耗时：【\(taskTime)s】")
            }else{
                print("task4:----加锁失败")
            }
            
        }
    }
    
    // MARK: - 关键字加锁
    @objc func func_performSynchronized(){
        //OC 中的线程互斥锁方法。Swift 对应使用 objc_sync_enter(self) 和objc_sync_exit(self)。
        //方法中的参数只能使 self，使用其它的不能达到互斥锁的目的。
        //效率很低
        let model = modelSynchronized()
        let queue = getGlobalQueue(qos: .default)
        
        queue.async {
            print("task--start")
            model.start()
        }
        
    }
    // MARK: - NSCondition-条件锁
    @objc func func_performNSCondition(){
        let queue = getGlobalQueue(qos: .default)
        let lock = NSCondition()
        var productNum = 0
        //NSCondition类实现了一个条件变量，该变量遵循posix条件的语义。条件对象在给定线程中充当锁和检查点。
        //锁在测试条件并执行由条件触发的任务时保护锁内的代码。检查点行为要求在线程继续执行其任务之前，
        //条件必须为真。当条件不为真时，线程阻塞，且一直处于阻塞状态，直到另一个线程向条件对象发出信号。
        ///生产商品
        var productMethod = {()in}
        ///消费商品
        var consumerMethod = {(str:String)in}
        
        for i in 1..<3{
            queue.async {
                productMethod()
            }
            
            queue.async {
                consumerMethod("a--\(i)")
            }
            
            queue.async {
                consumerMethod("b--\(i)")
            }
        }
        
        productMethod = {
            lock.lock()
            defer{
                lock.unlock()
            }
            currentThreadSleep(seconds: 2)
            productNum += 1
            print("生产了一个商品，现有商品总数---\(productNum)个")
            //发出消息
            lock.signal()
            
        }
        
        consumerMethod = { name in
            lock.lock()
            defer{
                lock.unlock()
            }
            while productNum == 0 {
                print("【\(name)】等待消费中，现在商品数量为0")
                //保证正常流程
                lock.wait()
            }
            currentThreadSleep(seconds: 1)
            productNum -= 1
            print("【\(name)】消费了一个商品，现有商品总数---\(productNum)个")
        }
    }
    // MARK: - NSOperation-创建队列/添加操作
    @objc func func_performNSOperation(){
//        在swift中的实现方式分2种（oc还多了一个NSInvocationOperation，并且在oc中NSOperation是个抽象类）：
//    　　　　1.NSBlockOperation
//    　　　　2.自定义子类继承NSOperation
//=============1.NSOoperation常用操作，创建队列，设置最大并发数。
        //创建队列
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        
        let operation = BlockOperation {
            let taskName = "task1"
            let taskTime = 1
            print("\(taskName):----开始执行")
            currentThreadSleep(seconds: Double(taskTime))
            print("\(getCurrentThread())--\(taskName)执行完成✅--耗时：【\(taskTime)s】")
        }
        let operation2 = BlockOperation {
            let taskName = "task2"
            let taskTime = 2
            print("\(taskName):----开始执行")
            currentThreadSleep(seconds: Double(taskTime))
            print("\(getCurrentThread())--\(taskName)执行完成✅--耗时：【\(taskTime)s】")
        }
        //添加到队列中的operation将自动异步执行
//执行operation中的任务有两种方法：
//1、调用Operation的实例方法：start()
//2、添加到OperationQueue创建的队列中
//        operation.start()
//        operation2.start()
        queue.addOperation(operation)
        queue.addOperation(operation2)
        //还有一种方式，直接将operation的blcok直接加入到队列
        operation.addExecutionBlock {
            let taskName = "task3"
            let taskTime = 3
            print("\(taskName):----开始执行")
            currentThreadSleep(seconds: Double(taskTime))
            print("\(getCurrentThread())--\(taskName)执行完成✅--耗时：【\(taskTime)s】")
        }
        //当operation有多个任务的时候会自动分配多个线程并发执行,
        //如果只有一个任务，会自动在主线程同步执行
        
        //其他操作
        //取消所有操作
//取消
//调用cancel()可以取消一个操作的执行。关于取消:
//(1) 如果这个操作还没执行，调用cancel()会将状态 isCanceled和isReady置为true,如果执行取消后的操作，会直接将状态isFinish置为true而不会执行操作。因此，我们应该在每个操作开始前，或者在每个有意义的实际操作完成后，先检查下isCanceled是不是已经设置为true，如果是true，则这个操作就不用再执行了；
//(2) 如果这个操作正在执行，调用cancel()只会将状态isCanceled置为true，但不会影响操作的继续执行。
//如果要取消一个操作队列中的所有操作，调用OperationQueue的方法cancelAllOperations()
//        queue.cancelAllOperations()
//        operation.cancel()
        
//    另外、遵从KVO的属性
//    isCancelled - read-only
//    isAsynchronous - read-only
//    isExecuting - read-only
//    isFinished - read-only
//    isReady - read-only
//    dependencies - read-only
//    queuePriority - readable and writable
//    completionBlock - readable and writable
//    注意：如果你观察这些属性值，要做与UI相关的操作，要注意线程,因为你接收到属性值改变可能是在子线程中。
//    isCancelled、isExecuting、isFinished、isReady都是状态相关的属性。
//    isAsynchronous :表示操作是否是异步执行任务，默认为false，主要用于自定义并发操作时重写该属性。
//    但是，如果该操作添加到操作队列中，操作队列会略过该属性（无论值为true还是false）
//    dependencies：该操作可以开始执行前，需要执行的所有有依赖关系的操作对象的数组
//   queuePriority：操作优先级。OperationQueue有maxConcurrentOperationCount设置，
//   当队列中operation很多时而你想让后续的操作提前被执行的时候，你可以为你的operation设置优先级
//
//    veryLow
//    low
//    normal
//    high
//    veryHigh
//    completionBlock: 操作完成时会调用该block
//
//    waitUntilFinished() 调用该方法会阻塞当前线程，当前线程会等待该操作执行完再执行下面的任务
        
    }
    // MARK: - NSOperation-操作添加依赖
    @objc func func_performNSOperation2(){
        //创建队列
//==========  2.NSOperation操作依赖，可设置一个操作在另一个操作完成后在执行
//        注意：
//1.在使用队列任务的时候，内存警告的时候可使用队列的cancelAllOperations函数取消所有操作，
//注意一旦取消不可恢复。亦可设置队列的suspended属性暂停和恢复队列。
//2.在设置操作依赖的时候不能设置循环依赖。
//添加依赖关系可以让各个操作按指定的顺序执行，通过addDependency(_:) 添加依赖和
//removeDependency(_:)移除依赖。依赖关系中的上一个操作执行完之后（
//这时上一个操作的状态isFinish操作置为true），下一个操作才开始准备与执行。注意:
//    (1)不能添加相互依赖，像A依赖B，B依赖A，这样会导致死锁;
//    (2)添加依赖的操作，最好添加到操作队列中，直接调用start()也极易导致死锁。
        let queue = OperationQueue()
        let operation = BlockOperation {
            let taskName = "task1"
            let taskTime = 1
            print("\(taskName):----开始执行")
            currentThreadSleep(seconds: Double(taskTime))
            print("\(getCurrentThread())--\(taskName)执行完成✅--耗时：【\(taskTime)s】")
        }
        let operation2 = BlockOperation {
            let taskName = "task2"
            let taskTime = 2
            print("\(taskName):----开始执行")
            currentThreadSleep(seconds: Double(taskTime))
            print("\(getCurrentThread())--\(taskName)执行完成✅--耗时：【\(taskTime)s】")
        }
        let operation3 = BlockOperation {
            let taskName = "task3"
            let taskTime = 3
            print("\(taskName):----开始执行")
            currentThreadSleep(seconds: Double(taskTime))
            print("\(getCurrentThread())--\(taskName)执行完成✅--耗时：【\(taskTime)s】")
        }
        print("预期【task1】->【task3】->【task2】")
        operation2.addDependency(operation3)
        operation3.addDependency(operation)
//        operation3.removeDependency(operation)
        queue.addOperation(operation)
        queue.addOperation(operation2)
        queue.addOperation(operation3)
    }
    
    // MARK: - NSOperation-操作监听
    @objc func func_performNSOperation3(){
//=========== // 3.NSOperation操作监听，一个操作完成后调用另一个操作：==========
        let queue = OperationQueue()
        let operation = BlockOperation {
            let taskName = "task1"
            let taskTime = 1
            print("\(taskName):----开始执行")
            currentThreadSleep(seconds: Double(taskTime))
            print("\(getCurrentThread())--\(taskName)执行完成✅--耗时：【\(taskTime)s】")
        }
        var doSomething = {()in}
        doSomething = {
            print("监听task1:----执行完成")
            
        }
        operation.completionBlock = doSomething
        queue.addOperation(operation)
//========= 4.NSOperation线程通信，NSOperationQueue.mainQueue。
        let queue2 = OperationQueue()
        print("预期-【operationqueue】->【main】")
        queue2.addOperation {
            let taskName = "task2"
            let taskTime = 2
            print("\(taskName):----开始执行")
            currentThreadSleep(seconds: Double(taskTime))
            print("\(getCurrentThread())--\(taskName)执行完成✅--耗时：【\(taskTime)s】")
            OperationQueue.main.addOperation {
                let taskName = "task3"
                let taskTime = 2
                print("\(taskName):----开始执行")
                currentThreadSleep(seconds: Double(taskTime))
                print("\(getCurrentThread())--\(taskName)执行完成✅--耗时：【\(taskTime)s】")
            }
        }
        
    }
    
    // MARK: - NSInvocationOperation
    @objc func func_performNSInvocationOperation(){
//如果你正在对现有的application进行修改，并且application已经有了执行task的object和methods,
//不妨使用NSInvocationOperation。
//        NSInvocationOperation 在swift 已不提供接口
        //创建序列
        let queue = OperationQueue()
        
        
    }
    
    // MARK: - <#mark#>
    @objc func func_perform(){
    }
    class jianpiaokouModel {
        var tacketNum:Int = 0
    }
    
    func writeFile(model:jianpiaokouModel) {
        print("-----------补票100张")
        model.tacketNum += 100
    }
     
    func readFile(model:jianpiaokouModel,num:Int){
        if (model.tacketNum > 0){
//            print("用户【\(num)】取票一张------剩余票数-\(model.tacketNum)张")
            model.tacketNum -= 1
        }else{
//            print("剩余票数-\(model.tacketNum)张")
        }
    }
    
}

class modelSynchronized{
    private var array: [Int] = []
    init() {
        for i in 0..<100 {
            array.append(i)
        }
    }
    
    func start() {
        DispatchQueue.global().async {
            self.remove()
        }
        DispatchQueue.global().async {
            self.remove()
        }
    }

    @objc private func remove() {
        print("\(Thread.current)::\(array.count)")
        // 互斥锁
        objc_sync_enter(self)
        while array.count > 0 {
            array.removeLast()
            print("\(Thread.current)::\(array.count)")
        }
        print("\(Thread.current)::\(array.count)")
        objc_sync_exit(self)
    }
}
/**
 获取主线程
 
 - return Thread
 */
@discardableResult
func getCurrentThread() -> Thread {
    return Thread.current
}
/**
 当前线程休眠
 
 - parameter timer: 休眠时间/s
 */
func currentThreadSleep(seconds:Double) -> Void {
    Thread.sleep(forTimeInterval: seconds)
    //或者使用
//    sleep(UInt32(seconds))
}

/**
 获取主线程
 
 - return: DispatchQueue
 */
@discardableResult
func getMainQueue() -> DispatchQueue {
    return DispatchQueue.main
}

/**
 获取全局队列，并指定优先级
 
 -
 */
@discardableResult
func getGlobalQueue(qos:DispatchQoS.QoSClass = .default) -> DispatchQueue {
    //background DispatchQoS 在所有任务中具有最低的优先级。针对当APP在后台运行的时候，需要处理的任务
    //utility: DispatchQoS 优先级低于default, userInitiated, userInteractive，高于background。
    //将类型分配给不会阻止用户继续使用您的应用程序的任务。 例如，您可以将此类分配给长时间运行的任务，而这些任务的进度用户并未积极关注。
    //default: DispatchQoS 优先级低于 userInitiated, userInteractive，但高于utility和background。将此类型分配给应用启动或代表用户执行活动的任务或队列。
    //userInitiated: DispatchQoS 优先级仅仅低于 userInteractive。 将此类型分配给可以为用户的操作提供即时结果的任务，或者将阻止用户使用您的应用的任务。 例如，您可以使用此类型加载要显示给用户的电子邮件的内容。
    //userInteractive: DispatchQoS 在所有任务中具有最高的优先级。将此类型分配给可与用户交互或主动更新应用程序的用户界面的任务或队列。 例如，将此用于动画类或跟踪事件。
    //unspecified: DispatchQoS 未设置优先级
    return DispatchQueue.global(qos: qos)
}

//    Serial Queue与Concurrent Queue中都有4个Block（编号为1--4），然后使用dispatch_sync()来同步执行。由上述示例我们可以得出，同步执行方式，也就是使用dispatch_sync()来执行队列不会开辟新的线程，会在当前线程中执行任务。如果当前线程是主线程的话，那么就会阻塞主线程，因为主线程被阻塞了，就会会造成UI卡死的现象。因为同步执行是在当前线程中来执行的任务，也就是说现在可以供队列使用的线程只有一个，所以串行队列与并行队列使用同步执行的结果是一样的，都必须等到上一个任务出队列并执行完毕后才可以去执行下一个任务。我们可以使用同步执行的这个特点来为一些代码块加同步锁。下方就是上面代码以及执行结果的描述图。

/**
 创建串行队列
 
 - parameter label: 串行队列标签
 
 - return:串行队列
 */
@discardableResult
func getSerial(label:String) -> DispatchQueue {
//    label是取个名字
//    qos参数和获取全局队列是一样的,
//    attributes有两个值,默认是串行队列（Serial），初始化时指定 attributes 参数为 .concurrent，可以创建成并行队列（Concurrent）
//    autoreleaseFrequency是任务相关的自动释放,有三个值,inherit跟随后面的target队列,后面再说; workItem按照任务的周期,取决于任务本身; never不主动释放,需要手动管理
//    target是获取已存在的队列,这个目标队列决定了最终返回的队列的属性.
    return DispatchQueue.init(label: label, qos: .background, autoreleaseFrequency: .workItem, target: nil)
}

/**
 创建并行队列
 
 - parameter label: 并行队列标签
 
 - return:并行队列
 */
@discardableResult
func getConcurrent(label:String) -> DispatchQueue {
//    label是取个名字
//    qos参数和获取全局队列是一样的,
//    attributes有两个值,默认是串行队列（Serial），初始化时指定 attributes 参数为 .concurrent，可以创建成并行队列（Concurrent）
//    autoreleaseFrequency是任务相关的自动释放,有三个值,inherit跟随后面的target队列,后面再说; workItem按照任务的周期,取决于任务本身; never不主动释放,需要手动管理
//    target是获取已存在的队列,这个目标队列决定了最终返回的队列的属性.
    return DispatchQueue.init(label: label, qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
}

func performQueuesUseSynchronization(queue:DispatchQueue) -> Void {
    for i in 1...3{
        let randomSecond = arc4random()%3 + 1
        queue.sync{
            var log = String()
            log += String(format: "%@", getCurrentThread())
            log += "\ntask:\(i)添加完毕---定义时长【\(randomSecond)s】"
            print(log)
            currentThreadSleep(seconds: Double(randomSecond))
            print("\(getCurrentThread())--\ntask:\(i)执行完成✅--耗时：【\(randomSecond)s】")
        }
    }
}
func performQueuesUseASynchronization(queue:DispatchQueue,group:DispatchGroup? = nil) -> Void {
    for i in 1...3{
        let randomSecond = arc4random()%4 + 1
        queue.async(group: group){
            var log = String()
            log += String(format: "%@", getCurrentThread())
            log += "\ntask:\(i)添加完毕---定义时长【\(randomSecond)s】"
            print(log)
            currentThreadSleep(seconds: Double(randomSecond))
            print("\(getCurrentThread())--\ntask:\(i)执行完成✅--耗时：【\(randomSecond)s】")
        }
    }
}

func performQueuesUseASynchronizationDef(queue:DispatchQueue,group:DispatchGroup? = nil) -> Void {
    for i in 1...3{
        let randomSecond = arc4random()%4 + 1
        group?.enter()
        queue.async{
            var log = String()
            log += String(format: "%@", getCurrentThread())
            log += "\ntask:\(i)添加完毕---定义时长【\(randomSecond)s】"
            print(log)
            currentThreadSleep(seconds: Double(randomSecond))
            print("\(getCurrentThread())--\ntask:\(i)执行完成✅--耗时：【\(randomSecond)s】")
            group?.leave()
        }
    }
}

func performQueueDefer(seconds:Double) -> Void {
    let delayTime:DispatchTime = DispatchTime.now() + seconds
    let item = DispatchWorkItem {
        print("执行完成✅--耗时：【\(seconds)s】")
    }
    getMainQueue().asyncAfter(deadline: delayTime, execute: item)
}

