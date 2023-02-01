//
//  normalMarkVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/3.
//

import UIKit

class normalMarkVC: UIViewController {
    @IBOutlet weak var bton_next:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //功能集合
        bton_next.jk.addActionClosure {[weak self] atap, aview, aint in
            guard let self = self else{return}
            self.showRegistFuncs()
        }

        // Do any additional setup after loading the view.
    }

    /// 这是一个函数
    /// - Parameter argument: 传入Int类型参数
    /// - Returns: 返回Int类型参数
    func funcMark(argument parameter:Int) -> Int {
        let result = parameter + 3
        return result
    }
    
    /// 这是一个函数【自动添加注释，鼠标左键点击】
    /// - Parameter parameter: 传入Int类型参数
    /// - Returns: 返回Int类型参数
    func funcMarkauto(argument parameter:Int) -> Int {
        let result = parameter + 3
        return result
    }
    
    /// 这是一个函数【鼠标左键点击-添加方法-添加async】
    func testautoFunc() -> Void {
        Task{
            let result = await loadSomething()
            printLine()
            print(result)
            
            let result1 = await normalLoad()
            printLine()
            print(result1)
        }
    }
    
    @available(*, renamed: "loadSomething()")
    func loadSomething(callback: @escaping (String) -> Void){
        let semphore = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .background).async {
            currentThreadSleep(seconds: 2)
            callback("hello wait")
            semphore.signal()
        }
    }
    
    func loadSomething() async -> String {
        return await withCheckedContinuation { continuation in
            loadSomething() { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    
    func normalLoad() async -> String {
        currentThreadSleep(seconds: 3)
        return "hello,wait 2"
    }
    

}

extension normalMarkVC{
    // MARK: - 规范注释
    func showRegistFuncs() -> Void {
        let message = "一些功能测试"
        let alertC = UIAlertController.init(title: "规范注释", message: message,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("async/wait", .default) {
            self.testautoFunc()
        }
        alertC.addAction("random", .default) {
            self.testRandomProbability()
        }
    }
    
    /// 计算随机概率
    /// - Returns: Null
    func testRandomProbability() -> Void {
        var coinCount = 300
        var giftCount = 0
        for J in 1...coinCount{
            let num1 = Int.random(in: 1...6)
            let num2 = Int.random(in: 1...6)
//            print("第\(J)次：\t结果：===\t\(num1)--\(num2)")
            if num1 == num2{
                giftCount+=1
//                printLine()
//                print("congratulations on you! 🎉🎉")
            }
        }
        printLine()
        printLine()
        let giftProbablitity = CGFloat(giftCount)/CGFloat(coinCount)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 2//设置最小整数位(不足前面补0)
        formatter.maximumIntegerDigits = 2//设置最大整数位(超过的直接截断）
        formatter.maximumFractionDigits = 3//设置小数点后最多3位
        formatter.minimumFractionDigits = 1//设置小数点后最少2位（不足补0）
        //预期命中
        let onMath = CGFloat(1)/CGFloat(6)
        let percentOnMath = formatter.string(from: NSNumber(value: onMath))
        print("预期1/6概率为:\(String(describing: percentOnMath))")
        let giftProbablitityPercent = formatter.string(from: NSNumber(value: giftProbablitity))
        print("\(coinCount)次游戏，命中\(giftCount)次,概率为:\(String(describing: giftProbablitityPercent))")
    }
}


class NormalCard{
    var star:Int = 0
    var goldFlag:Int = 0
}

// MARK: - 思路
//比如，S卡概率为0.1%，玩家抽取随机数(1-1000),抽到1的时候，标识命中
//以此类比，B卡概率为10%，玩家抽取随机数(1-1000)，抽取计算结果，1-100标识命中 正好10%
//以上

//多卡情况下，概率计算问题。

