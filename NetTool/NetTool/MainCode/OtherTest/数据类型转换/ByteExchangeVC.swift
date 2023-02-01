//
//  ByteExchangeVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/16.
//

import UIKit

class ByteExchangeVC: BaseVC {
    @IBOutlet weak var bton_next:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringColor(hexString: "f5f5f5")
        
        //功能集合
        bton_next.jk.addActionClosure {[weak self] atap, aview, aint in
            guard let self = self else{return}
            self.showRegistFuncs()
        }
        
        // Do any additional setup after loading the view.
    }
    
    /// byte 数据类型转换
    /// - Returns:
    func testByteExchange() -> Void {
        let string = "hello world"
        let data = string.data(using: .utf8)
    }

}

extension ByteExchangeVC{
    // MARK: - 规范注释
    func showRegistFuncs() -> Void {
        let alertC = UIAlertController.init(title: "功能测试", message: nil,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("byte 数据类型转换", .default) {
            self.testByteExchange()
        }
    }
}
