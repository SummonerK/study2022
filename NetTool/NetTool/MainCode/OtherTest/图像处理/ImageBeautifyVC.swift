//
//  ImageBeautifyVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/1.
//

import UIKit
import CoreBluetooth

class BLETool{
    static let shared = BLETool()
    
    private let PeripheralsKeys = "PeripheralsKeys"
    private var arrayPeripherals:Array<BLEPeripheral> = Array<BLEPeripheral>()
    
    func setChoosedPeripheral(with peripheral: CBPeripheral){
//        let lkperipheral = BLEPeripheral(with: peripheral)
//        lkperipheral.name = peripheral.name ?? ""
//        arrayPeripherals.append(lkperipheral)
//
//
//
//        let cache = YYCache(name: "LoaclPeripheralCache")
//        cache?.setObject(lkperipheral, forKey: "LoaclPeripheral")
//        print(String(format: "%@-%@" ,peripheral.name ?? "",peripheral.macAddress))
    }
    
    func getLocalPeripherals() -> Array<BLEPeripheral> {
        return self.arrayPeripherals
    }
    
    func loadLoaclData() -> Void {
        let cache = YYCache(name: "LoaclPeripheralCache")
        guard let localPeripheral = cache?.object(forKey: "LoaclPeripheral") as? BLEPeripheral else {
            print("没有匹配缓存")
            return
        }
        print(localPeripheral.name)
        
//        guard let keyPeripheral = localPeripheral.keyPeripheral else{
//            print("没有取到 keyPeripheral")
//            return
//        }
//        print(String(format: "%@-%@" ,keyPeripheral.name ?? "",keyPeripheral.macAddress))
    }
    
}

//required init(coder aDecoder: NSCoder) {
//    self.idx   = aDecoder.decodeIntegerForKey( "idx"   )
//    self.stage = aDecoder.decodeObjectForKey(  "stage" ) as String    // ERROR
//}
//
//func encodeWithCoder(aCoder: NSCoder) {
//    aCoder.encodeInteger( self.idx,             forKey:"idx"   )
//    aCoder.encodeObject(  self.stage as String, forKey:"stage" )  // ERROR
//}

class BLEPeripheral: NSObject, NSCoding{
    var name:String = ""
    func encode(with coder: NSCoder) {
        coder.encodeConditionalObject(self.name, forKey: "keyPeripheralname")
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "keyPeripheralname") as? String ?? ""
    }
    
    override init(){
        super.init()
    }
}

class ImageBeautifyVC: UIViewController {
    @IBOutlet weak var imageV_show:UIImageView!
    @IBOutlet weak var bton_next:UIButton!
    var XWSdk : XWSdkManager!
    var peripheralArray:Array<CBPeripheral> = Array<CBPeripheral>()
    var linkDeviceArray:Array<XWDevice> = Array<XWDevice>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hexStringColor(hexString: "f5f5f5")
        //功能集合
        bton_next.jk.addActionClosure {[weak self] atap, aview, aint in
            guard let self = self else{return}
            self.showRegistFuncs()
        }
        
        let image = UIImage(named: "panda")
        let printImage = ImageManipulation.manipulation(with: image, andImageWidth: 384)
        imageV_show.image = printImage
        
        sdkXWStart()
        // Do any additional setup after loading the view.
    }
    
    func sdkXWStart() -> Void {
        XWSdk = XWSdkManager.shared()
        XWSdk.delegate = self
        XWSdk.start(withKey: "testSDKid001")
    }

}

extension ImageBeautifyVC:XWSdkManagerDelegate{
    func xwSdkManagerDidSearchDevice(with peripheral: CBPeripheral) {
        peripheralArray.append(peripheral)
        
        for peripheralItem:CBPeripheral in peripheralArray{
            print(String(format: "%@-%@" ,peripheralItem.name ?? "",peripheralItem.macAddress))
        }
        BLETool.shared.setChoosedPeripheral(with: peripheral)
    }
    
    func xwSdkManagerDidConnect(_ device: XWDevice) {
        linkDeviceArray.append(device)
    }
    
    func xwSdkManagerDidStopSearch() {
        print("xwSdkManagerDidStopSearch")
    }
    
    func xwSdkManagerDidStopPrint(with state: XWPrintStopState) {
        print("xwSdkManagerDidStopPrint")
    }
    
    func xwSdkManagerDidSendMessage(_ message: Any) {
        print("xwSdkManagerDidSendMessage")
    }
    
}

extension ImageBeautifyVC{
    // MARK: - 规范注释
    func showRegistFuncs() -> Void {
        let message = "弹窗"
        let alertC = UIAlertController.init(title: "打印机验证", message: message,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("搜索打印机", .default) {
            self.searchDevice()
        }
        alertC.addAction("链接打印机", .default) {
            self.linkDevice()
        }
        alertC.addAction("打印", .default) {
            self.devicePrint()
        }
        
        alertC.addAction("YYCache", .default) {
            self.testYYCache()
        }
        
        alertC.addAction("YYCache_load", .default) {
            self.testGetYYCache()
        }
    }
}

extension ImageBeautifyVC{
    func searchDevice() -> Void {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.XWSdk.searchDevice()
        }
    }
    
    func linkDevice() -> Void {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            BLETool.shared.loadLoaclData()
        }
    }
    
    func devicePrint() -> Void {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            
        }
    }
    
    func testYYCache() -> Void {
        let bleInfo = BLEPeripheral()
        bleInfo.name = "5C64-FAF7-40AE-9C21-D4933AF45B23"
        let cache = YYCache(name: "LoaclaaName")
        cache?.setObject(bleInfo, forKey: "LoaclPeripheral")
        
        
        let model = cache?.object(forKey: "LoaclPeripheral")
        guard let amodel = model as? BLEPeripheral else { return }
        print(amodel.name)
    }
    
    func testGetYYCache() -> Void {
        let cache = YYCache(name: "LoaclaaName")
        let model = cache?.object(forKey: "LoaclPeripheral")
        guard let amodel = model as? BLEPeripheral else { return }
        print(amodel.name)
    }
    
}
