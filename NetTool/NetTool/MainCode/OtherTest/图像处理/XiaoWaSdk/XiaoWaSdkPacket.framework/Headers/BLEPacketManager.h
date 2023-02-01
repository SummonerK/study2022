//
//  BLEPacketManager.h
//  XiaoWa
//
//  Created by 齐忠祥 on 2019/10/21.
//  Copyright © 2019 齐忠祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XWDeviceModel.h"

typedef enum : NSUInteger {
    speedTypeLow,
    speedTypeHigh,
} SpeedType;

typedef enum : NSUInteger {
    densityTypeLight,
    densityTypeNomal,
    densityTypeDark,
} DensityType;

typedef enum : NSUInteger {
    imageTypeImage,
    imageTypeText,
    imageType4Color,
} ImageType;

NS_ASSUME_NONNULL_BEGIN

@interface BLEPacketManager : NSObject

+ (NSArray <NSData *>*)packetPrintDataWithBmpImage:(UIImage *)image andImageType:(ImageType)type andDevice:(XWDevice *)device;

+ (NSData *)packetPrintSpeedState:(NSInteger)state andDevice:(XWDevice *)device;//Data = 0  , 图片模式，打印速度慢   Data = 1 ,  文本模式，打印速度快
//+ (NSData *)packetPrintSpeed:(NSInteger)speed;//设置打印中的滚轴速度,200dpi都为45,300dpi图片模式60,文本模式45;包含在图片打包方法内,无需另外调用
+ (NSArray <NSData *>*)packetPrintSpeed:(SpeedType)speed andDensity:(DensityType)density withDevice:(XWDevice *)device;
+ (NSData *)packetPrintEnergy:(NSInteger)energy;//设置加热到25度的能量,30000-60000,default:40000
+ (NSData *)packetPrintSpaceWithLength:(NSInteger)length andDevice:(XWDevice *)device;//走纸
+ (NSData *)packetPrintSpaceMarkStopWithLength:(NSInteger)length andDevice:(XWDevice *)device;//带黑标侦测的走纸
+ (NSData *)packetPaperFeedBackWithLength:(NSInteger)length;//退纸

+ (NSArray <NSData *>*)packetSsid:(NSString *)ssid andPsw:(NSString *)psw;
+ (NSArray <NSData *>*)packetWifiSsid:(NSString *)ssid;
+ (NSArray <NSData *>*)packetWifiPsw:(NSString *)psw;

+ (NSArray <NSData *>*)packetLed:(BOOL)ledOn;

+ (NSArray <NSData *>*)packetAskForDeviceStateWithDeviceType:(XWDeviceType *)deviceType;
+ (NSArray <NSData *>*)packetAskForDeviceMessageWithDeviceType:(XWDeviceType *)deviceType;
+ (NSArray <NSData *>*)packetDeviceUpgrade;
+ (NSArray <NSData *>*)packetDeviceSetMarkPointWithDevice:(XWDevice *)device;
+ (NSArray <NSData *>*)packetSendDataWithHexString:(NSString *)hexString;//透传协议

+ (NSArray <NSData *>*)packetWriteDeviceID:(NSString *)deviceId withDevice:(XWDevice *)device;
+ (NSArray <NSData *>*)packetReadDeviceIdWithDevice:(XWDevice *)device;

+ (NSArray <NSData *>*)repacketDataWithDataArray:(NSArray <NSData *>*)dataArray andDevice:(XWDevice * _Nullable )device;
//+ (NSData *)complementData:(NSData *)data;
//
//+ (NSInteger)baseEnergyWithDevice:(Device *)device;
+ (NSString *)densityEnergyWithBaseEnergy:(NSInteger)energy andLevel:(NSInteger)level andDevice:(XWDevice *)device;

+ (NSArray <NSData *>*)packetBootInitWithDevice:(XWDevice *)device;
+ (NSArray <NSData *>*)packetUpgradeFile:(NSData *)fileData withDevice:(XWDevice *)device;

@end

NS_ASSUME_NONNULL_END
