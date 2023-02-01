//
//  swiftBaseTest.swift
//  NetToolTests
//
//  Created by luoke_ios on 2022/10/20.
//

import XCTest
import Foundation

final class swiftBaseTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Error
    func testError(){
        do {
            try getSomeResponse(withScore: 85)
        } catch let e as IBError{
            print(e.description)
        }catch{
            print(error)
        }
    }
    
    // MARK: - throws
    func testTry(){
        let result = try? divNum(withBaseNum: 100, divNum: 0)
        print(result ?? "")
        ///等价于下面
        var num :Int?
        do {
            num = try divNum(withBaseNum: 100, divNum: 0)
        } catch let e as IBError {
            num = nil
            print(e.description)
        }catch{
            num = nil
            print(error)
        }
        print(num ?? "")
    }
    
    // MARK: - Dump
    func testDump() -> Void {
        let error = IBError(code: 409, message: "一个错误")
        dump(error)
    }
    
    func testMirror() -> Void {
        let person = Person(name: "李华", age: 24)
        let mirror = Mirror(reflecting: person.self)
        //
        print("对象类型:subjectType===\(mirror.subjectType)")
        print("对象属性个数：\(mirror.children.count)")
        print("对象的属性及属性值")
        print(mirror.children)
        for child in mirror.children{
            print(String(format: "label--%@,value--\(child.value)", child.label!))
        }
    }
    
    func testProtocol() -> Void {
        let cart1 = tabShoppingCart()
        cart1.goodsADD()
        let cart2 = goodDetailCart()
        cart2.goodsRemove()
    }
    
    // MARK: - 元组
    func testYuanzu() -> Void {
        let http404Error = (404,"Not Found")
        let (statusCode,StatusMessage) = http404Error
        print(String(format: "%@,%@", statusCode,StatusMessage))
        let (justStatusCode,_) = http404Error
        let http200Status = (statusCode,200,description: "OK")
    }
    
    // MARK: - 流程判断
    func testFrollow() -> Void {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

func getSomeResponse(withScore score:Int) throws -> Void {
    switch score{
    case 0..<90:
//        throw FuncError.errorReason(code: 2001, msg: "科目一成绩不合格")
        throw IBError(code: 2001, message: "科目一成绩不合格")
    case 90..<100:
        print("优秀")
    case 100:
        print("秀儿")
    default:
        throw FuncError.errorDefault(code: 500, msg: "有什么东西搞错了")
    }
}

func divNum(withBaseNum basNum:Int, divNum:Int) throws -> Int {
    if divNum == 0 {
        throw IBError(code: 1001, message: "除数不能为0")
    }
    let result = basNum / divNum
    return result
}

enum FuncError:Error{
    case errorReason(code:Int,msg:String)
    case errorDefault(code:Int,msg:String)
}


struct IBError:Error {
    let code: Int
    let message: String
    
    var description:String {
        return String(format: "IBError(code:%d,message:%@)", code,message)
    }
}

struct Person{
    var name: String
    var age: Int
}

protocol NealTrackCart{
    ///商品添加
    func goodsADD()
    ///商品移除
    func goodsRemove()
}

class tabShoppingCart: NealTrackCart {
    func goodsADD() {
        print("tabShoppingCart --- 商品添加了")
    }
    
    func goodsRemove() {
        print("tabShoppingCart --- 商品移除了")
    }
}

class goodDetailCart: NealTrackCart {
    func goodsADD() {
        print("goodDetailCart --- 商品添加了")
    }
    
    func goodsRemove() {
        print("goodDetailCart --- 商品移除了")
    }
}

//tips
/*
 处理Error
 在swift中，处理Error的3种方式：
 1、通过do-catch捕捉Error，然后处理Error（一般是和定义的枚举结合，通过switch来处理）。
 2、不捕捉Error，在当前函数增加throws声明，Error将自动抛给上层函数。如果最终没人处理，系统一样会崩溃闪退。
 3、通过使用try?、try!调用可能会抛出Error的函数，这样就不用去处理Error。当调用的函数抛出异常是得到的结果就是nil，如果正常，则返回一个可选项。
 rethrows
 rethrows表明：函数本身不会抛出错误，但调用闭包参数抛出错误，那么它会将错误向上抛。
 rethrows主要用于参数有闭包的时候，闭包本身会有抛出异常的情况。
 rethrows作为一个标志，显示的要求调用者去处理这个异常（不处理往上抛）。
 
 */
