//
//  XWSdkManager.h
//  XiaoWaSDK
//
//  Created by 齐忠祥 on 2021/9/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XWDeviceModel.h"
#import "BLEManager.h"

#define kJingxinUpdateBinFilePath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Jingxin"]

NS_ASSUME_NONNULL_BEGIN

/**
 manager操作的结果

 @param success 操作是否成功
 @param info 根据具体业务，需要什么就赋值什么
 */
typedef void(^OperationResult)(BOOL success, id info);

typedef enum : NSUInteger {
    printStopStateComplete,//打印完成
    printStopStateNoPaper, //缺纸
    printStopStateOpened,  //纸仓盖开
    printStopStateHot,     //过热
    printStopStateLowBattery, //低电量
    printStopStateTimeout, //数据发送超时
    printStopStateDisconnected, //蓝牙断开
    printStopStateNoAativate, //设备未激活
    printStopStateOverseas, //海外设备禁止国内使用
    printStopStateError, //图片出错
    printStopStateNotReady, //打印机还没准备好
    printStopStateWifiOffline, //wifi设备不在线
} XWPrintStopState;

typedef enum : NSUInteger {
    printDensityTypeLight,
    printDensityTypeNomal,
    printDensityTypeDark,
} PrintDensityType;

@protocol XWSdkManagerDelegate <NSObject>

///发现新设备
- (void)xwSdkManagerDidSearchDeviceWithPeripheral:(CBPeripheral *)peripheral;

///连接上新设备
- (void)xwSdkManagerDidConnectDevice:(XWDevice *)device;

///停止搜索新设备
- (void)xwSdkManagerDidStopSearch;

///打印停止,返回停止原因
- (void)xwSdkManagerDidStopPrintWithState:(XWPrintStopState)state;

///开发用数据返回
- (void)xwSdkManagerDidSendMessage:(id)message;

@optional

///标签打印定位返回
- (void)xwSdkManagerDidSearchLabelPaperPosition:(NSArray<NSNumber *> *)positionArray;

///发现新固件版本
- (void)xwSdkManagerDidSearchNewFirmwareVersion;

///wifi配置回复
- (void)xwSdkManagerDidSetupWifi:(BOOL)success;

///固件升级回复
- (void)xwSdkManagerDidUpgradeDevice:(BOOL)success;

///产测工具专用
- (void)xwSdkManagerDidReadDeviceId:(NSString *)deviceId;

@end

@interface XWSdkManager : NSObject

@property (nonatomic, weak) id<XWSdkManagerDelegate> delegate;

@property (strong, nonatomic, readonly) NSString *userId;

+ (XWSdkManager *)shared;

///sdk鉴权
- (void)startWithKey:(NSString *)key;

///开始搜索新设备,时间5秒
- (void)searchDevice;

///停止搜索新设备
- (void)searchStop;

///连接新设备
- (void)connectDeviceWithPeripheral:(CBPeripheral *)peripheral;

///更新设备信息(结果将作为新设备在连接上新设备的回调中返回)
- (void)updateDeviceMessage:(XWDevice *)device;

///检查设备状态,结果返回(xwSdkManagerDidStopPrintWithState)
- (void)checkDeviceState:(XWDevice *)device;

///检查新固件
- (void)checkUpgrade:(XWDevice *)device result:(OperationResult)result;
///固件升级
- (void)upgradeDevice:(XWDevice *)device;
- (void)sendUpgradeFile:(NSData *)fileData toDevice:(XWDevice *)device;

///wifi配置
- (void)setupWifiWithSsid:(NSString *)ssid andPsw:(NSString *)psw toDevice:(XWDevice *)device;
///请求wifi打印设备列表
- (void)askForWifiPrintDeviceWithResult:(OperationResult)result;

///浓度等级设置
- (void)setupDensityLevel:(NSString *)level withDevice:(XWDevice *)device;
- (void)printDensityTestImage:(UIImage *)image toDevice:(XWDevice *)device;

///打印图片,图片宽度必须与设备相符,且为点阵图片
- (void)printImage:(UIImage *)image withDensity:(PrintDensityType)densityType toDevice:(XWDevice *)device;
- (void)printImageWithModelArray:(NSArray <XWImageModel *> *)imageModelArray withDensity:(PrintDensityType)densityType toDevice:(XWDevice *)device repeatTimes:(NSInteger)times;
///打印A4图片,打印完成自动退纸
- (void)printImageForA4WithModel:(XWImageModel *)imageModel withDensity:(PrintDensityType)densityType toDevice:(XWDevice *)device;

///设备走纸
- (void)feedPaperWithLength:(NSInteger)length toDevice:(XWDevice *)device;

///停止当前打印
- (void)printStop:(XWDevice *)device;

- (XWDeviceType *)deviceTypeWithBleName:(NSString *)bleName;

- (void)sendData:(NSArray<NSData *> *)array toDevice:(XWDevice *)device withStatesCheck:(BOOL)check;


///标签纸打印
- (void)printLabelImageWithModelArray:(NSArray <XWImageModel *> *)imageModelArray withDensity:(PrintDensityType)densityType toDevice:(XWDevice *)device;

///定位标签纸
- (void)positionLabelPaperWithDevice:(XWDevice *)device;
- (void)positionLabelPaperWithDeviceContinue:(XWDevice *)device;

///绑定设备
- (void)bindDevice:(XWDevice *)device result:(OperationResult)result;

///产测工具专用
- (void)readActiveIdFromDevice:(XWDevice *)device;
- (void)writeActiveId:(NSString *)activeId toDevice:(XWDevice *)device;
- (void)setMarkPointToDevice:(XWDevice *)device;
- (void)sendDeviceId:(NSString *)deviceId toDevice:(XWDevice *)device;

@end

NS_ASSUME_NONNULL_END
