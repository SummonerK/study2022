//
//  DataTransVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/29.
//

import UIKit

class DataTransVC: BaseVC {
    @IBOutlet weak var bton_next:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = baseBGColor
        
        //功能集合
        bton_next.jk.setHandleClick {[weak self] button in
            guard let self = self else{return}
            self.showRegistFuncs()
        }
    }
    
    // MARK: - 方法一：使用 [UInt8] 新的构造函数
    func func_dataTransBytes_1() -> Void {
        let data = "NetTool".data(using: .utf8)!
        let bytes = [UInt8](data)
        print(bytes)
    }
    
    // MARK: - 方法二：通过 Pointer 指针获取
    func func_dataTransBytes_2() -> Void {
        let data = "NetTool".data(using: .utf8)!
        let bytes = data.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
        }
        print(bytes)
    }

}

extension DataTransVC{
    // MARK: - 基本使用
    func showRegistFuncs() -> Void {
        let alertC = UIAlertController.init(title: "功能列表", message: nil,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("方法一：使用 [UInt8] 新的构造函数", .default) {
            self.func_dataTransBytes_1()
        }
        alertC.addAction("方法二：通过 Pointer 指针获取", .default) {
            self.func_dataTransBytes_2()
        }
    }
    
}
