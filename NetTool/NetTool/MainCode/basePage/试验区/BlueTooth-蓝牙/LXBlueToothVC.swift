//
//  LXBlueToothVC.swift
//  NetTool
//
//  Created by luoke_ios on 2022/12/17.
//

import UIKit
import CoreBluetooth

class LXBlueToothVC: UIViewController {
    @IBOutlet weak var imageV_result:UIImageView!
    @IBOutlet weak var bton_next:UIButton!
    @IBOutlet weak var tableV_main:UITableView!
    var arrayPeripherals = [CBPeripheral]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexStringColor(hexString: "F5F5F5")
        //功能集合
        bton_next.jk.setHandleClick {[weak self] button in
            guard let self = self else{return}
            self.showRegistFuncs()
        }
        
        setupBluetoothService()
        setUpTableView()
    }
    
    func setupBluetoothService() -> Void {
        BlueToothHelp.shared.setDelegateScan(self)
    }
    
    /// 蓝牙搜索
    /// - Returns:
    func bluetooth_search() -> Void {
        BlueToothHelp.shared.scanForServices()
    }
    /// 蓝牙搜索 - 停止搜索
    /// - Returns:
    func bluetooth_searchStop() -> Void {
        BlueToothHelp.shared.stopScan()
    }
    
    /// 蓝牙 - 链接
    /// - Returns:
    func bluetooth_connect(with peripheral:CBPeripheral) -> Void {
        BlueToothHelp.shared.stopScan()
        BlueToothHelp.shared.linkDevice(peripheral)
    }
    
    func bluetooth_disconnect() -> Void {
        guard let currentP = BlueToothHelp.shared.currentPeripheral else {
            MBHud.showInfoWithMessage("当前无设备链接")
            return
        }
        BlueToothHelp.shared.stopScan()
        BlueToothHelp.shared.offLink(currentP)
    }
    
    /// 蓝牙 - 写入 - - -
    /// - Returns:
    func bluetooth_write() -> Void {
        let data_head = getWriteHead()
        let data_begin = Data.init(data_head)
        BlueToothHelp.shared.writeData(with: data_begin)
        ///写入数据
        wirteDataBoday()
        
        let data_end = getWriteEnd()
        let dataEdn = Data.init(data_end)
        BlueToothHelp.shared.writeData(with: dataEdn)
    }
    /// 蓝牙 - 写入 - - -
    /// - Returns:
    func bluetooth_write96() -> Void {
        let data_head = getWriteHead()
        let data_begin = Data.init(data_head)
        BlueToothHelp.shared.writeData(with: data_begin)
        ///写入数据
        wirteDataBody96()
//        let image = UIImage(named: "print_panda_10")
//        guard let toImage = image else { return }
//        guard let bytes = self.getImageData(with: toImage) else { return }
//        let datas = self.transData96(with: bytes)
//
//        LXDevice.shared.writeLineTwoByteFullData(with: datas) { success in
//            if success{
//                LKPrint("打印图片完成")
//            }
//        }
    }
    
    func bluetooth_write_imageTransTest() -> Void {
        guard let bytes = self.getImageData30() else { return }
        let datas = self.transData(with: bytes)
        ///任务总包数
//        let totalTaskCount = datas.count
        
        var arrayTrans = Array<UInt8>()
        
        for i in 0..<datas.count{
            arrayTrans.appends(datas[i])
        }
        
//        LKPrint("分组个数--- \(totalTaskCount)")
        
        let result = String(format: "%@", arrayTrans.hexString)
        
        print(result)
        
    }
    
    /// 蓝牙 - 写入 : 图像
    /// - Returns:
