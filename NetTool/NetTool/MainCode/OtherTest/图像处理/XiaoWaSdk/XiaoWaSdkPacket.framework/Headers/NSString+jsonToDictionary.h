//
//  NSString+jsonToDictionary.h
//  XG
//
//  Created by chenjoy on 15/9/30.
//  Copyright © 2015年 memobird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (jsonToDictionary)

- (NSDictionary *)jsonToDictionary;
- (NSArray *)jsonToArray;

//GBK转换
- (NSData *)GBKData;

//UTF-8数据
- (NSData *)UTF8Data;

//base64转换
- (NSString *)base64StrToString;
- (NSString *)base64Str;
//http传输过4程的数据转换
- (NSString *)httpDataStr;
- (NSString *)httpDataStrToNorlmal;

/**
 GBK的字符串转换成正常的字符串
    这是打印过程中传输的字符串编码

 @return 正常的字符串
 */
- (NSString *)GBKStringToNormal;

//仅判断GBK和正常的UTF8编码；非UTF8的就是GBK；注意
- (BOOL)isGBKString;

/// GBKData转为string
+ (NSString *)GBKDataToStringWithGBKData:(NSData *)data;
/**
 扫描过程中解析的GBK字符串 ,======注意：调用此函数前一定要先调用 isGBKString

 @return 正常字符串
 */
- (NSString *)scanQRGBKStringToNormal;

@end
