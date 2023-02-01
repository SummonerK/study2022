//
//  NetToolTests.swift
//  NetToolTests
//
//  Created by luoke_ios on 2022/10/18.
//

import XCTest

final class NetToolTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBanjiModel() throws -> Void{
        var students = [student(name: "梨花",code: "0909"),student(name: "荷花",code: "0901")]
        
        var banji1 = BanjiModel<student>()
        banji1.name = "植物"
        banji1.code = "001"
        banji1.teacher = "绛珠仙子"
        banji1.students = students
        
        print(banji1)
        printLine()
        students[0].setStudent(withName: "梨花花", withCode: "0908")
        print(banji1)
        print(students)
        
        let students1:[String] = ["水浒","三国"]
        
        var banji2 = BanjiModel<String>()
        banji2.name = "名著"
        banji2.code = "002"
        banji2.teacher = "图书管理员"
        banji2.students = students1
        
        print(banji2)
        
    }
    
    func testString() -> Void {
        let temp = String(format: "%@", "go go go")
        printAddress(temp)
    }
    
    // MARK: 读取指针
    func testPointer() -> Void {
        var a = 10
        /**
            通过Swift提供的简写的API，这里是尾随闭包的写法
            返回值的类型是 UnsafePointer<Int>
         */
        let p = withUnsafePointer(to: &a) { $0 }
        print(p)

        withUnsafePointer(to: &a) {
            print($0)
        }

        // Declaration let p1:UnsafePointer<Int>
        let p1 = withUnsafePointer(to: &a) { ptr in
            return ptr
        }
        print(p1)
        
        print(p1.pointee)
        printLine()
        print(p1.pointee + 1)
    }
    
    // MARK: - 通过指针取值
    func testPointerValue() -> Void {
        var a = 10
        let p = withUnsafePointer(to: &a) { $0 }
        print(p.pointee)

        withUnsafePointer(to: &a) {
            print($0.pointee)
        }

        let p1 = withUnsafePointer(to: &a) { ptr in
            return ptr
        }
        print(p1.pointee)

        let p2 = withUnsafePointer(to: &a) { ptr in
            return ptr.pointee
        }
        print(p2)
        
        
        a = withUnsafePointer(to: &a) { ptr in
            return ptr.pointee + 2
        }
        print(a)
        
        withUnsafeMutablePointer(to: &a){ ptr in
            ptr.pointee += 2
        }
        print(a)
        
        
    }
    
    // MARK: - String
    func testStringFuc() -> Void {
        let aStr = "春有百花秋有月，夏有凉风冬有雪"
        
        //判断前缀
        let isPrefix = aStr.hasPrefix("若")
        print("若" + (isPrefix ? "" : "不") + "是前缀")
        let isSuffix = aStr.hasSuffix("雪")
        print("雪" + (isSuffix ? "" : "不") + "是后缀")
        
        //字符串长度
        let strLenght = aStr.count
        print(String(format: "%@,长度=%d", aStr,strLenght))
        
    }
    
    // MARK: - 区间运算符
    func testYunSuanFu() -> Void {
        for a in 1...3{
            print(a)
        }
        printLine()
        for a in 1..<3{
            print(a)
        }
    }
    
    // MARK: - 函数
    func testFunc() -> Void {
        let resut = sumNum(param: 20, param: 10)
        print(resut)
        printLine()
        let result1 = sumNum(param: 10)
        print(result1)
        printLine()
        let result2 = sumNum(params: 1,2,3,4)
        print(result2)
        
        ///函数嵌套
        var myFuncType = chooseCountType(countType: .NumAdd)
        let result3 = myFuncType(10,20)
        printLine()
        print(result3)
        
        myFuncType = chooseCountType(countType: .NumSubtract)
        let result4 = myFuncType(30,20)
        printLine()
        print(result4)
        
        let myConfigType = setConfig(withType: .TESTING)
        printLine()
        myConfigType()
    }
    
    // MARK: - 高级函数
    func testHandleFunc() -> Void {
        var arrayValues = ["春有百花","秋有月","夏有凉风","冬有雪"]
        let arrayMap = arrayValues.map { (item:String) -> String in
            return String(format: "$%@$", item)
        }
        print(arrayValues)
        print(arrayMap)
        printLine()
        
        ///数组-映射函数
        let arrayMap1 = arrayValues.map { item in
            return item.count<=3
        }
        print(arrayMap1)
        printLine()
        
        /// 数组-过滤器函数
        let arrayFilter = arrayValues.filter { item in
            return item.count<=3
        }
        print(arrayFilter)
        printLine()
        
        arrayValues = arrayValues.filter { item in
            return item.count==3
        }
        print(arrayValues)
        printLine()
        
        /// 数组-合并函数
        let arrayReduce = arrayValues.reduce("") {(result,item)->String in
            return result + "「" + item + "」"
        }
        print(arrayReduce)
    }
    
    // MARK: - 数组
    func testFuncArray() -> Void {
        var arrayValue:Array<String> = ["春有百花","秋有月","夏有凉风","冬有雪"]
        print(arrayValue)
        printLine()
        
        let isContains = arrayValue.contains("秋有月")
        print(String(format: "判断包含【 %@ 】", isContains ? "包含":"不包含"))
        
        //新增
        arrayValue.append("卧槽")
        arrayValue.insert("我来组成头部", at: 0)
        print(arrayValue)
        printLine()
        
        //移除
        arrayValue.remove(at: 0)
        arrayValue.removeLast()
        //移除前面几项
//        arrayValue.removeFirst(2)
        //移除后面几项
//        arrayValue.removeLast(2)
        print(arrayValue)
        printLine()
        
        //追加
        let arrayAdd = ["若无闲事挂心头","便是人间好时节"]
        arrayValue += arrayAdd
        print(arrayValue)
        printLine()
        
        //初始值
        let arrayHold:Array<String> = Array(repeating: "略", count: 5)
        print(arrayHold)
        printLine()
        
    }
    
    // MARK: - Switch
    func testSwitch() -> Void {
        //匹配数字
        let noSafeValue = 1
        switch noSafeValue {
        case 1:
            print("张三")
        case 2:
            print("彭摆鱼")
        default:
            print("有什么东西搞错了～")
        }
        
        printLine()
        //匹配字串
        let noSafeMZ = "三国"
        switch noSafeMZ {
        case "三国":
            print("三国猛将")
            print("刘大，关二，张三")
        case "红楼":
            print("红楼玉石")
            print("假宝玉，林戴玉")
        default:
            print("有什么东西搞错了～")
        }
        
        printLine()
        //匹配区间
        let noSafeNum = 10_000_000
        switch noSafeNum {
        case 1..<5_000:
            print("不交税")
        case 5_000..<10_000:
            print("交税，只能交一点点🤏")
        case 10_000..<1_000_000:
            print("交税，比例有点大")
        case 1_000_000..<Int.max:
            print("大胆，我只拿一块钱年薪呢～")
        default:
            print("有什么东西搞错了～")
        }
        
        printLine()
        //匹配元组
        let person:(li:Int,zhi:Int,ti:Int) = (3_000,1_000,600_000)
        print(String(format: "力：%d,法：%d,体:%d", person.li,person.zhi,person.ti))
        switch person {
        case (1..<5,1..<5,1..<5):
            print("平平无奇的战五渣")
        case (5..<100,5..<100,5..<100):
            print("有点实力的凡人")
        case (100..<999,100..<999,100..<999):
            print("半神")
        case let temp where (temp.li > 999 && temp.zhi > 999 && temp.ti > 999):
            print("不可明状")
        default:
            print("有什么东西搞错了～")
        }
        
    }
    
    // MARK: - 运算符 ===
    func testSomeThing() -> Void {
        let a = MyBook(name: "西游记")
        let b = a
//        如果要判断两个变量是否指向同一个实例，那么我们就需要使用恒等运算符（===）了。
//        下方就是判断a是否和b指向同一个内存空间，具体代码如下所示：
        if a === b{
            print("a === b")
        }
    }
    
    // MARK: - 断言
    func testAssertions() -> Void {
        //致命错误
        //使用fatalError()函数可以立即终止你的应用程序，在fatalError()中可以给出终止信息。
        //使用fatalError()函数，会毫无条件的终止你的应用程序，用起来也是比较简单的，就是一个函数的调用。
//        fatalError("断言致命错误")
//        在assert()函数中, 第一个参数是Bool类型，第二个参数是输出的信息。
        //当条件为true时，断言不执行，相应的断言信息不打印。当条件为false时，断言执行，并且打印相应的断言信息。
        assert(true,"断言正确情况，不予打印")
//        assert(false,"断言错误情况，予以打印")
        //assertionFailure()函数只有一个Message参数，并且该参数也是可以省略的，
        //assertionFailure()没有条件。
//        assertionFailure("无条件执行")
        
//        先决条件（Preconditions） 用法和定义与【assert】基本相同
        
        precondition(true,"断言正确情况，不予打印")
//        preconditionFailure("无条件执行")
        //重要‼️
//        断言Assert仅在调试环境运行，
//        先决条件precondition则在调试环境和生产环境中运行。
        
    }
    
    // MARK: - swift 类
    func testClass() -> Void {
        let aSon = Tom(familyName: "李",fullName: "书同",job: "骑士")
        aSon.sayHello()
    }
    
    // MARK: - 通用读取指针
    func printAddress(_ p: UnsafeRawPointer) {
        print(p)
    }
    
    // MARK: - 通用换行
    func printLine() -> Void {
        print("===============换行===============")
    }
    
    // MARK: - 函数定义和参数命名
    func sumNum(param numOne:Int,param numTwo:Int) -> Int{
        return numOne + numTwo
    }
    
    func sumNum(param numOne:Int,param numTwo:Int? = 5) -> Int{
        return numOne + (numTwo ?? 0)
    }
    
    func sumNum(params numbers:Int ...) -> Int {
        var sum = 0
        for num in numbers{
            sum += num
        }
        return sum
    }
    
    // MARK: - 函数嵌套
    func chooseCountType(countType:IBCountType) -> ((Int,Int) -> Int) {
        func Add (param numOne:Int,param numTwo:Int) -> Int{
            return numOne + numTwo
        }
        func Subtract (param numOne:Int,param numTwo:Int) -> Int{
            return numOne - numTwo
        }
        
        var myFuncType:(Int,Int) -> Int
        
        switch countType{
        case .NumAdd:
            myFuncType = Add
        case .NumSubtract:
            myFuncType = Subtract
        }
        
        return myFuncType
    }
    
    // MARK: - 普通函数嵌套
    func setConfig(withType configType:IBConfigExtType) -> (() -> Void) {
        func configDev () {
            print("配置Dev 环境")
        }
        
        func configTesting () {
            print("配置Testing 环境")
        }
        
        var myFuncType: () -> Void
        
        switch configType{
        case .DEV:
            myFuncType = configDev
        case .TESTING:
            myFuncType = configTesting
        }
        
        return myFuncType
    }

}