//        let testBytes:Array<UInt8> = [0,1,2,3,4,5,6,7,8,
//                                    9,10,11,12,13,14,15,16]
//        let datas = self.transData(with: testBytes)
    
    func bluetooth_write_image30() -> Void{
        ///例 总byte 5723
        /// 16 task byte 分组 358
        guard let bytes = self.getImageData30() else { return }
        let datas = self.transData(with: bytes)
        ///任务总包数
        let totalTaskCount = datas.count
        let group = DispatchGroup()
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        let semaphoreLock = DispatchSemaphore(value: 4)
        
        LKPrint("totalTaskCount \(totalTaskCount)")

        let head: [UInt8] = [0x5A, 0x04]
        let serialNumber = totalTaskCount.hw_to2Bytes()
        let headData: [UInt8] = head + serialNumber + [0]
        let data_begin = Data.init(headData)
        BlueToothHelp.shared.writeData(with: data_begin)
        ///写入数据体
        for i in 0..<datas.count{
            semaphoreLock.wait() ///上锁🔒
            queue.async(group: group) {
                let head: [UInt8] = [0x55] ///包头 和序号
//                let taskNum = totalTaskCount - i - 1
                let serialNumber = i.hw_to2Bytes()
                let taskData: [UInt8] = head + serialNumber + datas[i]
                let dataFrom = Data.init(taskData)
                currentThreadSleep(seconds: 0.05)
                BlueToothHelp.shared.writeData(with: dataFrom)
                print("\(getCurrentThread())--\ntask:\(i)执行完成✅")
                semaphoreLock.signal() ///开锁 🔓
            }
        }
        group.notify(queue: queue){
            //group执行完成了
            currentThreadSleep(seconds: Double(1))
            print("写入尾部内容")
            queue.async{
                let head: [UInt8] = [0x5A, 0x04]
                let serialNumber = totalTaskCount.hw_to2Bytes()
                let endData: [UInt8] = head + serialNumber + [1]
                let data_finish = Data.init(endData)
                BlueToothHelp.shared.writeData(with: data_finish)
            }
        }
    }
    
    func bluetooth_write_withLXDevice() -> Void {
        let image = UIImage(named: "print_panda_10")
        LXDevice.shared.devicePrint(source: image, repeatTimes: 5)
    }
    
    /// 96byte/包--写入协议
    /// - Returns:
    func bluetooth_write_image96() -> Void{
        ///例 总byte 960
        /// 96 task byte 分组 10
//        guard let image = UIImage(named: "print_QR") else { return }
//        guard let bytes = self.getImageData(with: image) else { return }
//        let datas = self.transData96(with: bytes)
        
        ///本地图片数据
        let bytes = getLocalData()
        let datas = self.transData96(with: bytes)
        ///任务总包数
        let totalTaskCount:Int = datas.count
        LKPrint("totalTaskCount \(totalTaskCount)")

        let head: [UInt8] = [0x5A, 0x04]
        let serialNumber = totalTaskCount.hw_to2Bytes()
        let headData: [UInt8] = head + serialNumber + [0]
        let data_begin = Data.init(headData)
        BlueToothHelp.shared.writeData(with: data_begin)
        currentThreadSleep(seconds: 0.05)
        writeLineTwoByteData(with: datas, index: 0)
       
    }
    
    
    func getLocalData() -> [UInt8] {
        let arrayString = loacalString.components(separatedBy: " ")
        let arrayMap:[UInt8] = arrayString.map { (item:String) in
            return UInt8(item.jk.hexInt.jk.intToUInt)
        }
        return arrayMap
    }
    
    /// 96byte/包--写入协议
    /// 写入 一包数据
    /// - Parameters:
    ///   - array:
    ///   - index:
    /// - Returns:
    func writeLineTwoByteData(with array:[[UInt8]],index:Int) -> Void {
        let totalTaskCount:Int = array.count
        let head: [UInt8] = [0x55] ///包头 和序号
        let serialNumber = index.hw_to2Bytes()
        let taskData: [UInt8] = head + serialNumber + array[index] + [0]
        let dataFrom = Data.init(taskData)
//        currentThreadSleep(seconds: 0.05)
        BlueToothHelp.shared.writeData(with: dataFrom) { [weak self] continueFlag in
            guard let self = self else { return }
            if continueFlag{
                LKPrint("写入数据---index---\(index)")
                if index < array.count-1{
                    self.writeLineTwoByteData(with: array, index: index+1)
                }else{
                    let head: [UInt8] = [0x5A, 0x04]
                    let serialNumber = totalTaskCount.hw_to2Bytes()
                    let endData: [UInt8] = head + serialNumber + [1]
                    let data_finish = Data.init(endData)
                    BlueToothHelp.shared.writeData(with: data_finish)
                }
            }
        }
    }
    
    /// 打印图片
    /// - Returns: 协议 - 16byte-个包
    func bluetooth_write_image() -> Void {
        ///例 总byte 5723
        /// 16 task byte 分组 358
        guard let bytes = self.getImageData() else { return }
        let datas = self.transData(with: bytes)
        ///任务总包数
        let totalTaskCount = datas.count
        let group = DispatchGroup()
        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_concurrent_00")
        let semaphoreLock = DispatchSemaphore(value: 4)

        let head: [UInt8] = [0x5A, 0x04]
        let serialNumber = totalTaskCount.hw_to2Bytes()
        let headData: [UInt8] = head + serialNumber + [0]
        let data_begin = Data.init(headData)
        BlueToothHelp.shared.writeData(with: data_begin)
        ///写入数据体
        for i in 0..<datas.count{
            semaphoreLock.wait() ///上锁🔒
            queue.async(group: group) {
                let head: [UInt8] = [0x55] ///包头 和序号
//                let taskNum = totalTaskCount - i - 1
                let serialNumber = i.hw_to2Bytes()
                let taskData: [UInt8] = head + serialNumber + datas[i]
                let dataFrom = Data.init(taskData)
                currentThreadSleep(seconds: 0.05)
                BlueToothHelp.shared.writeData(with: dataFrom)
                print("\(getCurrentThread())--\ntask:\(i)执行完成✅")
                semaphoreLock.signal() ///开锁 🔓
            }
        }
        group.notify(queue: queue){
            //group执行完成了
            currentThreadSleep(seconds: Double(1))
            print("写入尾部内容")
            queue.async{
                let head: [UInt8] = [0x5A, 0x04]
                let serialNumber = totalTaskCount.hw_to2Bytes()
                let endData: [UInt8] = head + serialNumber + [1]
                let data_finish = Data.init(endData)
                BlueToothHelp.shared.writeData(with: data_finish)
            }
        }
        
    }
    
    func getWriteHead() -> [UInt8]{
        let head : [UInt8] = [0x5A, 0x04, 0x00, 0x05, 0]
        return head
    }
    
    func getWriteEnd() -> [UInt8]{
        let head : [UInt8] = [0x5A, 0x04, 0x00, 0xFF, 1]
        return head
    }
    
    func wirteDataBoday() -> Void {
        for i in 0..<3{
            let data_with = getLineData(with: i)
            let dataFrom = Data.init(data_with)
            BlueToothHelp.shared.writeData(with: dataFrom)
        }
    }
    func wirteDataBody96() -> Void {
        let data_with = getLineData96(with: 0)
        let dataFrom = Data.init(data_with)
//        BlueToothHelp.shared.writeData(with: dataFrom)
        BlueToothHelp.shared.writeData(with: dataFrom) { [weak self] continueFlag in
            guard let self = self else { return }
            if continueFlag{
                LKPrint("开始打印下一个包")
                let data_end = self.getWriteEnd()
                let dataEdn = Data.init(data_end)
                BlueToothHelp.shared.writeData(with: dataEdn)
            }
        }
    }
    
    ///写入 一条线
    func getLineData(with num:Int) -> [UInt8] {
        let head : [UInt8] = [0x55] ///包头 和序号
        let serialNumber = num.hw_to2Bytes()
        LKPrint(serialNumber)
        let inData : [UInt8] = [0x00,0x00,0x00,0x00,
                                0x00,0x00,0x00,0x00,
                                0xFF,0xFF,0xFF,0xFF,
                                0xFF,0xFF,0xFF,0xFF]
        return head + serialNumber + inData
    }
    
    func getLineData96(with num:Int) -> [UInt8]  {
        let head : [UInt8] = [0x55] ///包头 和序号
        let serialNumber = num.hw_to2Bytes()
        LKPrint(serialNumber)
        let inData : [UInt8] = [0x00,0x00,0x00,0x00,
                                0x00,0x00,0x00,0x00,
                                0xFF,0xFF,0xFF,0xFF,
                                0xFF,0xFF,0xFF,0xFF]
        let lineData = inData + inData + inData
        return head + serialNumber + lineData + lineData + [0]
    }
    
    func getLineData48() -> [UInt8]{
        let inData : [UInt8] = [0,0,0,0,
                                0,0,0,0,
                                0,0,0,0,
                                0,0,0,0]
        
        return inData + inData + inData
    }

}

