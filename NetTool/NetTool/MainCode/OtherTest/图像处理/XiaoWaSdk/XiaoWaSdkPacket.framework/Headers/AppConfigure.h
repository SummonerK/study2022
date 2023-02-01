//
//  AppConfigure.h
//  XiaoWa
//
//  Created by 齐忠祥 on 2019/9/10.
//  Copyright © 2019 齐忠祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 manager操作的结果

 @param success 操作是否成功
 @param info 根据具体业务，需要什么就赋值什么
 */
typedef void(^OperationResult)(BOOL success, id info);

@interface AppConfigure : NSObject

/**
 配置app连接到正式服或测试服
 
 @param official  正式服:YES  测试服:NO
 */
+ (void)linkToOfficialServer:(BOOL)official;


/**
 配置服务器域名
 
 @param httpUrl httpService服务器域名
 */
+ (void)setupHttpServiceUrl:(NSString *)httpUrl;


/// 从服务器获取域名配置
- (void)askForAppServiceCtrlWithResult:(OperationResult)result;

@end

NS_ASSUME_NONNULL_END
