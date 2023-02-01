//
//  XWDeviceModel.h
//  XiaoWaSDK
//
//  Created by 齐忠祥 on 2021/9/3.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWDeviceType : NSObject

@property (strong, nonatomic) NSString *bleName;//蓝牙名称
@property (strong, nonatomic) NSString *typeStr;//设备类型名称
@property (strong, nonatomic) NSString *showStr;//展示的设备名称
@property (strong, nonatomic) NSString *typeNum;//十六进制设备类型编号
@property (assign, nonatomic) NSInteger mtu;
@property (assign, nonatomic) NSInteger imageWidth;//设备图片打印宽度
@property (assign, nonatomic) NSInteger deviceWidth;//设备打印头宽度
@property (assign, nonatomic) NSInteger spaceLength;//打印后的走纸长度
@property (assign, nonatomic) BOOL contractionImage;//是否使用图片压缩算法
@property (assign, nonatomic) BOOL needDeviceId;//是否写入ID
@property (assign, nonatomic) BOOL isWifiDevice;//是否是wifi设备
@property (assign, nonatomic) BOOL canSetDensity;//是否支持设置浓度
@property (assign, nonatomic) BOOL use4ColorPrint;//是否支持4色灰度打印
@property (assign, nonatomic) NSInteger protocol;//协议类型 1,基础蓝牙协议 2,精芯8寸蓝牙协议 3,丽印蓝牙协议

@property (assign, nonatomic) NSInteger imageSpeed;//图片模式打印速度
@property (assign, nonatomic) NSInteger textSpeed;//文本模式打印速度
@property (strong, nonatomic) NSString *imageDensity;//图片模式打印浓度
@property (strong, nonatomic) NSString *textDensity;//文本模式打印浓度

@property (assign, nonatomic) BOOL canUseLabelPaper;//是否使用标签纸
@property (assign, nonatomic) NSInteger positionValue;//标签纸缝隙阈值
@property (assign, nonatomic) NSInteger positionLength;//标签纸检测点和打印头偏差
@property (assign, nonatomic) BOOL positionUpsidedown;//标签纸阈值方向
@property (strong, nonatomic) NSString *labelDensity;//标签模式打印浓度

@property (assign, nonatomic) BOOL needBind;//需要绑定的设备,当前只有S01和PR35
@property (assign, nonatomic) BOOL wifiPrint;//使用wifi打印的设备,当前只有X8

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

@interface XWDevice : NSObject

@property (strong, nonatomic) NSString *macAddress;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *typeId;
@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) NSString *activation;//是否激活  0:未请求  1:成功  2:失败
@property (strong, nonatomic) XWDeviceType *deviceType;
@property (strong, nonatomic) CBPeripheral *peripheral;

@property (strong, nonatomic) NSString *densityLevel;

@property (assign, nonatomic) BOOL needUpgrade;

@property (assign, nonatomic) BOOL wifiOnline;//wifi设备是否在线

@property (strong, nonatomic) NSString *name;//预留,设备别名

- (BOOL)isLink;

@end

typedef enum : NSUInteger {
    XWImageTypeImage,
    XWImageTypeText,
    XWImageType4Color,
} XWImageType;

@interface XWImageModel : NSObject

@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) XWImageType imageType;

- (instancetype)initWithImage:(UIImage *)image andType:(XWImageType)type;

@end

NS_ASSUME_NONNULL_END