extension Array where Element == UInt8 {
    var hexString: String {
        return self.compactMap { String(format: "%02x", $0).uppercased() }
        .joined(separator: " ")
    }
}

// MARK: - 图像处理
///数据体长度
private let serialNumbCount = 16
extension LXBlueToothVC{
    
    func getImageWithData() -> Void{
//        let data
    }
    
    func getImageData() -> [UInt8]? {
        let image = UIImage(named: "print_panda_10")
//        let image = UIImage(named: "PrintLine")
//        let image = UIImage.jk.image(color: .white,size: CGSize.init(width: 384, height: 10))
        guard let transData = ImageManipulation.lk_byteMap(with: image, andImageWidth: 384) else { return nil}
        
        let finalImage = UIImage(data: transData)
        
        imageV_result.image = finalImage
        
        let bytes: [UInt8] = [UInt8](transData)
        
        let resutBytes = Array(bytes[62...bytes.count-1])
        
        return resutBytes
    }
    func getImageData30() -> [UInt8]? {
        let image = UIImage(named: "print_panda_30")
//        let image = UIImage(named: "print_QR")
//        let image = UIImage(named: "PrintLine")
//        let image = UIImage.jk.image(color: .white,size: CGSize.init(width: 384, height: 10))
        guard let transData = ImageManipulation.lk_byteMap(with: image, andImageWidth: 384) else { return nil}
        
        let finalImage = UIImage(data: transData)
        
        imageV_result.image = finalImage
        
        let bytes: [UInt8] = [UInt8](transData)
        
        let resutBytes = Array(bytes[62...bytes.count-1])
//        LKPrint(resutBytes)
//        let result = String(format: "%@", resutBytes.hexString)
//
//        print(result)
        
        return resutBytes
    }
    
