//
//  BLEManager.h
//  XiaoWa
//
//  Created by 齐忠祥 on 2019/10/14.
//  Copyright © 2019 齐忠祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CBPeripheral+Extension.h"

#define BLE_UUID @[[CBUUID UUIDWithString:@"AE00"],[CBUUID UUIDWithString:@"FF00"],[CBUUID UUIDWithString:@"AB00"],[CBUUID UUIDWithString:@"AE80"],[CBUUID UUIDWithString:@"AE30"],[CBUUID UUIDWithString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"]]
#define BLE_UUID_Write @[[CBUUID UUIDWithString:@"AE01"],[CBUUID UUIDWithString:@"FF01"],[CBUUID UUIDWithString:@"AB01"],[CBUUID UUIDWithString:@"AE81"],[CBUUID UUIDWithString:@"49535343-8841-43F4-A8D4-ECBE34729BB3"]]
#define BLE_UUID_Notify @[[CBUUID UUIDWithString:@"AE02"],[CBUUID UUIDWithString:@"FF02"],[CBUUID UUIDWithString:@"AB02"],[CBUUID UUIDWithString:@"AE82"],[CBUUID UUIDWithString:@"49535343-1E4D-4BD9-BA61-23C647249616"]]
#define BLE_UUID_FlowControl @[[CBUUID UUIDWithString:@"AE04"],[CBUUID UUIDWithString:@"FF03"],[CBUUID UUIDWithString:@"AB03"]]

#define BLE_UUID_Write_P2 @[[CBUUID UUIDWithString:@"FF02"],[CBUUID UUIDWithString:@"49535343-8841-43F4-A8D4-ECBE34729BB3"]]
#define BLE_UUID_Notify_P2 @[[CBUUID UUIDWithString:@"FF01"],[CBUUID UUIDWithString:@"49535343-1E4D-4BD9-BA61-23C647249616"]]
#define BLE_UUID_FlowControl_P2 @[[CBUUID UUIDWithString:@"FF03"]]

NS_ASSUME_NONNULL_BEGIN

static NSString * const kNotificationPrintProgress = @"kNotificationPrintProgress";
static NSString * const kNotificationBleDisconnected = @"kNotificationBleDisconnected";

@class BLEManager;

@protocol BLEManagerDelegate <NSObject>

/**
 收到连接蓝牙设备结果

 @param peripheral 连接的设备 对于连接超时该值为nil
 */
//- (void)bleConnectManager:(BLEConnectManager *)manager
//     receiveConnectState:(BLEConnectDeviceState)connectstate
//                     guid:(NSString *)guid;

//- (void)bleConnectManager:(BLEConnectManager *)manager
//           didUpdateState:(CBManagerState)state;

- (void)bleManager:(BLEManager *)manager didDiscoverPeripheral:(CBPeripheral *)peripheral
                                             advertisementData:(NSDictionary *)advertisementData
                                                          RSSI:(NSNumber *)RSSI;

///蓝牙已连接
- (void)bleManager:(BLEManager *)manager didSetCharacteristic:(CBPeripheral *)peripheral;

///蓝牙收到数据
- (void)bleManager:(BLEManager *)manager didReadData:(NSData *)data
                                        atPeripheral:(CBPeripheral *)peripheral;

- (void)bleManagerDidStopScan:(BLEManager *)manager;

@end

@interface BLEManager : NSObject

@property (nonatomic, weak) id<BLEManagerDelegate> connectDelegate;

@property (strong, nonatomic) NSArray<NSString *> *bleSearchArray;

@property (assign, nonatomic) NSInteger sendSpaceTime;
@property (assign, nonatomic) NSInteger waitSpaceTime;

@property (assign, nonatomic) BOOL flowControlModel;//8寸使用的流控模式
@property (assign, nonatomic) BOOL isSendingData;

+ (BLEManager *)shared;

- (CBManagerState)fetchCurrentPhoneBLEState  API_AVAILABLE(ios(10.0));

- (void)startScanBLEDevicesWithServices:(NSArray<CBUUID *> * _Nullable )serviceUUIDs;
- (void)stopScanBLEDevice;

- (void)connectPeripheral:(CBPeripheral *)peripheral;
- (void)disconnectPeripheral:(CBPeripheral *)peripheral;
- (void)sendDataToPeripheral:(CBPeripheral *)peripheral withDataArray:(NSArray<NSData *> *)dataArray andStatesCheck:(BOOL)check;

- (void)setupSendSpaceTime:(NSInteger)time;
- (void)setupWaitSpaceTime:(NSInteger)time;

- (BOOL)checkDeviceConnectedWithMacAddress:(NSString *)mac;
- (nullable CBPeripheral *)peripheralWithMacAddress:(NSString *)mac;

///开始数据发送
- (void)sendDataStart;
///停止数据发送
- (void)sendDataStop;
///发送除错数据包并走纸
- (void)sendStopDataWithDeviceWidth:(NSInteger)width andSpaceLength:(NSInteger)space;

@end

NS_ASSUME_NONNULL_END
