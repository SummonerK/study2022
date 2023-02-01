//
//  FullTextShowVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/7.
//

import UIKit
import SwiftyJSON

func getJsonFile(_ name: String) -> Data?{
    var type: String? = "json"
    if name.contains("json") {
        type = nil
    }
    guard let path = Bundle.main.path(forResource: name, ofType: type) else {
        return nil
    }
    do {
        return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    } catch {
        return nil
    }

}

func unicodeString(_ str: String) -> String {
    let mutableStr = NSMutableString(string: str) as CFMutableString
    CFStringTransform(mutableStr, nil, "Any-Hex/Java" as CFString, true)
    return mutableStr as String
}

class FullTextShowVC: UIViewController {
    
    @IBOutlet weak var textV_main:UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringColor(hexString: "f5f5f5")
        
        textV_main.textContainer.lineFragmentPadding = 0.0
        textV_main.backgroundColor = .clear
        textV_main.isUserInteractionEnabled = false
        
        let fulldata = getJsonFile("full") ?? Data()
        
        guard let dic = dataToDictionary(data: fulldata) else{
            print("解析失败")
            return
        }
        
        guard let transString = dic["detailDefineList"] as? String else{
            print("解析失败")
            return
        }
        
        guard let arrayString = dic["dics"] as? String else{
            print("解析失败")
            return
        }

//        ///CFStringTransform 转码
//        let uncodeTrans = unicodeString(arrayString)
//
//        guard let transformStr = arrayString.applyingTransform(StringTransform(rawValue: "Any-Hex/Java"), reverse: true) else {
//            return
//        }
//
//        textJsonarrayString(with: uncodeTrans)
//
//        let fullTrans = transString.jk.setHtmlAttributedString()
//
//        textV_main.attributedText = fullTrans

    }
    
    func textJsonarrayString(with toString:String) -> Void {
        
        ///系统解析
        let jsonString = toString
        let jsonData = jsonString.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        
        ///jk解析
        let jkTrans = jsonString.jk.jsonStringToArray()
        
        guard let jkTrans = jsonString.jk.jsonStringToArray() as? [String] else { return }
        
        
    }

}
