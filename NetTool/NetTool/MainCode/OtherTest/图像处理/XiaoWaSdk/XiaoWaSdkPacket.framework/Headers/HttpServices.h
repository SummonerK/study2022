//
//  HttpServices.h
//  XiaoWa
//
//  Created by 齐忠祥 on 2019/9/10.
//  Copyright © 2019 齐忠祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSDictionary+JsonStr.h"
#import "NSString+jsonToDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@class HttpServices;
@protocol HttpServiceDelegate <NSObject>
@optional

/**
 请求成功返回为NSString
 
 @param services 请求对象
 @param str 返回值
 */
-(void)requestHttpServices:(HttpServices *)services FinishedMessage:(NSString*)str;

/**
 请求成功返回为NSData
 
 @param services 请求对象
 @param data 返回值
 */
-(void)requestHttpServices:(HttpServices *)services FinishedData:(NSData *)data;

/**
 请求失败返回
 
 @param services 请求对象
 @param error 错误对象
 */
-(void)requestHttpServices:(HttpServices *)services FailedMessage:(NSError*)error;

@end

@interface HttpServices : NSObject

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receiveData;//http post
@property (nonatomic, weak) id<HttpServiceDelegate> delegate;


- (id)initWithDelegate:(id<HttpServiceDelegate>)delegate;

/**
 http post请求
 
 @param parameters 请求参数
 */
- (void)HttpsPostWithparameters:(NSDictionary *)parameters andInfoStr:(NSString *)infoStr;
- (void)HttpPostWithparameters:(NSDictionary *)parameters andInfoStr:(NSString *)infoStr;
- (void)HttpPostWithUrlString:(NSString *)urlString andParameters:(NSDictionary *)parameters andInfoStr:(NSString *)infoStr;

/**
 http get请求
 
 @param parameters 请求参数
 */
- (void)HttpGetWithparameters:(NSDictionary *)parameters;

//- (void)postRequestWithFileName:(NSString *)picFileName andImage:(UIImage *)image andParameters:(NSMutableDictionary *)dic;
//- (void)postRequestWithFilePath:(NSString *)filePath;
- (void)postRequestWithData:(NSData *)data;

- (void)downloadFileWithFilePath:(NSString *)filtPath andStringUrl:(NSString *)strUrl;

@end

NS_ASSUME_NONNULL_END
