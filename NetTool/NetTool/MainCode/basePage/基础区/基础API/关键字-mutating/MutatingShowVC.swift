//
//  MutatingShowVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/2/2.
//

import UIKit

class MutatingShowVC: BaseFuncListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setListData() {
        listDataInsert(keyWork: "Hello Mutating",
                               content: "testList")
        listDataInsert(keyWork: "结构体-修改属性",
                               content: "testMyPoint")
        listDataInsert(keyWork: "在枚举中修改self属性值",
                               content: "testMyEnum")
    }
    
    @objc func testList() -> Void {
        MBHud.showInfoWithMessage("正常")
    }

}

extension MutatingShowVC{
    @objc func testMyPoint() -> Void {
        var apoint = myPoint()
        
        LKPrint("\(apoint.x),\(apoint.y)")
        
        apoint.movePoint(x: 10, y: 10)
        
        LKPrint("\(apoint.x),\(apoint.y)")
    }
    
    @objc func testMyEnum() -> Void {
        var type = TriSwitch.Off
        
        LKPrint(type.getDescription())
        
        type.next()
        
        LKPrint(type.getDescription())
    }
}


/*
 在Swift中，structure和enumeration是值类型(value type)

 class是引用类型(reference type)。

 默认情况下，实例方法中是不可以修改值类型的属性，使用mutating后可修改属性的值

 例如：

 在结构体中，有一个实例方法，如果直接修改属性的值，编译器会报错。

 可以使用mutating修饰
 
 在引用类型中(即class)中的方法默认情况下就可以修改属性值，不存在以下问题。
 */

struct myPoint {
    var x = 0
    var y = 0
    
    mutating func movePoint(x: Int, y: Int) {
        self.x += x
    }
}

/*
 在枚举中修改self属性值，需要使用mutating修饰
 */

enum TriSwitch {
    case Off, Low, High
    mutating func next() {
        switch self {
        case .Off:
            self = .Low
        case .Low:
            self = .High
        case .High:
            self = .Off
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .Off:
            return "Low"
        case .Low:
            return "High"
        case .High:
            return "Off"
        }
    }
}
