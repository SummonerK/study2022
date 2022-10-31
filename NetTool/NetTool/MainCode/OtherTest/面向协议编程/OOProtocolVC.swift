//
//  OOProtocolVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/10/26.
//

import UIKit

class OOProtocolVC: UIViewController {
    
    @IBOutlet weak var bton_next:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        testOOProtocal(value: "1.590")
        testOOProtocal(value: "2.9")
        testOOProtocal(value: "9")
        testOOProtocal(value: "5")
        
        bton_next.jk.addActionClosure { atap, aview, aint in
            self.todayPop()
        }

        // Do any additional setup after loading the view.
    }
    
    func testOOProtocal(value base: String) -> Void {
        print("baseValue -- \(base)")
        print("intValue -- \(String(describing: base.intValue ?? 0))")
        print("doubleValue -- \(String(describing: base.doubleValue ?? 0.0))")
        print("floatValue -- \(String(describing: base.floatValue ?? 0.0))")
        print("-------------------end-----------------------\n")
    }
    
    func todayPop() -> Void {
        let today = Date().jk.dateFromGMT()
        let str_today = today.jk.toformatterTimeString(formatter:"yyyy-MM-dd")
        print(today)
        print(str_today)
    }

}


protocol baseStringConvertible {
    var intValue:Int? { get }
    var doubleValue:Double? { get }
    var floatValue:Float? { get }
}

extension String:baseStringConvertible{
    public var intValue: Int? {
        if let floatValue = self.floatValue{
            return Int(floatValue)
        }
        return nil
    }
    
    public var doubleValue: Double? {
        return Double(self)
    }
    
    public var floatValue: Float? {
        return Float(self)
    }
    
    
}