    /// 根据图片获取图片数据
    /// - Parameter image:
    /// - Returns:
    func getImageData(with image:UIImage) -> [UInt8]? {
        guard let transData = ImageManipulation.lk_byteMap(with: image, andImageWidth: 384) else { return nil}
        let finalImage = UIImage(data: transData)
        imageV_result.image = finalImage
        let bytes: [UInt8] = [UInt8](transData)
        let resutBytes = Array(bytes[62...bytes.count-1])
        return resutBytes
    }
    
    func trans16(with baseArray:[UInt8]) -> [UInt16]? {
//        var newArray:[UInt16] = baseArray.map { UInt16($0) }
//        return newArray
        let numBytes = baseArray.count
        var byteArrSlice = baseArray[0..<numBytes]
        var newArray = Array<UInt16>(repeating: 0, count: numBytes/2)
        
        for i in (0..<numBytes/2).reversed(){
            newArray[i] = UInt16(byteArrSlice.removeLast()) + UInt16(byteArrSlice.removeLast()) << 8
        }
        
        return newArray
    }
    
//    func byteArrToUInt16(byteArr: [UInt8]) -> [UInt16]? {
//        let numBytes = byteArr.count
//        var byteArrSlice = byteArr[0..<numBytes]
//        guard numBytes % 2 == 0 else { return nil }
//
//        var arr = [UInt16](count: numBytes/2, repeatedValue: 0)
//        for i in (0..<numBytes/2).reverse() {
//            arr[i] = UInt16(byteArrSlice.removeLast()) +
//                     UInt16(byteArrSlice.removeLast()) << 8
//        }
//        return arr
//    }
    
    func taskWriteData(withNum:Int, data:[UInt8]) -> [UInt8] {
        let head : [UInt8] = [0x55] ///包头 和序号
        let serialNumber = withNum.hw_to2Bytes()
        return head + serialNumber + data
    }
    
