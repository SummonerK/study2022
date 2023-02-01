//
//  BlueToothHelp.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/17.
//

// MARK: - 蓝牙链接助手
import Foundation
import CoreBluetooth

@objc public protocol BBQBluetoothManagerDelegate : NSObjectProtocol {
    
    ///获取扫描设备
    @objc optional func getDevice(_ peripheral: CBPeripheral ,advertisementData :[String : Any])
    ///获取设备数据
    @objc optional func getDeviceData(_ peripheral: CBPeripheral, characteristic: CBCharacteristic)
    ///发现设备服务
    @objc optional func getDeviceCharacter(_ peripheral: CBPeripheral, service: CBService)
    ///断开连接设备
    @objc optional func offLinkDevice(_ peripheral: CBPeripheral)
    
}

typealias LMContinueBlock = (_ continueFlag:Bool)->Void

class BlueToothHelp: NSObject {
    static let shared = BlueToothHelp.setupBlueToothManager()
    weak var delegate : BBQBluetoothManagerDelegate?
    
    ///当前链接的设备
    var currentPeripheral: CBPeripheral?
    var writeChar: CBCharacteristic? // 写服务的特征值
    var readChar: CBCharacteristic? // 读服务的特征值
    
    private var cManager : CBCentralManager?//中心设备管理者
    var pidToDevice = false//是否根据设备id搜索
    var perId = ""//设备id
    var deviceLinkState = false//设备连接状态
    
    ///续写链接block
    var continueBlock:LMContinueBlock?
    
    
    static func setupBlueToothManager() -> BlueToothHelp{
        let helper = BlueToothHelp()
        helper.cManager = CBCentralManager(delegate: helper, queue: nil)
        helper.cManager?.stopScan()
        
        return helper
    }
    
    func setDelegateScan(_ viewController :UIViewController) {
        self.delegate = viewController as? BBQBluetoothManagerDelegate
    }
    
    func scanForServices() {
        print("开始扫描")
        cManager?.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
    }
    
    func stopScan() {
        print("停止扫描")
        cManager?.stopScan()
    }
    
    func linkDevice(_ peripheral: CBPeripheral) {
        print("链接蓝牙设备")
        if peripheral.state == .disconnected {
            cManager?.connect(peripheral)
        }
        if peripheral.state == .connected {
            deviceLinkState = false
            MBHud.showInfoWithMessage("蓝牙设备已被占用连接")
        }
    }
    
    func offLink(_ peripheral: CBPeripheral) {
        print("断开蓝牙设备")
        cManager?.cancelPeripheralConnection(peripheral)
    }
    
    func scanDeviceToId(_ peripheralId: String) {
        perId = peripheralId
        pidToDevice = true
        scanForServices()
    }
    
    /// 数据写入
    /// - Parameter data: 写入数据
    /// - Returns: 
    func writeData(with data:Data) -> Void {
        DispatchQueue.jk.async { [weak self] in
            guard let self = self else { return }
            guard let currentP = self.currentPeripheral else {
                MBHud.showInfoWithMessage("当前无设备链接")
                return
            }
            
            guard let writeC = self.writeChar else {
                MBHud.showInfoWithMessage("当前设备无写入服务")
                return
            }
            currentP.writeValue(data, for: writeC, type: .withoutResponse)
        }
    }
    
    func writeData(with data:Data,cblock: @escaping LMContinueBlock) -> Void {
        self.continueBlock = cblock
        guard let currentP = currentPeripheral else {
            MBHud.showInfoWithMessage("当前无设备链接")
            return
        }
        
        guard let writeC = writeChar else {
            MBHud.showInfoWithMessage("当前设备无写入服务")
            return
        }
        
        currentP.writeValue(data, for: writeC, type: .withoutResponse)
    }
}


extension BlueToothHelp:CBCentralManagerDelegate,CBPeripheralDelegate{
    
    //检测蓝牙设备
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOn:
            print("蓝牙开启")
            break
        case .unknown:
            print("蓝牙未知状态")
            break
        case .poweredOff:
            print("蓝牙关闭")
            stopScan()
            break
        default:
            print("蓝牙关闭")
            stopScan()
            break
        }
    }
    
    //扫描到数据
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        NSLog("扫描到数据UUID--%@", peripheral.identifier.uuidString)
//        print("扫描到数据%@",peripheral.name ?? "")
        self.delegate?.getDevice?(peripheral ,advertisementData: advertisementData)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("连接成功")
        self.currentPeripheral = peripheral
        deviceLinkState = true
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接失败")
        self.currentPeripheral = nil
        deviceLinkState = false
        MBHud.showInfoWithMessage("连接失败！")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("断开连接")
        deviceLinkState = false
        self.currentPeripheral = nil
        self.delegate?.offLinkDevice?(peripheral)
    }
    
    //发现服务回调
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for aService in peripheral.services! {
            LKPrint("service uuid1111 -- \(aService.uuid)")
            if aService.uuid.uuidString != "FFE6"{
                return
            }
            peripheral.discoverCharacteristics(nil, for: aService)
        }
    }
    
    //发现特征回调
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for aService in peripheral.services! {
            LKPrint("service uuid2222 -- \(aService.uuid)")
            if aService.uuid.uuidString != "FFE6"{
                return
            }
            if let characteristics = aService.characteristics{
                for character in characteristics{
                    LKPrint("characteristic uuid2222 -- \(character.uuid.uuidString)")
                    if character.uuid.uuidString == "FFE1"{
                        writeChar = character
                    }
                    if character.uuid.uuidString == "FFE2"{
                        readChar = character
//                        peripheral.readValue(for: readChar!)
//                        peripheral.readValue(for: readChar!)
                        peripheral.setNotifyValue(true, for: character)
                    }
                }
            }
        }
        
        self.delegate?.getDeviceCharacter?(peripheral, service: service)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    //接收
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("接收数据")
        LKPrint("\(characteristic.uuid.uuidString)")
        guard let data = characteristic.value else { return }
        let bytes: [UInt8] = [UInt8](data)
        let hexString = bytes.hexString
        LKPrint("\(hexString)")
//        5A 05 00 00 01 00 00 00 00 00 00 00
        if bytes.count >= 5{
            let tobytes = Array(bytes[0...4])
            if tobytes.hexString.jk.isHasPrefix(prefix: "5A 05"){
                if tobytes.hexString.jk.isHasSuffix(suffix: "01"){
                    self.continueBlock?(true)
                }else if tobytes.hexString.jk.isHasSuffix(suffix: "00"){
                    self.continueBlock?(false)
                }
            }
        }
        
        self.delegate?.getDeviceData?(peripheral, characteristic: characteristic)
    }
    
    //向Characteristic值写数据时回调的方法
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("写入成功")
    }
    
    //写Characteristic描述信息时触回调的方法
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        print("设备更新成功")
    }
}
//didUpdateValueForCharacteristic
//readValue
