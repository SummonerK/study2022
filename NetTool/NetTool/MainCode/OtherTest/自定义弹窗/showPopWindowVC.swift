//
//  showPopWindowVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/11/24.
//

import UIKit
import JFPopup

class showPopWindowVC: UIViewController {
    @IBOutlet weak var bton_next:UIButton!
    
    let showView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: IBScreenW, height: IBScreenW))
        view.backgroundColor = .randomColor
        return view
    }()
    
    let showViewSheet:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: IBScreenW, height: IBScreenW))
        view.backgroundColor = .randomColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "laixue://material?id=1&name=植物"
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let toUrl = URL(string: url) else {
            print("url 非法")
            return
        }
        print(toUrl.jk.queryParameters ?? [:])
        toUrl.jk.propertyDescription()
        
        
        self.view.backgroundColor = UIColor.hexStringColor(hexString: "f5f5f5")
        //功能集合
        bton_next.jk.addActionClosure {[weak self] atap, aview, aint in
            guard let self = self else{return}
            self.showRegistFuncs()
        }
        self.showView.jk.addActionClosure {[weak self] _, _, _ in
            guard let self = self else { return }
//            self.popup.dismissPopup(){
//                print("测试pop dismiss")
//                self.navigationController?.pushViewController(showPopWindowVC(), animated: true)
//            }
//            self.popup.dismissPopup()
//            print("测试pop dismiss")
//            self.navigationController?.pushViewController(showPopWindowVC(), animated: true)
            self.showSheet()
        }
    }

}

extension showPopWindowVC{
    // MARK: - 规范注释
    func showRegistFuncs() -> Void {
        let message = "弹窗"
        let alertC = UIAlertController.init(title: "常用弹窗", message: message,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("默认弹窗", .default) {
            self.showDilog()
        }
        alertC.addAction("底部弹窗", .default) {
            self.showSheet()
        }
        alertC.addAction("LFPop弹窗_center", .default) {
            self.diyPopWindow()
        }
        alertC.addAction("LFPop弹窗_bottom", .default) {
            self.diyPopWindowBottom()
        }
    }
}

extension showPopWindowVC{
    func showDilog() -> Void {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.popup.dialog(with: false) {
                return self.showView
            }
        }
    }
    
    func showSheet() -> Void {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.popup.bottomSheet {
                return self.showViewSheet
            }
        }
    }
    
    func diyPopWindow() -> Void {
        
        let viewContent = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        viewContent.backgroundColor = .randomColor
        
        let popWindow = PopWindowView.initPopWindowView(with: viewContent,type: .center,offSet: CGPoint(x: 0, y: -100))
        PopWindowView.showPopWindow(with: popWindow)
        
        viewContent.jk.addGestureTap { _ in
            PopWindowView.dismissPopWindow(with: popWindow)
        }
    }
    func diyPopWindowBottom() -> Void {
        
        let viewContent = UIView(frame: CGRect(x: 0, y: kscreenH-300, width: kscreenW, height: 300))
        viewContent.backgroundColor = .randomColor
        
        let popWindow = PopWindowView.initPopWindowView(with: viewContent,type: .bottom)
        PopWindowView.showPopWindow(with: popWindow)
        
        viewContent.jk.addGestureTap { _ in
            PopWindowView.dismissPopWindow(with: popWindow)
        }
    }
    
    func testTrans() -> Void {
        
    }
    
    //JSON字符串转换为数组(Array)
    func getArrayFromJSONString(_ jsonString:String) ->NSArray{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return array as! NSArray
    }
    
    //数组(Array)转换为JSON字符串
    func getJSONStringFromArray(_ array:NSArray) -> String {
        if (!JSONSerialization.isValidJSONObject(array)) {
            print("无法解析出JSON字符串")
            return String()
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}
