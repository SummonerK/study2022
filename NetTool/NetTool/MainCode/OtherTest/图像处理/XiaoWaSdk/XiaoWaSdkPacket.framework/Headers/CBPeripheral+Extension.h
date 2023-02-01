//
//  CBPeripheral+Extension.h
//  BLEMutiTranportDemo
//
//  Created by 栗豫塬 on 2017/9/15.
//  Copyright © 2017年 intretech. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheral (Extension)

/** 进行写的Character */
@property (nonatomic, strong) CBCharacteristic *writeCharacter;

/** 要向外围设备发送的数据 */
@property (nonatomic, strong) NSMutableArray<NSArray *> *sendDataArray;

/** 收到外围设备发送的数据 */
@property (nonatomic, strong) NSMutableData *receiveData;

/** membirdG2-收到的数据包的长度 */
@property (nonatomic, assign) NSInteger receiveLength;

/** 设备的guid唯一标识 */
@property (nonatomic, copy) NSString *macAddress;

/** 当前是否正在发送数据 */
@property (nonatomic, assign) BOOL isSending;

/** 便携版-当前能发送的mtu大小 */
@property (nonatomic, assign) NSInteger currentMtu;

/** 便携版-当前能发送的包数 */
@property (nonatomic, assign) NSInteger currentPacketCounts;

@end
