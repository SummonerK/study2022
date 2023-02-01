//
//  ImageManipulation.h
//  QXDrawBoard
//
//  Created by hoho on 15/10/28.
//  Copyright © 2015年 Chiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EFilterType) {
    EFilterNull,//默认效果
    EFilterWord,//文字效果
    EFilterBuff,//图像增强
    EFilterSketch,//素描效果
    EFilterEdge,//描边效果
    EFilterNeon,//反色效果
    EFilterThreshold,//喷墨效果
    EFilterNegative,//底片效果
    EFilterEmboss,//浮雕效果
    EFilterTypeAll
};

@interface ImageManipulation : NSObject

/**
 默认滤镜处理,亮度0,对比度1
 @param originalImage 原始图片
 @return 处理后图片
 */
+ (UIImage *)manipulationWithImage:(UIImage *)originalImage andImageWidth:(NSInteger)width;

/// 将图片转换为byte
/// @param originalImage 
+ (NSData *)LK_byteMapWithImage:(UIImage *)originalImage andImageWidth:(NSInteger)width;

/**
 滤镜处理(有点阵处理,指定宽度)
 @param originalImage 原始图片
 @param eFilterType 样式
 @param brightValue 亮度
 @param contrastValue 对比度
 @return 处理后图片
 */
+ (UIImage *)manipulationWithImage:(UIImage *)originalImage Filter:(EFilterType)eFilterType BrightValue:(CGFloat)brightValue ContrastValue:(CGFloat)contrastValue andImageWidth:(NSInteger)width;

/**
 滤镜处理(未经点阵处理,加黑白滤镜)
 @param originalImage 原始图片
 @param eFilterType 样式
 @param brightValue 亮度
 @param contrastValue 对比度
 @return 处理后图片
 */
+ (UIImage *)filterWithImage:(UIImage *)originalImage Filter:(EFilterType)eFilterType BrightValue:(CGFloat)brightValue ContrastValue:(CGFloat)contrastValue;

/**
 单色位图转base64字符串,此字符串处理后有镜像颠倒的字符串
 无镜像颠倒的方法为+ (NSString *)convertBmpImageToRightBmpBase64Str:(UIImage *)image;

 @param image 原始图片
 @return 处理后图片
 */
+ (NSString *)convertBmpImageToBmpBase64Str:(UIImage *)image;
/**
 单色位图转base64字符串，此方法处理后为正常图片的字符串
 
 @param image 原始图片
 @return 处理后的字符串
 */
+ (NSString *)convertBmpImageToRightBmpBase64Str:(UIImage *)image;

/**
 单色位图转NSData ,此方法处理后为镜像颠倒；无镜像颠倒方法:+ (NSData *)convertBmpImageToRightBmpBaseData:(UIImage *)image;
 
 @param image <#image description#>
 @return <#return value description#>
 */
+ (NSData *)convertBmpImageToBmpBaseData:(UIImage *)image;
/**
 单色位图转NSData ,此方法处理后无镜像颠倒
 
 @param image <#image description#>
 @return <#return value description#>
 */
+ (NSData *)convertBmpImageToRightBmpBaseData:(UIImage *)image;

/**
 单色位图转base64字符串
 
 @param image <#image description#>
 @param isNeedMirrorImage YES，处理后为镜像颠倒图；NO，处理后为正常图
 @return <#return value description#>
 */
+ (NSString *)convertBmpImageToBmpBase64Str:(UIImage *)image isNeedMirrorImage:(BOOL)isNeedMirrorImage;


///原图直接做二值处理,并把文字笔画宽度处理成1个像素
+ (UIImage *)dealWithImageForText:(UIImage *)originalImage withImageWidth:(NSInteger)width;

///
+ (UIImage *)dealWithImageForHtml:(UIImage *)originalImage withImageWidth:(NSInteger)width;

///修正图片方向,返回边缘提取的黑白图片
+ (UIImage *)dealWithImageForSearch:(UIImage *)originalImage;

+ (NSArray<UIImage *> *)cutImageForHorizontalPrint:(UIImage *)orininalImage wihtHeight:(NSInteger)cutHeight;

@end