    func transData(with fullBytes:[UInt8]) -> [[UInt8]] {
        if fullBytes.count < serialNumbCount{
            var arrayTemp:Array<UInt8> = Array<UInt8>()
            arrayTemp.appends(fullBytes)
            let faceCount = arrayTemp.count
            for _ in faceCount..<serialNumbCount{
                arrayTemp.append(0x00)
            }
            return [arrayTemp]
        }
        
        // 整行 48 byte， 打印图片需要倒置数据
        // 数据行数
        let total_count = fullBytes.count/serialNumbCount/3
//        let lastSingleValue = fullBytes.count%serialNumbCount != 0
        
        // 整行 48 byte， 打印图片需要倒置数据
        var targetList: [[UInt8]] = []
        for i in 0..<total_count {
            let forLineIndex = total_count-1-i
            let lineFromIndex = forLineIndex * 3 * serialNumbCount
            var lineDataList: [[UInt8]] = []
            for j in 0..<3{
                let firstIndex = (j * serialNumbCount) + lineFromIndex
                let subList = Array(fullBytes[firstIndex...firstIndex+serialNumbCount-1])
                lineDataList.append(subList)
            }
//            let firstIndex = i * serialNumbCount
//            let subList = Array(fullBytes[firstIndex...firstIndex+serialNumbCount-1])
//            targetList.append(subList)
            targetList.appends(lineDataList)
        }
        
        //非整除，最后一组需要补0
//        if lastSingleValue {
//            let fromIndex = total_count*serialNumbCount
//            var arrayTemp:Array<UInt8> = Array<UInt8>()
//            for i in fromIndex..<fullBytes.count{
//                arrayTemp.append(fullBytes[i])
//            }
//            let faceCount = arrayTemp.count
//            for _ in faceCount..<serialNumbCount{
//                arrayTemp.append(0x00)
//            }
//            targetList.append(arrayTemp)
//        }
        
        return targetList
    }
    
    // MARK: - 96byte 数据协议
    func transData96(with fullBytes:[UInt8]) -> [[UInt8]] {
        if fullBytes.count < serialNumbCount{
            var arrayTemp:Array<UInt8> = Array<UInt8>()
            arrayTemp.appends(fullBytes)
            let faceCount = arrayTemp.count
            for _ in faceCount..<serialNumbCount{
                arrayTemp.append(0x00)
            }
            return [arrayTemp]
        }
        
        // 数据行数
        let total_count = fullBytes.count/serialNumbCount/3
        // 整行 48 byte， 打印图片需要倒置数据
        let piceNumbCount = 3 * serialNumbCount
        var targetLineList: [[UInt8]] = []
        for i in 0..<total_count {
            let forLineIndex = total_count-1-i
            let lineFromIndex = forLineIndex * piceNumbCount
            let subList = Array(fullBytes[lineFromIndex...lineFromIndex+piceNumbCount-1])
            targetLineList.append(subList)
        }
        
        if targetLineList.count%2 == 1{
            targetLineList.append(getLineData48())
        }
        
        /// 每包2行数据，所以任务数为count/2
        let lineNum = Double(targetLineList.count)/2
        let totalTask:Int = Int(ceil(lineNum))
        
        var targetCombinList: [[UInt8]] = []
        
        for j in 0..<totalTask{
            let item1 = targetLineList[2*j]
            let item2 = targetLineList[2*j+1]
            targetCombinList.append(item1+item2)
        }
        
        return targetCombinList
    }
}

extension Int{
    // MARK:- 转成 2位byte
    func hw_to2Bytes() -> [UInt8] {
        let UInt = UInt16.init(Double.init(self))
        return [UInt8(truncatingIfNeeded: UInt >> 8),UInt8(truncatingIfNeeded: UInt)]
    }
    // MARK:- 转成 4字节的bytes
    func hw_to4Bytes() -> [UInt8] {
        let UInt = UInt32.init(Double.init(self))
        return [UInt8(truncatingIfNeeded: UInt >> 24),
                UInt8(truncatingIfNeeded: UInt >> 16),
                UInt8(truncatingIfNeeded: UInt >> 8),
                UInt8(truncatingIfNeeded: UInt)]
    }
    // MARK:- 转成 8位 bytes
    func intToEightBytes() -> [UInt8] {
        let UInt = UInt64.init(Double.init(self))
        return [UInt8(truncatingIfNeeded: UInt >> 56),
            UInt8(truncatingIfNeeded: UInt >> 48),
            UInt8(truncatingIfNeeded: UInt >> 40),
            UInt8(truncatingIfNeeded: UInt >> 32),
            UInt8(truncatingIfNeeded: UInt >> 24),
            UInt8(truncatingIfNeeded: UInt >> 16),
            UInt8(truncatingIfNeeded: UInt >> 8),
            UInt8(truncatingIfNeeded: UInt)]
    }
}

