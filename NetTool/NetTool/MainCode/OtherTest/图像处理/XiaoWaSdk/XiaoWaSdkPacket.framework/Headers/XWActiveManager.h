//
//  XWActiveManager.h
//  xiaowaTest
//
//  Created by 齐忠祥 on 2020/9/15.
//  Copyright © 2020 齐忠祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWDeviceModel.h"
#import "XWSdkManager.h"

typedef enum : NSUInteger {
    errorTypeToken,//token过期
    errorTypeNoFunds,//生产余额不足
    errorTypeWrongID,//非法ID
    errorTypeFail,//其他错误
} activeErrorType;

NS_ASSUME_NONNULL_BEGIN

/**
 manager操作的结果

 @param success 操作是否成功
 @param info 根据具体业务，需要什么就赋值什么
 */
typedef void(^OperationResult)(BOOL success, id info);

@interface XWActiveManager : NSObject

- (void)checkActive:(XWDevice *)device withActiveId:(NSString *)actId result:(nonnull OperationResult)result;

- (void)activeDevice:(XWDevice *)device withActiveId:(NSString *)actId result:(nonnull OperationResult)result;

- (void)askForActiveIdWithWithDevice:(XWDevice *)device result:(OperationResult)result;

//sdk专用
- (void)askForActiveIdWithWithUserId:(NSString *)userId andToken:(NSString *)token andMacAddress:(NSString *)mac result:(OperationResult)result;
- (void)activeDeviceWithUserId:(NSString *)userId andToken:(NSString *)token andVersion:(NSString *)version andDevId:(NSString *)devId andType:(NSString *)typeStr andInternationalType:(NSString *)internationalType result:(nonnull OperationResult)result;
- (void)activeDeviceWithUserId:(NSString *)userId andToken:(NSString *)token andVersion:(NSString *)version andActiveId:(NSString *)actId andMacAddress:(NSString *)mac andType:(NSString *)typeStr andInternationalType:(NSString *)internationalType result:(OperationResult)result;


@end

NS_ASSUME_NONNULL_END
