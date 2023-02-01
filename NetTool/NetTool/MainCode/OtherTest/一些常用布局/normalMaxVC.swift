//
//  normalMaxVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/10.
//

import UIKit

class normalMaxVC: UIViewController {
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

}

extension normalMaxVC{
    // MARK: - 规范注释
    func showRegistFuncs() -> Void {
        let message = "一些常用布局Demo"
        let alertC = UIAlertController.init(title: "布局", message: message,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("Head-pages", .default) {
            self.func_goto_headAndMorePages()
        }
        alertC.addAction("topArea-page", .default) {
            self.func_gotoToparea()
        }
        alertC.addAction("选择结果联动", .default) {
            self.func_gotoConbinVC()
        }
    }
}


extension normalMaxVC{
    
    /// head-[page,page,page]布局
    /// - Returns:
    func func_goto_headAndMorePages() -> Void {
        let toVC = headAndMorePage()
        toVC.title = "Head-pages"
        self.navigationController?.pushViewController(toVC, animated: true)
    }
    
    /// head-部分吸顶
    /// - Returns:
    func func_gotoToparea() -> Void {
        let toVC = topAreaPageVC()
        toVC.title = "topAreaPage"
        self.navigationController?.pushViewController(toVC, animated: true)
    }
    
    /// 列表选择结果联动
    /// - Returns:
    func func_gotoConbinVC() -> Void {
        let toVC = chooseConbinVC()
        toVC.title = "列表选择"
        self.navigationController?.pushViewController(toVC, animated: true)
    }
}