extension LXBlueToothVC: BBQBluetoothManagerDelegate{
    
    func getDevice(_ peripheral: CBPeripheral ,advertisementData :[String : Any]) {
        guard let name = peripheral.name else{ return }
        if name.contains("LX-D01"){
            arrayPeripherals.append(peripheral)
            let peripheral_name = peripheral.name ?? ""
            let peripheral_mac = peripheral.macAddress ?? ""
            let peripheral_rssi = peripheral.rssi ?? 0
            let peripheral_uuid = peripheral.identifier.uuidString 
            LKPrint("发现搜索设备")
            LKPrint("name:\t\(peripheral_name)")
            LKPrint("mac:\t\(peripheral_mac)")
            LKPrint("rssi:\t\(peripheral_rssi)")
            LKPrint("uuid:\t\(peripheral_uuid)")
            
            for service:CBService in peripheral.services ?? []{
                LKPrint("service -- \(service.uuid)")
            }
            LKPrint(advertisementData)
            
            DispatchQueue.jk.asyncDelay(0.4) {} _: {[weak self] in
                guard let self = self else { return }
                self.tableV_main.reloadData()
            }
        }
    }
}

extension LXBlueToothVC{
    // MARK: - 规范注释
    func showRegistFuncs() -> Void {
        let alertC = UIAlertController.init(title: "功能测试", message: nil,preferredStyle: .actionSheet)
        registAlertCActions(withAlertC: alertC)
        alertC.addAction("确定", .cancel) {}
        alertC.show()
    }
    
    func registAlertCActions(withAlertC alertC:UIAlertController)->Void{
        alertC.addAction("蓝牙搜索-开始🚀", .default) {
            self.bluetooth_search()
        }
        alertC.addAction("蓝牙搜索-停止🔒", .default) {
            self.bluetooth_searchStop()
        }
        alertC.addAction("蓝牙链接-断开链接🔒", .default) {
            self.bluetooth_disconnect()
        }
//        alertC.addAction("蓝牙-写入✏️: - - -", .default) {
//            self.bluetooth_write()
//        }
//        alertC.addAction("蓝牙-写入✏️: 图像-10", .default) {
//            self.bluetooth_write_image()
//        }
//        alertC.addAction("蓝牙-写入✏️: 图像-30", .default) {
//            self.bluetooth_write_image30()
//        }
        alertC.addAction("蓝牙-写入-96✏️: - - -", .default) {
            self.bluetooth_write96()
        }
//        alertC.addAction("蓝牙-写入-96✏️: 图像", .default) {
//            self.bluetooth_write_image96()
//        }
        
        alertC.addAction("蓝牙-写入-封装📦", .default) {
            self.bluetooth_write_withLXDevice()
        }
        
//        alertC.addAction("测试-写入✏️: 图像转化", .default) {
//            self.bluetooth_write_imageTransTest()
////            self.getImageData30()
//        }
    }
}


