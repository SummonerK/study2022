//
//  LXDevice.swift
//  NetTool
//
//  Created by luoke_ios on 2023/1/10.
//

import Foundation

///整行 48 byte
private let serialNumbCount = 48

typealias completionBlock = (_ success:Bool)->Void

// TODO: - 1份数据。
// TODO: - 记录份数。
// TODO: - 再通知地方打印但行。

class LXDevice: NSObject {
    static let shared = LXDevice()
    
    ///打印一张图片的
    private var OnePaperBlock:completionBlock?
    
    func devicePrint(source image:UIImage?,repeatTimes:Int) -> Void {
        guard let toImage = image else { return }
        guard let bytes = self.getImageData(with: toImage) else { return }
        let datas = self.transData96(with: bytes)
        
        let group = DispatchGroup()
//        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_devicePrint")
        let queue = getSerial(label: "queue_performQueuesUseASynchronization_devicePrint")
        let semaphoreLock = DispatchSemaphore(value: 0)
        /// 写入标识
        var writeFlag:Bool = true
        
        for i in 0..<repeatTimes{
            if writeFlag == false{
                LKPrint("打印出错---")
                break
            }
            
            queue.async {
                let totalTaskCount:Int = datas.count
                LKPrint("totalTaskCount \(totalTaskCount)")
                ///打印图片头部
                let head: [UInt8] = [0x5A, 0x04]
                let serialNumber = totalTaskCount.hw_to2Bytes()
                let headData: [UInt8] = head + serialNumber + [0]
                let data_begin = Data.init(headData)
//                BlueToothHelp.shared.writeData(with: data_begin)
                
                self.writeLineTwoByteFullData(with: datas) { success in
                    if success{
                        LKPrint("打印完成--第\(i+1)份-✅")
                        semaphoreLock.signal() ///开锁 🔓
                    }else{
                        writeFlag = false
                        semaphoreLock.signal() ///开锁 🔓
                    }
                }
            }
        }
        queue.sync {
            if writeFlag == false{
                LKPrint("打印出错---❌")
            }else{
                LKPrint("完成了全部 🚩")
            }
        }
         
//
//        let group = DispatchGroup()
//        let queue = getConcurrent(label: "queue_performQueuesUseASynchronization_devicePrint")
//        let semaphoreLock = DispatchSemaphore(value: 1)
//
//        for i in 0..<repeatTimes{
//            queue.async(group: group) { [weak self] in
//                semaphoreLock.wait() ///上锁🔒
//                guard let self = self else {
//                    semaphoreLock.signal() ///开锁 🔓
//                    return
//                }
//                let totalTaskCount:Int = datas.count
//                LKPrint("totalTaskCount \(totalTaskCount)")
//                let head: [UInt8] = [0x5A, 0x04]
//                let serialNumber = totalTaskCount.hw_to2Bytes()
//                let headData: [UInt8] = head + serialNumber + [0]
//                let data_begin = Data.init(headData)
//                BlueToothHelp.shared.writeData(with: data_begin)
//                self.writeLineTwoByteFullData(with: datas) { success in
//                    if success{
//                        LKPrint("打印完成--第\(i+1)份-✅")
//                        semaphoreLock.signal() ///开锁 🔓
//                    }
//                }
//            }
//        }
        
    }
    
