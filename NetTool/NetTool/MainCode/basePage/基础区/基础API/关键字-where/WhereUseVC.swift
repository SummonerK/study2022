//
//  WhereUseVC.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/31.
//

import UIKit

class WhereUseVC: BaseVC {
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

}

extension WhereUseVC{
    // MARK: - 规范注释
    func showRegistFuncs() -> Void {
        let message = "一些功能测试"
        let alertC = UIAlertController.init(title: "关键字-where", message: message,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("where-条件限制", .default) {
            self.func_whereFilter()
        }
        alertC.addAction("where-do", .default) {
            self.func_whereDo()
        }
    }
    
    // MARK: - 功能区
    // MARK: - 使用 1. 可以使用 where 关键词在 switch、for in 语句上做些条件限制。
    func func_whereFilter() -> Void {
        let scores = [20,8,59,60,70,80]
         
        //switch语句中使用
        scores.forEach {
            switch $0{
            case let x where x>=60:
                print("及格")
            default:
                print("不及格")
            }
        }
         
        //for语句中使用
        for score in scores where score>=60 {
            print("这个是及格的：\(score)")
        }
    }
    
    
    // MARK: - 使用 2. 在 do catch 里面使用
    func func_whereDo() -> Void {
        do{
            try throwError()
        }catch ExceptionError.httpCode(let httpCode) where httpCode >= 500{
            print("server error")
        }catch {
            print("other error")
        }
    }
    
    enum ExceptionError:Error{
        case httpCode(Int)
    }
     
    func throwError() throws {
        throw ExceptionError.httpCode(500)
    }
    
    
}


// MARK: - 使用 3. 与协议结合
protocol aProtocol{}
 
//只给遵守myProtocol协议的UIView添加了拓展
extension aProtocol where Self:UIView{
    func getString() -> String{
        return "string"
    }
}