enum IBCountType{
    case NumAdd
    case NumSubtract
}

enum IBConfigExtType{
    case TESTING
    case DEV
}


struct BanjiModel<T>{
    var name:String?
    var code:String?
    var teacher:String?
    var students:[T]?
}

struct student{
    var name:String?
    var code:String?
    
    //重置 studen 属性
    //struct 属性只读，mutating修饰可以修改数据
    mutating func setStudent(withName aname:String,withCode acode:String){
        name = aname
        code = acode
    }
}


class MyBook{
    var name:String?
    var code:String?
    
    init(name: String? = nil, code: String? = nil) {
        self.name = name
        self.code = code
    }
}


class Father{
    ///姓
    var familyName:String?
    ///全名
    var fullName:String?
    
    ///取名字的方法
    init(familyName: String? = nil, fullName: String? = nil) {
        self.familyName = familyName
        self.fullName = fullName
    }
}

class Tom:Father{
    var job:String?
    init(familyName: String? = nil, fullName: String? = nil, job: String? = nil) {
        super.init(familyName: familyName,fullName: fullName)
        self.job = job
    }
    
    func sayHello() -> Void {
        print(String(format: "我是【%@%@】,我是一个【%@】", familyName ?? "",fullName ?? "",job ?? ""))
    }
}



//tip final 在Swift中也是有final关键字的，被final关键字所修饰的类是不能用来继承的。

//访问权限：
/*
 public: 公有访问权限，类或者类的公有属性或者公有方法可以从文件或者模块的任何地方进行访问。那么什么样才能成为一个模块呢？一个App就是一个模块，一个第三方API, 第三等方框架等都是一个完整的模块，这些模块如果要对外留有访问的属性或者方法，就应该使用public的访问权限。
 private: 私有访问权限，被private修饰的类或者类的属性或方法可以在同一个物理文件中访问。如果超出该物理文件，那么有着private访问权限的属性和方法就不能被访问。
 internal: 顾名思义，internal是内部的意思，即有着internal访问权限的属性和方法说明在模块内部可以访问，超出模块内部就不可被访问了。在Swift中默认就是internal的访问权限。
 */