    func writeLineTwoByteFullData(with array:[[UInt8]],completion:@escaping  completionBlock){
        let totalTaskCount:Int = array.count
        let group = DispatchGroup()
//        let queue = getConcurrent(label: "queue_devicePrint_pic")
        let queue = getSerial(label: "queue_devicePrint_pic")
        let semaphoreLock = DispatchSemaphore(value: 0)
        /// 写入标识
        var writeFlag:Bool = true
        
        for i in 0..<array.count{
            if writeFlag == false{
                LKPrint("打印出错---")
                break
            }
            
            
            queue.async {
                if writeFlag == false{
                    LKPrint("打印出错---")
                    return
                }
                
                currentThreadSleep(seconds: 0.05)
                let head: [UInt8] = [0x55] ///包头 和序号
                let serialNumber = i.hw_to2Bytes()
                let taskData: [UInt8] = head + serialNumber + array[i] + [0]
                let dataFrom = Data.init(taskData)
//                BlueToothHelp.shared.writeData(with: dataFrom)
                
                /// 执行并行方法，会造成block Setter报错
//                BlueToothHelp.shared.writeData(with: dataFrom) { continueFlag in
//                    if continueFlag{
//                        LKPrint("写入数据---index---\(i+1)")
//                        semaphoreLock.signal() ///开锁 🔓
//                    }else{
//                        semaphoreLock.signal() ///开锁 🔓
//                        writeFlag = false
//                    }
//                }
                
                DispatchQueue.jk.asyncDelay(1) {
                    LKPrint("执行任务---\(i)")
                    writeFlag = false
                    semaphoreLock.signal() ///开锁 🔓
                }
                semaphoreLock.wait() ///加锁 🔓
            }
        }
        
        queue.sync {
            if writeFlag == false{
                LKPrint("图片打印--出错--❌")
                completion(false)
            }else{
                let head: [UInt8] = [0x5A, 0x04]
                let serialNumber = totalTaskCount.hw_to2Bytes()
                let endData: [UInt8] = head + serialNumber + [1]
                let data_finish = Data.init(endData)
                BlueToothHelp.shared.writeData(with: data_finish)
                LKPrint("图片打印--完成-✅")
                completion(true)
            }
        }
        
        
//        for i in 0..<array.count{
//            queue.async(group: group) {
//                semaphoreLock.wait() ///上锁🔒
//                currentThreadSleep(seconds: 0.05)
//                let head: [UInt8] = [0x55] ///包头 和序号
//                let serialNumber = i.hw_to2Bytes()
//                let taskData: [UInt8] = head + serialNumber + array[i] + [0]
//                let dataFrom = Data.init(taskData)
//                /// 执行并行方法，会造成block Setter报错
////                BlueToothHelp.shared.writeData(with: dataFrom) { continueFlag in
////                    if continueFlag{
////                        LKPrint("写入数据---index---\(i+1)")
////                        semaphoreLock.signal() ///开锁 🔓
////                    }
////                }
//
//                currentThreadSleep(seconds: 1)
//                LKPrint("写入数据---index---\(i+1)")
//                semaphoreLock.signal() ///开锁 🔓
//            }
//        }
//
//        group.notify(queue: queue){
//            //group执行完成了
//            let head: [UInt8] = [0x5A, 0x04]
//            let serialNumber = totalTaskCount.hw_to2Bytes()
//            let endData: [UInt8] = head + serialNumber + [1]
//            let data_finish = Data.init(endData)
////            BlueToothHelp.shared.writeData(with: data_finish)
//            LKPrint("图片打印完成--完成-✅")
//            completion(true)
//        }
        
    }
    
    /// 96byte/包--写入协议
    /// 写入 一包数据
    /// - Parameters:
    ///   - array:
    ///   - index:
    /// - Returns:
    private func writeLineTwoByteData(with array:[[UInt8]],index:Int) -> Void {
        let totalTaskCount:Int = array.count
        let head: [UInt8] = [0x55] ///包头 和序号
        let serialNumber = index.hw_to2Bytes()
        let taskData: [UInt8] = head + serialNumber + array[index] + [0]
        let dataFrom = Data.init(taskData)
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

    /// 根据图片获取图片数据
    /// - Parameter image:
    /// - Returns:
    private func getImageData(with image:UIImage) -> [UInt8]? {
        guard let transData = ImageManipulation.lk_byteMap(with: image, andImageWidth: 384) else { return nil}
        let bytes: [UInt8] = [UInt8](transData)
        let resutBytes = Array(bytes[62...bytes.count-1])
        return resutBytes
    }
    
    // MARK: - 96byte 数据协议
    private func transData96(with fullBytes:[UInt8]) -> [[UInt8]] {
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
        let total_count = fullBytes.count/serialNumbCount
        // 整行 48 byte， 打印图片需要倒置数据
        let piceNumbCount = serialNumbCount
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
    
    
    private func getLineData48() -> [UInt8]{
        let inData : [UInt8] = [0,0,0,0,
                                0,0,0,0,
                                0,0,0,0,
                                0,0,0,0]
        return inData + inData + inData
    }

}