let loacalString = "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 c0 01 e0 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 03 80 70 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 06 00 38 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 38 0c 00 1c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0c 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 18 0c 00 0c 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0e 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 38 0c 00 0e 01 dc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 0c 00 0e 01 dc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f e0 0c 00 0c 00 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 0c 00 0c 00 7c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 04 00 1c 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 00 06 00 38 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 f0 03 80 70 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 f0 01 e0 e0 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 03 c0 f0 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 03 c1 e0 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 03 00 38 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 07 00 70 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 06 00 18 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 78 0e 00 38 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 38 0c 00 1c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1c 38 0c 00 18 07 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 18 0c 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 1c 00 08 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 18 0c 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 18 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0e 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 18 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 38 0c 00 0e 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 78 18 00 0c 03 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 0c 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 18 00 0c 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f e0 0c 00 0c 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f e0 1c 00 0c 03 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 0c 00 0c 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 1c 00 18 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 06 00 1c 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 0c 00 38 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 f0 07 00 38 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 0e 00 70 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 f0 03 80 70 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 f0 07 00 e0 01 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c1 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e1 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 c3 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 03 c0 f0 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 07 80 e0 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 07 00 38 03 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 0f 00 70 07 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 38 06 00 1c 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1e 78 0e 00 38 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 38 0c 00 0c 03 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 38 1c 00 18 01 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 18 0c 00 0c 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 1c 00 0c 00 f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 18 00 0c 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0e 00 1e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 18 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 0c 00 0e 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1e 78 18 00 0c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f e0 0c 00 0c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f e0 18 00 0c 00 1e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 0c 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 1c 00 08 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 0c 00 1c 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 0c 00 18 03 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 06 00 18 03 9e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 0e 00 38 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 f0 07 00 38 01 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 f0 07 00 70 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 f0 03 c0 f0 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 f0 07 c1 e0 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c1 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 03 80 70 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 07 00 70 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 06 00 38 03 9e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 78 0e 00 30 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 38 0e 00 1c 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1c 38 0c 00 18 03 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08 38 0c 00 0c 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 1c 00 18 01 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 18 0c 00 0c 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 1c 00 0c 00 f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0e 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 18 00 0c 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 0c 00 0e 00 7e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 18 00 0c 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 0c 00 0e 00 7c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 18 00 0c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0c 00 0c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 18 00 0c 00 1e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 30 0c 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 1c 00 08 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 30 04 00 1c 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1c 38 0c 00 18 07 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 06 00 38 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 0e 00 30 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 03 80 70 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 07 00 70 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c0 01 c0 e0 00 f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c0 03 c1 e0 00 f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 03 e0 f0 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 03 c1 e0 00 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 f0 03 00 38 01 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 07 00 70 00 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 78 06 00 18 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 78 0e 00 38 00 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 38 0c 00 1c 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1c 38 0c 00 18 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 18 0c 00 0c 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 1c 00 08 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 18 0c 00 0c 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 18 00 0c 07 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0e 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 78 18 00 0c 03 98 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 0c 00 0e 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 18 00 0c 01 98 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 0c 00 0e 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 18 00 0c 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0c 00 0c 03 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 1c 00 0c 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 30 0c 00 0c 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 38 1c 00 18 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 30 06 00 1c 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 70 0c 00 18 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 07 00 38 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 0e 00 30 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 03 80 70 01 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 07 00 70 00 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c1 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e3 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 c3 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 60 03 c0 f0 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 07 80 e0 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 07 00 38 03 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 0f 00 70 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 06 00 1c 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1c 78 0e 00 38 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f8 0c 00 1c 03 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 38 1c 00 18 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 0c 00 0c 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 1c 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 0c 00 0c 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 18 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 0c 00 0e 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 78 18 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 70 0c 00 0e 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 18 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 f0 0c 00 0c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 18 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 f0 0c 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 1c 00 08 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 0c 00 1c 03 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 38 0c 00 18 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 06 00 18 03 9e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 0e 00 38 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 07 00 38 01 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 07 00 70 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 60 03 c0 f0 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 07 81 e0 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e1 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c1 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 03 80 70 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 07 00 70 00 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 07 00 38 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0e 00 30 00 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0e 00 1c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0c 00 18 00 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 0c 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 1c 00 18 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 0c 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 1c 00 0c 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 0c 00 0e 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 70 18 00 0c 03 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f 70 0c 00 0e 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 18 00 0c 03 98 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 70 0c 00 0e 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 70 18 00 0c 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 f0 0c 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 f0 18 00 0c 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 0c 00 0c 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 1c 00 08 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 04 00 1c 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 0c 00 18 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 06 00 38 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 0e 00 30 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 03 80 78 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 07 00 70 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 20 03 c0 f0 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 60 03 c1 e0 00 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 20 03 e0 f0 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 60 03 c1 e0 07 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 03 80 78 01 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 07 00 70 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 06 00 38 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0e 00 38 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0c 00 1c 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0c 00 18 03 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 0c 00 0c 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 1c 00 08 01 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1e f0 0c 00 0c 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1c 70 18 00 0c 00 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 0c 00 0e 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 18 00 0c 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 70 0c 00 0e 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 18 00 0c 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 f0 0c 00 0e 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 70 18 00 0c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 f0 0c 00 0c 03 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 f0 1c 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 0c 00 0c 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 1c 00 18 02 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 06 00 1c 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f0 0c 00 18 07 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 07 00 38 01 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 0e 00 30 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 03 80 70 01 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 07 00 70 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c1 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 03 c0 f0 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0 07 c1 e0 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 07 00 38 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 07 00 70 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 06 00 1c 03 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0e 00 38 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 1c 01 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 1c 00 18 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0c 00 f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 1c 00 08 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0c 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0e 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0e 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 0c 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 e0 1c 00 08 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 0c 00 1c 03 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 0c 00 18 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 06 00 18 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 0e 00 38 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 07 00 38 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 07 00 70 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 03 c0 f0 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0 07 80 e0 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e1 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c1 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 03 80 70 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 07 00 70 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 07 00 38 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0e 00 30 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0e 00 1c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 18 03 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0c 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 1c 00 18 02 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0c 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 1c 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0e 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0e 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 00 7c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0e 01 dc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0c 00 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 0c 00 0c 00 7c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e e0 1c 00 08 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 04 00 1c 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 0c 00 18 03 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 06 00 38 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 0e 00 30 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 03 80 78 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 07 00 70 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 40 03 c0 f0 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0 03 c1 e0 00 f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 03 e0 f0 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0 03 c1 e0 00 f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 03 80 78 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 07 00 70 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 06 00 38 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0e 00 30 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 00 0c 00 1c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 18 07 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 80 0c 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 1c 00 08 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 c0 0c 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0e 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0c 00 0e 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 03 1e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0c 00 0e 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0c 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 e0 1c 00 0c 03 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08 38 0c 00 0c 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 1c 00 18 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 38 06 00 1c 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 0c 00 18 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 06 00 38 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 0e 00 30 03 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 03 80 70 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 07 00 70 01 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c1 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 03 c0 f0 00 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 07 c1 e0 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 07 00 38 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 07 00 70 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f 00 06 00 1c 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 0e 00 38 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 80 0c 00 1c 03 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 00 1c 00 18 01 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c0 0c 00 0c 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 80 1c 00 08 00 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 c0 0c 00 0c 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 c0 18 00 0c 00 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 0c 00 0e 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 18 00 0c 00 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0c 00 0e 03 8e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 18 00 0c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0c 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 78 18 00 0c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0c 03 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 1c 00 08 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 38 0c 00 1c 03 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 38 0c 00 18 03 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 30 06 00 18 01 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1c 78 0e 00 38 03 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 07 00 38 01 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 07 00 70 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 03 c0 f0 01 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 e0 07 80 e0 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e1 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c1 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 03 80 70 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f f8 07 00 70 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 07 00 38 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f e0 0e 00 30 03 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f 00 0e 00 1c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00 0c 00 18 03 1e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 80 0c 00 0c 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 80 1c 00 18 02 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c0 0c 00 0c 07 fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c0 1c 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 0c 00 0e 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 e0 18 00 0c 00 0e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 0c 00 0e 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 18 00 0c 00 7c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 0c 00 0e 01 dc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 70 18 00 0c 00 78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0c 00 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 18 00 0c 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 0c 00 0c 00 7c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 1c 00 08 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 38 04 00 1c 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1c 38 0c 00 18 03 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 06 00 18 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 70 0e 00 30 03 9c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 f0 03 80 38 00 1c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f f0 07 00 70 01 f8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 03 c0 f0 00 18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 c0 03 c1 e0 00 f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1c 73 8e 39 c7 38 e3 9c 71 8e 30 c7 18 e3 0c 71 ce 39 c7 1c e3 9c 71 8e 39 c7 38 e3 9c 73 8e 30 c7 18 e3 0c 71 8e 39 c7 1c e3 9c 71 ce 38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 30 01 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c1 f3 8f c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f ff e1 de 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e7 f3 cf c0 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 1f ff e1 ff 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ee 30 e0 e0 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 03 ff 01 c3 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff fc 70 e0 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 07 ff 81 c1 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff fc 30 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 03 81 c1 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 e0 30 38 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 ff 81 c1 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff fc 38 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 03 81 c1 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 00 ff e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07 ff 9f ff 87 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 6f fb ff dc e0 00 00 00 00 00 00 00 00 00 00 00 00 00 03 ff 0f ff 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff fb c0 78 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 1f ff e1 8c 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ff f9 e0 f0 e0 00 00 00 00 00 00 00 00 00 00 00 00 00 1f ff ff ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ef f8 71 c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f ff ff ff c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f f8 3b 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f ff c1 8c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f f8 1b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
