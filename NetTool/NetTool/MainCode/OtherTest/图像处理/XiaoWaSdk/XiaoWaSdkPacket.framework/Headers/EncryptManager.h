//
//  EncryptManager.h
//  XiaoWa
//
//  Created by 齐忠祥 on 2022/5/16.
//  Copyright © 2022 齐忠祥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EncryptManager : NSObject

+ (NSDictionary *)EncryptParameters:(NSDictionary *)parameters;
+ (NSString *)DecryptParameters:(NSString *)encodeParameters;

@end

NS_ASSUME_NONNULL_END
