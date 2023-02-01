//
//  subscriptFuncVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/28.
//

import UIKit

class subscriptFuncVC: BaseFuncListVC {
    @IBOutlet weak var view_progress:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubviewToFront(view_progress)

        // Do any additional setup after loading the view.
    }
    override func setListData() {
        listDataInsert(keyWork: "Hello YYCache",
                               content: "testCacheUse")
        listDataInsert(keyWork: "hangge -- 下标方法",
                               content: "funcList_subscript")
    }
    
    @objc func testThread() -> Void {
        MBHud.showInfoWithMessage("正常")
    }
    
    
}


extension subscriptFuncVC{
    
    @objc func testCacheUse() -> Void {
        LKPrint("Hello func")
    }
    
    @objc func funcList_subscript() -> Void {
        funcSubscript()
    }
    
}

extension subscriptFuncVC{
    // MARK: - 基本使用
    
    func showRegistFuncs() -> Void {
        let alertC = UIAlertController.init(title: "功能列表", message: nil,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("下标脚本 - 方法", .default) {
            self.funcSubscript()
        }
    }
    
    func funcSubscript() -> Void {
        
        let value = Matrix(rows: 20,columns: 20)
        value[10,10] = 20
        print(value[10,10])
    }
    
}

// MARK: - 定义下标脚本之后，可以使用“[]”来存取数据类型的值。
// 原文出自：www.hangge.com  转载请保留原文链接：https://www.hangge.com/blog/cache/detail_522.html
// 使用一维数组结合下标方法一定程度上模拟实现了二维数组

class Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
     
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
     
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
     
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
