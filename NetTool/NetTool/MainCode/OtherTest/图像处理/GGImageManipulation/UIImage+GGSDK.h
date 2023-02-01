//
//  UIImage+GGSDK.h
//  GGSDK
//
//  Created by orange on 17/2/4.
//  Copyright © 2017年 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GGSDK)

- (UIImage *)gg_scaleSize:(CGSize)size;
- (UIImage *)gg_grayByType:(char)type;
- (UIImage *)gg_convertToBitmap;

- (unsigned char *)gg_convertUIImageToBitmapRGBA8:(UIImage *) image;
- (CGContextRef)gg_newBitmapRGBA8ContextFromImage:(CGImageRef) image;
- (UIImage *)gg_convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height;

- (UIImage *)gg_cropImage:(CGRect)rect;
- (UIImage *)gg_combineImageUpImage:(UIImage *)upImage DownImage:(UIImage *)downImage;
@end
