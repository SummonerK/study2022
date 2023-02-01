//
//  ImageManipulation.m
//  QXDrawBoard
//
//  Created by hoho on 15/10/28.
//  Copyright © 2015年 Chiu. All rights reserved.
//

#import "ImageManipulation.h"
#import "UIImage+GGSDK.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"

@implementation ImageManipulation

#pragma - mark 图片处理

+ (UIImage *)manipulationWithImage:(UIImage *)originalImage andImageWidth:(NSInteger)width {
    return [ImageManipulation manipulationWithImage:originalImage Filter:EFilterNull BrightValue:0.0f ContrastValue:1.0f andImageWidth:width];
}

+ (NSData *)LK_byteMapWithImage:(UIImage *)originalImage andImageWidth:(NSInteger)width{
    return [ImageManipulation LKmanipulationWithImage:originalImage Filter:EFilterNull BrightValue:0.0f ContrastValue:1.0f andImageWidth:width];
}

+ (UIImage *)manipulationWithImage:(UIImage *)originalImage Filter:(EFilterType)eFilterType BrightValue:(CGFloat)brightValue ContrastValue:(CGFloat)contrastValue andImageWidth:(NSInteger)width {
    if (!originalImage) {
        NSLog(@"图片为空或异常");
//        originalImage = [UIImage imageNamed:@"PrintFailed"];
        originalImage = [self imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(384, 384)];
    }

    UIImage *image = [originalImage copy];
    
    NSInteger imageW = width;
    NSInteger imageH = imageW*image.size.height/image.size.width;
    image = [image gg_scaleSize:CGSizeMake(imageW, imageH)];
    
    image = [self doDither:image Filter:eFilterType BrightValue:brightValue ContrastValue:contrastValue];
    
    image = [self processingIntoBmp:image];
    
    NSLog(@"fixH = %ld",(long)imageH);
    NSLog(@"fixW = %ld",(long)imageW);

    return image;
}

+ (NSData *)LKmanipulationWithImage:(UIImage *)originalImage Filter:(EFilterType)eFilterType BrightValue:(CGFloat)brightValue ContrastValue:(CGFloat)contrastValue andImageWidth:(NSInteger)width {
    if (!originalImage) {
        NSLog(@"图片为空或异常");
//        originalImage = [UIImage imageNamed:@"PrintFailed"];
        originalImage = [self imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(384, 384)];
    }

    UIImage *image = [originalImage copy];
    
    NSInteger imageW = width;
    NSInteger imageH = imageW*image.size.height/image.size.width;
    image = [image gg_scaleSize:CGSizeMake(imageW, imageH)];
    
    image = [self doDither:image Filter:eFilterType BrightValue:brightValue ContrastValue:contrastValue];
    
    NSData * finalData = [self LKprocessingIntoBmp:image];
    
    NSLog(@"fixH = %ld",(long)imageH);
    NSLog(@"fixW = %ld",(long)imageW);

    return finalData;
}

+ (UIImage *)filterWithImage:(UIImage *)originalImage Filter:(EFilterType)eFilterType BrightValue:(CGFloat)brightValue ContrastValue:(CGFloat)contrastValue {
    if (!originalImage) {
        NSLog(@"图片为空或异常");
        originalImage = [UIImage imageNamed:@"PrintFailed"];
    }
    UIImage *image = [originalImage copy];
    
    image = [self doDither:image Filter:eFilterType BrightValue:brightValue ContrastValue:contrastValue];
        
    GPUImageGrayscaleFilter *grayscaleFilter = [[GPUImageGrayscaleFilter alloc]init];
    UIImage *sketchImg = [grayscaleFilter imageByFilteringImage:image];
    
    if (sketchImg) {
        image = sketchImg;
    }

    return image;
}

+ (UIImage*)doDither:(UIImage*)anImage Filter:(NSInteger)type BrightValue:(float)brightValue ContrastValue:(float)contrastValue {    
    NSMutableArray<UIImage *> *imageArray = [[NSMutableArray alloc]init];
    CGFloat height = 4000;
    int count = (int)(anImage.size.height / height) + 1;
    for (int i = 0; i < count; i++) {
        CGFloat cropHeight = height;
        if (anImage.size.height < 4000 * (i + 1)) {
            cropHeight = anImage.size.height - (4000 * i);
        }
        UIImage *cropImage = [anImage gg_cropImage:CGRectMake(0, height * i, anImage.size.width, cropHeight)];
        if (!cropImage) {
            return [[UIImage alloc]init];
        }
        
        [imageArray addObject:cropImage];
    }
    
    NSMutableArray<UIImage *> *resultImageArray = [[NSMutableArray alloc]init];
    for (UIImage *cropImage in imageArray) {
        UIImage *tempImage = cropImage;
        if (!(brightValue == 0 && contrastValue == 1)) {
            tempImage = [self setLightWithImage:anImage BrightValue:brightValue ContrastValue:contrastValue];
        }
        
        if (EFilterSketch == type) {
            GPUImageSketchFilter *sketchFilter = [[GPUImageSketchFilter alloc] init];
            UIImage *sketchImg = [sketchFilter imageByFilteringImage:tempImage];
            tempImage = sketchImg;
        }
        else if (EFilterEdge == type)
        {
            GPUImageToonFilter *edgeFilter = [[GPUImageToonFilter alloc] init];
            UIImage *edgeImg = [edgeFilter imageByFilteringImage:tempImage];
            tempImage = edgeImg;
            //        imageRef = edgeImg.CGImage;
            //        return edgeImg;
        }else if (EFilterEmboss == type) {
            GPUImageEmbossFilter *sketchFilter = [[GPUImageEmbossFilter alloc] init];
            UIImage *sketchImg = [sketchFilter imageByFilteringImage:tempImage];
            tempImage = sketchImg;
        }else if (EFilterWord == type) {
    //        GPUImageWhiteBalanceFilter *balanceFilter = [[GPUImageWhiteBalanceFilter alloc]init];
    //        UIImage *balanceImg = [balanceFilter imageByFilteringImage:tempImage];
            
    //        GPUImageAverageLuminanceThresholdFilter *sketchFilter = [[GPUImageAverageLuminanceThresholdFilter alloc] init];
    //        UIImage *sketchImg2 = [sketchFilter imageByFilteringImage:tempImage];
    //        tempImage = sketchImg2;
            
            GPUImageBilateralFilter *bilateralFilter = [[GPUImageBilateralFilter alloc] init];
            bilateralFilter.distanceNormalizationFactor = 5.0;
            UIImage *sketchImg = [bilateralFilter imageByFilteringImage:tempImage];
            
            GPUImageAdaptiveThresholdFilter *sketchFilter = [[GPUImageAdaptiveThresholdFilter alloc] init];
            sketchFilter.blurRadiusInPixels = 10;
            UIImage *sketchImg2 = [sketchFilter imageByFilteringImage:sketchImg];
            tempImage = sketchImg2;
        }else if (EFilterBuff == type || EFilterNull == type) {
            GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc]init];
            UIImage *sketchImg = [beautifyFilter imageByFilteringImage:tempImage];
            tempImage = sketchImg;
        }

        if (EFilterNeon == type || EFilterNegative == type) {
            GPUImageColorInvertFilter *invertFilter = [[GPUImageColorInvertFilter alloc]init];
            UIImage *sketchImg = [invertFilter imageByFilteringImage:tempImage];
            tempImage = sketchImg;
        }
        
        [resultImageArray addObject:tempImage];
    }
    
    if (resultImageArray.count == 0) {
        return nil;
    }else if (resultImageArray.count == 1) {
        return resultImageArray[0];
    }else {
        UIImage *returnImage = resultImageArray[0];
        for (int i = 1; i < resultImageArray.count; i++) {
            returnImage = [returnImage gg_combineImageUpImage:returnImage DownImage:resultImageArray[i]];
        }
        return returnImage;
    }
}

+ (UIImage *)processingIntoBmp:(UIImage *)tempImage {
    CGImageRef imageRef = tempImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    int red,grn,blu,alpha;
    UInt32 *average = malloc(sizeof(UInt32)*width*height);
    memset(average, 0x0000, sizeof(UInt32)*width*height);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    CFRelease(data);
    //每个像素点所占字节
    size_t bytesPerPixel = bytesPerRow/width;
    //    size_t picOffset = 0;
    if (bytesPerPixel == 1) {
    //        picOffset = 206;
    }
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            UInt8 *tmpBuf = buffer+(x+y*width)*bytesPerPixel;
            int nAverage = *tmpBuf;
            
            if (1 != bytesPerPixel) {
                //不是单色的位图
                red = *(tmpBuf); // unsigned int
                grn = *(tmpBuf+1); // unsigned int
                blu = *(tmpBuf+2); // unsigned int
                alpha = *(tmpBuf+3); // unsigned int
//0.30 RED + 0.59 GREEN + 0.11 BLUE 灰度处理
//                nAverage =0.3*red+0.59*grn+0.11*blu;
                nAverage = (77 * red + 151 * grn + 28 * blu) / 256 + (255 - alpha);
            }
            else
            {
                nAverage = 255-nAverage;
            }
            *(average+x+y*width) = nAverage;
        }
    }
    
//    imageBuffer((int *)average, (int)height, (int)width);
    //处理点阵疏密
    ditherCopy((int *)average, (int)height, (int)width);
    
    UIImage *outputImage = [self createBmpImg:average with:(int)width and:(int)height];
    free(average);
    return outputImage;
}

+ (NSData *)LKprocessingIntoBmp:(UIImage *)tempImage {
    CGImageRef imageRef = tempImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    int red,grn,blu,alpha;
    UInt32 *average = malloc(sizeof(UInt32)*width*height);
    memset(average, 0x0000, sizeof(UInt32)*width*height);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    CFRelease(data);
    //每个像素点所占字节
    size_t bytesPerPixel = bytesPerRow/width;
    //    size_t picOffset = 0;
    if (bytesPerPixel == 1) {
    //        picOffset = 206;
    }
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            UInt8 *tmpBuf = buffer+(x+y*width)*bytesPerPixel;
            int nAverage = *tmpBuf;
            
            if (1 != bytesPerPixel) {
                //不是单色的位图
                red = *(tmpBuf); // unsigned int
                grn = *(tmpBuf+1); // unsigned int
                blu = *(tmpBuf+2); // unsigned int
                alpha = *(tmpBuf+3); // unsigned int
//0.30 RED + 0.59 GREEN + 0.11 BLUE 灰度处理
//                nAverage =0.3*red+0.59*grn+0.11*blu;
                nAverage = (77 * red + 151 * grn + 28 * blu) / 256 + (255 - alpha);
            }
            else
            {
                nAverage = 255-nAverage;
            }
            *(average+x+y*width) = nAverage;
        }
    }
    
//    imageBuffer((int *)average, (int)height, (int)width);
    //处理点阵疏密
    ditherCopy((int *)average, (int)height, (int)width);
    
    NSData *outputData = [self LKcreateBmpImg:average with:(int)width and:(int)height];
    free(average);
    return outputData;
}

//点阵疏密程度算法
int* ditherCopy(int* pixel, int height, int width) {
    int oldpixel, newpixel, error;
    BOOL nbottom, nleft, nright;
    for (int y = 0; y < height; y++) {
        nbottom = y < height - 1;
        for (int x = 0; x < width; x++) {
            nleft = x > 0;
            nright = x < width - 1;
            int offset = x + y*width;
            oldpixel = *(pixel + offset);
            newpixel = oldpixel < 128 ? 0 : 255;
            *(pixel + offset) = newpixel;
            error = oldpixel - newpixel;
            
            if (nright) {
                *(pixel+(x+1)+y * width) += 7 * error / 16;
            }
            if (nleft & nbottom) {
                *(pixel+(x-1)+(y+1)*width) += 3 * error / 16;
            }
            if (nbottom) {
                *(pixel+x+(y+1)*width) += 5 * error / 16;
            }
            if (nright && nbottom) {
                *(pixel+(x+1)+(y+1)*width) += error / 16;
            }
        }
    }
    return pixel;
}

int* imageBuffer(int* pixel, int height, int width) {
    int oldpixel, newpixel = 0;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int offset = x + y*width;
            oldpixel = *(pixel + offset);
//            int tmppixel = oldpixel - 128;
//            double scale = (double)tmppixel / 128.0;
//            double tmp;
//            if (tmppixel > 0) {
//                tmp = pow(scale - 1, 3) - 1;
//            }else {
//                tmp = pow(scale + 1, 3) - 1;
//            }
//            newpixel = oldpixel * tmp;
            
            if (oldpixel < 170) {
                newpixel = oldpixel - (oldpixel - 170) * 0.5;
            }else {
                newpixel = oldpixel;
            }
            

            *(pixel + offset) = newpixel;
        }
    }
    return pixel;
}

typedef unsigned long DWORD;
typedef unsigned long LONG;
typedef unsigned short WORD;
typedef Byte BYTE;
typedef struct tagBITMAPFILEHEADER
{
    WORD bfType;//位图文件的类型，必须为BM(1-2字节）
    DWORD bfSize;//位图文件的大小，以字节为单位（3-6字节，低位在前）
    WORD bfReserved1;//位图文件保留字，必须为0(7-8字节）
    WORD bfReserved2;//位图文件保留字，必须为0(9-10字节）
    DWORD bfOffBits;//位图数据的起始位置，以相对于位图（11-14字节，低位在前）
    //文件头的偏移量表示，以字节为单位
}BITMAPFILEHEADER;

typedef struct tagBITMAPINFOHEADER{
    DWORD biSize;//本结构所占用字节数（15-18字节）
    LONG biWidth;//位图的宽度，以像素为单位（19-22字节）
    LONG biHeight;//位图的高度，以像素为单位（23-26字节）
    WORD biPlanes;//目标设备的级别，必须为1(27-28字节）
    WORD biBitCount;//每个像素所需的位数，必须是1（双色），（29-30字节）
    //4(16色），8(256色）16(高彩色)或24（真彩色）之一
    DWORD biCompression;//位图压缩类型，必须是0（不压缩），（31-34字节）
    //1(BI_RLE8压缩类型）或2(BI_RLE4压缩类型）之一
    DWORD biSizeImage;//位图的大小(其中包含了为了补齐行数是4的倍数而添加的空字节)，以字节为单位（35-38字节）
    LONG biXPelsPerMeter;//位图水平分辨率，每米像素数（39-42字节）
    LONG biYPelsPerMeter;//位图垂直分辨率，每米像素数（43-46字节)
    DWORD biClrUsed;//位图实际使用的颜色表中的颜色数（47-50字节）
    DWORD biClrImportant;//位图显示过程中重要的颜色数（51-54字节）
}BITMAPINFOHEADER;

typedef struct tagRGBQUAD{
    BYTE rgbBlue;//蓝色的亮度（值范围为0-255)
    BYTE rgbGreen;//绿色的亮度（值范围为0-255)
    BYTE rgbRed;//红色的亮度（值范围为0-255)
    BYTE rgbReserved;//保留，必须为0
}RGBQUAD;
typedef struct tagBITMAPINFO{
    BITMAPINFOHEADER bmiHeader;//位图信息头
    RGBQUAD bmiColors[1];//颜色表
}BITMAPINFO;

+ (UIImage *)LK_byteMapImage:(NSData *)data{
    UIImage *image = [UIImage imageWithData:data];
    
    return image;
}

/// 将图片转换为byte
+ (NSData *)LK_byteMapWithImage:(UIImage *)originalImage{
    CGImageRef imageRef = originalImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
//    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
//    int red,grn,blu;
    UInt32 *average = malloc(sizeof(UInt32)*width*height);
    
    long newBufLen = (width)/32*4*height;
    UInt8 *newBuffer = malloc(sizeof(UInt8) * newBufLen);
    memset(newBuffer, 0x000, newBufLen);
    
    int  x, y;
    
    //用于传输的排列
    //点阵排列
    int realWidth = (width)/32 * 32;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            //第几点像素
            int colorValue = *(average + y * width + x);
            //需要颠倒
            NSUInteger bmpOffset = (height - 1 - y) * realWidth + x;
            UInt8 *tmpNew = newBuffer + bmpOffset/8;
            //                判断黑白
            if(colorValue < 122)
            {
                //设置为黑色, 当前字节，设置第几位黑色
                NSUInteger needMoveBit = 7-bmpOffset%8;
                *tmpNew = *tmpNew | (0b00000001<<needMoveBit);
            }
        }
    }
    
    NSData *dataFile = [NSData dataWithBytes:newBuffer length:newBufLen];
    free(newBuffer);
    
    return  dataFile;
}

//转单色位图字符串数据
+ (UIImage *)createBmpImg:(UInt32 *)ditherData with:(int)width and:(int)height {
    BITMAPFILEHEADER bmpFileHeader;
    BITMAPINFO bmpInfo;
    bmpFileHeader.bfType = 0x4d42;
    bmpFileHeader.bfReserved1 = 0;
    bmpFileHeader.bfReserved2 = 0;
    bmpFileHeader.bfOffBits = 62;
    
    bmpInfo.bmiHeader.biSize = 40;
    bmpInfo.bmiHeader.biWidth = width;
    bmpInfo.bmiHeader.biHeight = height;
    bmpInfo.bmiHeader.biPlanes = 1;
    bmpInfo.bmiHeader.biBitCount = 1;
    bmpInfo.bmiHeader.biCompression = 0;
    bmpInfo.bmiHeader.biSizeImage = (bmpInfo.bmiHeader.biWidth*bmpInfo.bmiHeader.biBitCount+31)/32*4*bmpInfo.bmiHeader.biHeight;//
    bmpInfo.bmiHeader.biXPelsPerMeter = 0;
    bmpInfo.bmiHeader.biYPelsPerMeter = 0;
    bmpInfo.bmiHeader.biClrUsed = 0;
    bmpInfo.bmiHeader.biClrImportant = 0;
    
    bmpFileHeader.bfSize = bmpFileHeader.bfOffBits+bmpInfo.bmiHeader.biSizeImage;
    
    bmpInfo.bmiColors[0].rgbRed = 0xff;
    bmpInfo.bmiColors[0].rgbGreen = 0xff;
    bmpInfo.bmiColors[0].rgbBlue = 0xff;
    bmpInfo.bmiColors[0].rgbReserved = 0x00;
    
    CFIndex newBufLen = bmpFileHeader.bfSize;//整个bmp文件必须是4字节的整数倍
    UInt8 *newBuffer = malloc(sizeof(UInt8) * newBufLen);
    memset(newBuffer, 0x000, newBufLen);
    
    //构造文件头
    
    memcpy(newBuffer,   &bmpFileHeader.bfType, sizeof(WORD));
    memcpy(newBuffer+2, &bmpFileHeader.bfSize, sizeof(DWORD));
    memcpy(newBuffer+6, &bmpFileHeader.bfReserved1, sizeof(WORD));
    memcpy(newBuffer+8, &bmpFileHeader.bfReserved2, sizeof(WORD));
    memcpy(newBuffer+10, &bmpFileHeader.bfOffBits, sizeof(DWORD));

    memcpy(newBuffer+14, &bmpInfo.bmiHeader.biSize, sizeof(DWORD));
    memcpy(newBuffer+18, &bmpInfo.bmiHeader.biWidth, sizeof(DWORD));
    memcpy(newBuffer+22, &bmpInfo.bmiHeader.biHeight, sizeof(DWORD));
    memcpy(newBuffer+26, &bmpInfo.bmiHeader.biPlanes, sizeof(WORD));
    memcpy(newBuffer+28, &bmpInfo.bmiHeader.biBitCount, sizeof(WORD));
    memcpy(newBuffer+30, &bmpInfo.bmiHeader.biCompression, sizeof(DWORD));
    memcpy(newBuffer+34, &bmpInfo.bmiHeader.biSizeImage, sizeof(DWORD));
    memcpy(newBuffer+38, &bmpInfo.bmiHeader.biXPelsPerMeter, sizeof(DWORD));
    memcpy(newBuffer+42, &bmpInfo.bmiHeader.biYPelsPerMeter, sizeof(DWORD));
    memcpy(newBuffer+46, &bmpInfo.bmiHeader.biClrUsed, sizeof(DWORD));
    memcpy(newBuffer+50, &bmpInfo.bmiHeader.biClrImportant, sizeof(DWORD));

    memcpy(newBuffer + 54, &bmpInfo.bmiColors[0].rgbRed, sizeof(BYTE));
    memcpy(newBuffer + 55, &bmpInfo.bmiColors[0].rgbGreen, sizeof(BYTE));
    memcpy(newBuffer + 56, &bmpInfo.bmiColors[0].rgbBlue, sizeof(BYTE));
    
    int  x, y;
    //用于传输的排列
    //点阵排列
    int realWidth = (width+31)/32 * 32;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            //第几点像素
            int colorValue = *(ditherData + y * width + x);
            //需要颠倒
            NSUInteger bmpOffset = (height - 1 - y) * realWidth + x;
            UInt8 *tmpNew = newBuffer +bmpFileHeader.bfOffBits + bmpOffset/8;//这里的偏移62，是bmp图片的头部信息，后面才是图片颜色数据
            //                判断黑白
            if(colorValue < 122)
            {
                //设置为黑色, 当前字节，设置第几位黑色
                NSUInteger needMoveBit = 7-bmpOffset%8;
                *tmpNew = *tmpNew | (0b00000001<<needMoveBit);
            }
        }
    }
    NSData *dataFile = [NSData dataWithBytes:newBuffer length:newBufLen];
    free(newBuffer);
    UIImage *image = [UIImage imageWithData:dataFile];
    return image;
}

//转单色位图字符串数据
+ (NSData *)LKcreateBmpImg:(UInt32 *)ditherData with:(int)width and:(int)height {
    BITMAPFILEHEADER bmpFileHeader;
    BITMAPINFO bmpInfo;
    bmpFileHeader.bfType = 0x4d42;
    bmpFileHeader.bfReserved1 = 0;
    bmpFileHeader.bfReserved2 = 0;
    bmpFileHeader.bfOffBits = 62;
    
    bmpInfo.bmiHeader.biSize = 40;
    bmpInfo.bmiHeader.biWidth = width;
    bmpInfo.bmiHeader.biHeight = height;
    bmpInfo.bmiHeader.biPlanes = 1;
    bmpInfo.bmiHeader.biBitCount = 1;
    bmpInfo.bmiHeader.biCompression = 0;
    bmpInfo.bmiHeader.biSizeImage = (bmpInfo.bmiHeader.biWidth*bmpInfo.bmiHeader.biBitCount+31)/32*4*bmpInfo.bmiHeader.biHeight;//
    bmpInfo.bmiHeader.biXPelsPerMeter = 0;
    bmpInfo.bmiHeader.biYPelsPerMeter = 0;
    bmpInfo.bmiHeader.biClrUsed = 0;
    bmpInfo.bmiHeader.biClrImportant = 0;
    
    bmpFileHeader.bfSize = bmpFileHeader.bfOffBits+bmpInfo.bmiHeader.biSizeImage;
    
    bmpInfo.bmiColors[0].rgbRed = 0xff;
    bmpInfo.bmiColors[0].rgbGreen = 0xff;
    bmpInfo.bmiColors[0].rgbBlue = 0xff;
    bmpInfo.bmiColors[0].rgbReserved = 0x00;
    
    CFIndex newBufLen = bmpFileHeader.bfSize;//整个bmp文件必须是4字节的整数倍
    UInt8 *newBuffer = malloc(sizeof(UInt8) * newBufLen);
    memset(newBuffer, 0x000, newBufLen);
    
    //构造文件头
    
    memcpy(newBuffer,   &bmpFileHeader.bfType, sizeof(WORD));
    memcpy(newBuffer+2, &bmpFileHeader.bfSize, sizeof(DWORD));
    memcpy(newBuffer+6, &bmpFileHeader.bfReserved1, sizeof(WORD));
    memcpy(newBuffer+8, &bmpFileHeader.bfReserved2, sizeof(WORD));
    memcpy(newBuffer+10, &bmpFileHeader.bfOffBits, sizeof(DWORD));

    memcpy(newBuffer+14, &bmpInfo.bmiHeader.biSize, sizeof(DWORD));
    memcpy(newBuffer+18, &bmpInfo.bmiHeader.biWidth, sizeof(DWORD));
    memcpy(newBuffer+22, &bmpInfo.bmiHeader.biHeight, sizeof(DWORD));
    memcpy(newBuffer+26, &bmpInfo.bmiHeader.biPlanes, sizeof(WORD));
    memcpy(newBuffer+28, &bmpInfo.bmiHeader.biBitCount, sizeof(WORD));
    memcpy(newBuffer+30, &bmpInfo.bmiHeader.biCompression, sizeof(DWORD));
    memcpy(newBuffer+34, &bmpInfo.bmiHeader.biSizeImage, sizeof(DWORD));
    memcpy(newBuffer+38, &bmpInfo.bmiHeader.biXPelsPerMeter, sizeof(DWORD));
    memcpy(newBuffer+42, &bmpInfo.bmiHeader.biYPelsPerMeter, sizeof(DWORD));
    memcpy(newBuffer+46, &bmpInfo.bmiHeader.biClrUsed, sizeof(DWORD));
    memcpy(newBuffer+50, &bmpInfo.bmiHeader.biClrImportant, sizeof(DWORD));

    memcpy(newBuffer + 54, &bmpInfo.bmiColors[0].rgbRed, sizeof(BYTE));
    memcpy(newBuffer + 55, &bmpInfo.bmiColors[0].rgbGreen, sizeof(BYTE));
    memcpy(newBuffer + 56, &bmpInfo.bmiColors[0].rgbBlue, sizeof(BYTE));
    
    int  x, y;
    //用于传输的排列
    //点阵排列
    int realWidth = (width+31)/32 * 32;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            //第几点像素
            int colorValue = *(ditherData + y * width + x);
            //需要颠倒
            NSUInteger bmpOffset = (height - 1 - y) * realWidth + x;
            UInt8 *tmpNew = newBuffer +bmpFileHeader.bfOffBits + bmpOffset/8;//这里的偏移62，是bmp图片的头部信息，后面才是图片颜色数据
            //                判断黑白
            if(colorValue < 122)
            {
                //设置为黑色, 当前字节，设置第几位黑色
                NSUInteger needMoveBit = 7-bmpOffset%8;
                *tmpNew = *tmpNew | (0b00000001<<needMoveBit);
            }
        }
    }
    NSData *dataFile = [NSData dataWithBytes:newBuffer length:newBufLen];
    free(newBuffer);
//    UIImage *image = [UIImage imageWithData:dataFile];
    return dataFile;
}

+ (UIImage *)setLightWithImage:(UIImage *)oldImage BrightValue:(CGFloat)brightValue ContrastValue:(CGFloat)contrastValue {
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    brightnessFilter.brightness = brightValue;
    UIImage *tempImg = [brightnessFilter imageByFilteringImage:oldImage];
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    contrastFilter.contrast = contrastValue;
    UIImage *edgeImg = [contrastFilter imageByFilteringImage:tempImg];
    
    return edgeImg;
}

#pragma mark - 文本样式图片处理

+ (UIImage *)dealWithImageForText:(UIImage *)originalImage withImageWidth:(NSInteger)width {
    UIImage *image = [originalImage copy];
//    GPUImageSharpenFilter *sharpenFilter = [[GPUImageSharpenFilter alloc] init];
//    sharpenFilter.sharpness = 4.0;
//    UIImage *image = [sharpenFilter imageByFilteringImage:originalImage];
    
    NSInteger imageW = width;
    NSInteger imageH = imageW*image.size.height/image.size.width;
    image = [image gg_scaleSize:CGSizeMake(imageW, imageH)];
    
    image = [self doDitherTextImage:image];
    
    return image;
}

+ (UIImage*)doDitherTextImage:(UIImage*)anImage {
    
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    int red,grn,blu;
    UInt32 *average = malloc(sizeof(UInt32)*width*height);
    memset(average, 0x0000, sizeof(UInt32)*width*height);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    CFRelease(data);

    //每个像素点所占字节
    size_t bytesPerPixel = bytesPerRow/width;
//    size_t picOffset = 0;
    if (bytesPerPixel == 1) {
//        picOffset = 206;
    }
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            UInt8 *tmpBuf = buffer+(x+y*width)*bytesPerPixel;
            int nAverage = *tmpBuf;
            
            if (1 != bytesPerPixel) {
                //不是单色的位图
                red = *(tmpBuf); // unsigned int
                grn = *(tmpBuf+1); // unsigned int
                blu = *(tmpBuf+2); // unsigned int
                //0.30 RED + 0.59 GREEN + 0.11 BLUE 灰度处理
                //                nAverage =0.3*red+0.59*grn+0.11*blu;
                nAverage = (77 * red + 151 * grn + 28 * blu) / 256;
            }
            else
            {
                nAverage = 255-nAverage;
            }
            
            *(average+x+y*width) = nAverage;
        }
    }
    
    UInt32 *outputaverage =  ditherCopyForText((int *)average, (int)height, (int)width);
    
    UIImage *outputImage = [self createBmpImg:outputaverage with:(int)width and:(int)height];
    free(average);
    free(outputaverage);
    return outputImage;
}

//点阵疏密程度算法
int* ditherCopyForText(int* pixel, int height, int width) {
    UInt32 *average = malloc(sizeof(UInt32)*width*height);
    memset(average, 0x0000, sizeof(UInt32)*width*height);
    
    int oldpixel, newpixel;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int offset = x + y*width;
            oldpixel = *(pixel + offset);//旧像素值
            oldpixel = 255 - oldpixel;//对调,255黑
            
            newpixel = oldpixel < 90 ? 0 : 255;
            if (y != 0 && x != 0) {
                if (oldpixel > 80) {//103
                    int leftpixel = *(pixel + (x-1) + y*width);
                    leftpixel = 255 - leftpixel;
                    int toppixel = *(pixel + x + (y-1)*width);
                    toppixel = 255 - toppixel;
                    if (newpixel == 0) {
                        if (oldpixel + leftpixel > 160) {
                            newpixel = 255;
                        }else if (oldpixel + toppixel > 160) {
                            newpixel = 255;
                        }
                    }
                }
            }
            if (y == height - 1) {
                newpixel = 0;
            }
            *(average + offset) = 255 - newpixel;
        }
    }
    
    UInt32 *average2 = malloc(sizeof(UInt32)*width*height);
    memset(average2, 0x0000, sizeof(UInt32)*width*height);
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int tmppixel = *(average + x + y*width);
            if (tmppixel == 0) {
                if (x != 0 && y != 0 && x != width - 1 && y != height - 1) {
                    int tmp = *(average + (x+1) + (y-1)*width) + *(average + (x+1) + y*width) + *(average + (x+1) + (y+1)*width);
                    if (tmp <= 255) {
                        int tmp2 = *(average + (x+1) + y*width);
                        int tmp3 = *(average + (x-1) + y*width);
                        if (tmp2 == 0 && tmp3 == 255) {
                            tmppixel = 255;
                        }
                    }
                }
            }
            *(average2 + x + y*width) = tmppixel;
        }
    }
    
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int tmppixel = *(average2 + x + y*width);
            if (tmppixel == 0) {
                if (x != 0 && y != 0 && x != width - 1 && y != height - 1) {
                    int tmp = *(average2 + (x-1) + (y+1)*width) + *(average2 + x + (y+1)*width) + *(average2 + (x+1) + (y+1)*width);
                    if (tmp <= 255) {
                        int tmp2 = *(average2 + x + (y+1)*width);
                        int tmp3 = *(average2 + x + (y-1)*width);
                        if (tmp2 == 0 && tmp3 == 255) {
                            tmppixel = 255;
                        }
                    }
                }
            }
            *(average + x + y*width) = tmppixel;
        }
    }
    free(average2);

    return average;
}

#pragma mark - Html样式图片处理
+ (UIImage *)dealWithImageForHtml:(UIImage *)originalImage withImageWidth:(NSInteger)width {
    NSInteger imageW = width;
    NSInteger imageH = imageW*originalImage.size.height/originalImage.size.width;
    UIImage *image = [originalImage gg_scaleSize:CGSizeMake(imageW, imageH)];
    
    GPUImageAdaptiveThresholdFilter *sketchFilter = [[GPUImageAdaptiveThresholdFilter alloc] init];
    sketchFilter.blurRadiusInPixels = 25;
    UIImage *sketchImg2 = [sketchFilter imageByFilteringImage:image];
    
    
    image = [self doDitherHtmlImage:sketchImg2];
    
    return image;
}

+ (UIImage*)doDitherHtmlImage:(UIImage*)anImage {
    
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    int red,grn,blu;
    UInt32 *average = malloc(sizeof(UInt32)*width*height);
    memset(average, 0x0000, sizeof(UInt32)*width*height);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    CFRelease(data);

    //每个像素点所占字节
    size_t bytesPerPixel = bytesPerRow/width;
//    size_t picOffset = 0;
    if (bytesPerPixel == 1) {
//        picOffset = 206;
    }
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            UInt8 *tmpBuf = buffer+(x+y*width)*bytesPerPixel;
            int nAverage = *tmpBuf;
            
            if (1 != bytesPerPixel) {
                //不是单色的位图
                red = *(tmpBuf); // unsigned int
                grn = *(tmpBuf+1); // unsigned int
                blu = *(tmpBuf+2); // unsigned int
                //0.30 RED + 0.59 GREEN + 0.11 BLUE 灰度处理
                //                nAverage =0.3*red+0.59*grn+0.11*blu;
                nAverage = (77 * red + 151 * grn + 28 * blu) / 256;
            }
            else
            {
                nAverage = 255-nAverage;
            }
            
            *(average+x+y*width) = nAverage;
        }
    }
    
//    UInt32 *outputaverage = ditherCopyForHtml((int *)average, (int)height, (int)width);
    
    UIImage *outputImage = [self createBmpImg:average with:(int)width and:(int)height];
    free(average);
//    free(outputaverage);
    return outputImage;
}


//点阵疏密程度算法
int* ditherCopyForHtml(int* pixel, int height, int width) {
    UInt32 *average = malloc(sizeof(UInt32)*width*height);
    memset(average, 0x0000, sizeof(UInt32)*width*height);
    
    int oldpixel, newpixel;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int offset = x + y*width;
            oldpixel = *(pixel + offset);//旧像素值
            oldpixel = 255 - oldpixel;//对调,255黑
            
            newpixel = oldpixel < 100 ? 0 : 255;
            if (y != 0 && x != 0) {
                if (oldpixel > 80) {//103
                    int leftpixel = *(pixel + (x-1) + y*width);
                    leftpixel = 255 - leftpixel;
                    int toppixel = *(pixel + x + (y-1)*width);
                    toppixel = 255 - toppixel;
                    if (newpixel == 0) {
                        if (oldpixel + leftpixel > 160) {
                            newpixel = 255;
                        }else if (oldpixel + toppixel > 160) {
                            newpixel = 255;
                        }
                    }
                }
            }
            if (y == height - 1) {
                newpixel = 0;
            }
            *(average + offset) = 255 - newpixel;
        }
    }
    
//    UInt32 *average2 = malloc(sizeof(UInt32)*width*height);
//    memset(average2, 0x0000, sizeof(UInt32)*width*height);
//    for (int y = 0; y < height; y++) {
//        for (int x = 0; x < width; x++) {
//            int tmppixel = *(average + x + y*width);
//            if (tmppixel == 0) {
//                if (x != 0 && y != 0 && x != width - 1 && y != height - 1) {
//                    int tmp = *(average + (x+1) + (y-1)*width) + *(average + (x+1) + y*width) + *(average + (x+1) + (y+1)*width);
//                    if (tmp <= 255) {
//                        int tmp2 = *(average + (x+1) + y*width);
//                        int tmp3 = *(average + (x-1) + y*width);
//                        if (tmp2 == 0 && tmp3 == 255) {
//                            tmppixel = 255;
//                        }
//                    }
//                }
//            }
//            *(average2 + x + y*width) = tmppixel;
//        }
//    }
//
//    for (int y = 0; y < height; y++) {
//        for (int x = 0; x < width; x++) {
//            int tmppixel = *(average2 + x + y*width);
//            if (tmppixel == 0) {
//                if (x != 0 && y != 0 && x != width - 1 && y != height - 1) {
//                    int tmp = *(average2 + (x-1) + (y+1)*width) + *(average2 + x + (y+1)*width) + *(average2 + (x+1) + (y+1)*width);
//                    if (tmp <= 255) {
//                        int tmp2 = *(average2 + x + (y+1)*width);
//                        int tmp3 = *(average2 + x + (y-1)*width);
//                        if (tmp2 == 0 && tmp3 == 255) {
//                            tmppixel = 255;
//                        }
//                    }
//                }
//            }
//            *(average + x + y*width) = tmppixel;
//        }
//    }
//    free(average2);

    return average;
}
#pragma mark - 图片格式转换

///单色位图的image转字符串数据base64字符串
+ (NSString *)convertBmpImageToBmpBase64Str:(UIImage *)image {
    return [self convertBmpImageToBmpBase64Str:image isNeedMirrorImage:YES];
}
+ (NSString *)convertBmpImageToRightBmpBase64Str:(UIImage *)image {
    return [self convertBmpImageToBmpBase64Str:image isNeedMirrorImage:NO];
}
+ (NSString *)convertBmpImageToBmpBase64Str:(UIImage *)image isNeedMirrorImage:(BOOL)isNeedMirrorImage {
    NSData *dataFile = [self convertBmpImageToBmpBaseData:image isNeedMirrorImage:isNeedMirrorImage];
    NSString *base64Str = [dataFile base64EncodedStringWithOptions:0];
    return base64Str;
}

///单色位图的image转NSData
+ (NSData *)convertBmpImageToBmpBaseData:(UIImage *)image {
    return [self convertBmpImageToBmpBaseData:image isNeedMirrorImage:YES];
}
+ (NSData *)convertBmpImageToRightBmpBaseData:(UIImage *)image {
    return [self convertBmpImageToBmpBaseData:image isNeedMirrorImage:NO];
}
+ (NSData *)convertBmpImageToBmpBaseData:(UIImage *)image isNeedMirrorImage:(BOOL)isNeedMirrorImage {
    CGImageRef imageRef;
    imageRef = image.CGImage;
    
    if (!imageRef) {
        NSLog(@"图片为空或异常");
        image = [UIImage imageNamed:@"PrintFailed"];
        imageRef = image.CGImage;;
    }
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    BITMAPFILEHEADER bmpFileHeader;
    BITMAPINFO bmpInfo;
    bmpFileHeader.bfType = 0x4d42;
    bmpFileHeader.bfReserved1 = 0;
    bmpFileHeader.bfReserved2 = 0;
    bmpFileHeader.bfOffBits = 62;
    
    bmpInfo.bmiHeader.biSize = 40;
    bmpInfo.bmiHeader.biWidth = width;
    bmpInfo.bmiHeader.biHeight = height;
    bmpInfo.bmiHeader.biPlanes = 1;
    bmpInfo.bmiHeader.biBitCount = 1;
    bmpInfo.bmiHeader.biCompression = 0;
    bmpInfo.bmiHeader.biSizeImage = (bmpInfo.bmiHeader.biWidth*bmpInfo.bmiHeader.biBitCount+31)/32*4*bmpInfo.bmiHeader.biHeight;//
    bmpInfo.bmiHeader.biXPelsPerMeter = 0;
    bmpInfo.bmiHeader.biYPelsPerMeter = 0;
    bmpInfo.bmiHeader.biClrUsed = 0;
    bmpInfo.bmiHeader.biClrImportant = 0;
    
    bmpFileHeader.bfSize = bmpFileHeader.bfOffBits+bmpInfo.bmiHeader.biSizeImage;
    
    bmpInfo.bmiColors[0].rgbRed = 0xff;
    bmpInfo.bmiColors[0].rgbGreen = 0xff;
    bmpInfo.bmiColors[0].rgbBlue = 0xff;
    bmpInfo.bmiColors[0].rgbReserved = 0x00;
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    
    
    CFIndex newBufLen = bmpFileHeader.bfSize;//整个bmp文件必须是4字节的整数倍
    UInt8 *newBuffer = malloc(sizeof(UInt8) * newBufLen);
    memset(newBuffer, 0x000, newBufLen);
    
    //构造文件头
    
    memcpy(newBuffer,   &bmpFileHeader.bfType, sizeof(WORD));
    memcpy(newBuffer+2, &bmpFileHeader.bfSize, sizeof(DWORD));
    memcpy(newBuffer+6, &bmpFileHeader.bfReserved1, sizeof(WORD));
    memcpy(newBuffer+8, &bmpFileHeader.bfReserved2, sizeof(WORD));
    memcpy(newBuffer+10, &bmpFileHeader.bfOffBits, sizeof(DWORD));
    
    memcpy(newBuffer+14, &bmpInfo.bmiHeader.biSize, sizeof(DWORD));
    memcpy(newBuffer+18, &bmpInfo.bmiHeader.biWidth, sizeof(DWORD));
    memcpy(newBuffer+22, &bmpInfo.bmiHeader.biHeight, sizeof(DWORD));
    memcpy(newBuffer+26, &bmpInfo.bmiHeader.biPlanes, sizeof(WORD));
    memcpy(newBuffer+28, &bmpInfo.bmiHeader.biBitCount, sizeof(WORD));
    memcpy(newBuffer+30, &bmpInfo.bmiHeader.biCompression, sizeof(DWORD));
    memcpy(newBuffer+34, &bmpInfo.bmiHeader.biSizeImage, sizeof(DWORD));
    memcpy(newBuffer+38, &bmpInfo.bmiHeader.biXPelsPerMeter, sizeof(DWORD));
    memcpy(newBuffer+42, &bmpInfo.bmiHeader.biYPelsPerMeter, sizeof(DWORD));
    memcpy(newBuffer+46, &bmpInfo.bmiHeader.biClrUsed, sizeof(DWORD));
    memcpy(newBuffer+50, &bmpInfo.bmiHeader.biClrImportant, sizeof(DWORD));
    
    memcpy(newBuffer + 54, &bmpInfo.bmiColors[0].rgbRed, sizeof(BYTE));
    memcpy(newBuffer + 55, &bmpInfo.bmiColors[0].rgbGreen, sizeof(BYTE));
    memcpy(newBuffer + 56, &bmpInfo.bmiColors[0].rgbBlue, sizeof(BYTE));
    
    //每个像素点所占的字节数
    NSUInteger  x, y;
    size_t realWidth = (width+31)/32 * 32;
    if(isNeedMirrorImage) {
        for (y = 0; y < height; y++) {
            for (x = 0; x < width; x++) {
                //第几点像素
                UInt8 colorValue = *(buffer + y * width + x);
                NSUInteger bmpOffset = y*realWidth + x;
                UInt8 *tmpNew = newBuffer +bmpFileHeader.bfOffBits + bmpOffset/8;//这里的偏移62，是bmp图片的头部信息，后面才是图片数据//8个点为位图中的一个字节
                
                //判断黑白
                if(colorValue > 122)
                {
                    //设置为黑色, 当前字节，设置第几位黑色
                    NSUInteger needMoveBit = 7-bmpOffset%8;
                    *tmpNew = *tmpNew | (0b00000001<<needMoveBit);
                }
            }
        }
    } else {
        for (y = height; y > 0; y--) {
            for (x = 0; x < width; x++) {
                //第几点像素
                UInt8 colorValue = *(buffer + y * width + x);
                NSUInteger bmpOffset = (height - y)*realWidth + x;
                UInt8 *tmpNew = newBuffer +bmpFileHeader.bfOffBits + bmpOffset/8;//这里的偏移62，是bmp图片的头部信息，后面才是图片数据//8个点为位图中的一个字节
                
                //判断黑白
                if(colorValue > 122)
                {
                    //设置为黑色, 当前字节，设置第几位黑色
                    NSUInteger needMoveBit = 7-bmpOffset%8;
                    *tmpNew = *tmpNew | (0b00000001<<needMoveBit);
                }
            }
        }
    }
    NSData *dataFile = [NSData dataWithBytes:newBuffer length:newBufLen];
    free(newBuffer);
    CFRelease(data);
    return dataFile;
}

#pragma mark - 其他图片处理

+ (UIImage *)dealWithImageForSearch:(UIImage *)originalImage {
    UIImage *tempImage = [self doDither:originalImage Filter:EFilterWord BrightValue:0.0f ContrastValue:1.0f];
    
    CGImageRef imageRef = tempImage.CGImage;
        
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
        
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
        
    int red,grn,blu;
    UInt32 *average = malloc(sizeof(UInt32)*width*height);
    memset(average, 0x0000, sizeof(UInt32)*width*height);
        
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    CFRelease(data);

    //每个像素点所占字节
    size_t bytesPerPixel = bytesPerRow/width;
//    size_t picOffset = 0;
    if (bytesPerPixel == 1) {
//        picOffset = 206;
    }
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            UInt8 *tmpBuf = buffer+(x+y*width)*bytesPerPixel;
            int nAverage = *tmpBuf;
            
            if (1 != bytesPerPixel) {
                //不是单色的位图
                red = *(tmpBuf); // unsigned int
                grn = *(tmpBuf+1); // unsigned int
                blu = *(tmpBuf+2); // unsigned int
                //0.30 RED + 0.59 GREEN + 0.11 BLUE 灰度处理
                //                nAverage =0.3*red+0.59*grn+0.11*blu;
                nAverage = (77 * red + 151 * grn + 28 * blu) / 256;
            }
            else
            {
                nAverage = 255-nAverage;
            }
            
            *(average+x+y*width) = nAverage;
        }
    }
    
    NSMutableArray *rowArray = [[NSMutableArray alloc]init];//行数据,黑色点数量
    NSMutableArray *lineArray = [[NSMutableArray alloc]init];//列数据
//    UInt32 *average2 = malloc(sizeof(UInt32)*width*height);
//    memset(average2, 0x0000, sizeof(UInt32)*width*height);
    int count = 0;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int tmppixel = *(average + x + y*width);
            if (tmppixel == 255) {
                count ++;
            }
        }
        [rowArray addObject:[NSNumber numberWithInt:count]];
        count = 0;
    }
    
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            int tmppixel = *(average + x + y*width);
            if (tmppixel == 255) {
                count ++;
            }
        }
        [lineArray addObject:[NSNumber numberWithInt:count]];
        count = 0;
    }
    
    float sum = 0,avg = 0,var = 0;
    for (NSNumber *num in rowArray) {
        sum += num.floatValue;
    }
    avg = sum / rowArray.count;
    for (NSNumber *num in rowArray) {
        var += pow(num.floatValue - avg,2)/rowArray.count;
    }
    NSLog(@"行方差 == %f",var);
    
    sum = 0;avg = 0;var = 0;
    for (NSNumber *num in lineArray) {
        sum += num.floatValue;
    }
    avg = sum / lineArray.count;
    for (NSNumber *num in lineArray) {
        var += pow(num.floatValue - avg,2)/lineArray.count;
    }
    NSLog(@"列方差 == %f",var);
    
    UIImage *outputImage = [self createBmpImg:average with:(int)width and:(int)height];
    free(average);
    return tempImage;
}


struct Img {
    int *pixel;
    int width;
    int height;
};

struct ImgArray {
    struct Img imageArray[50];
    int count;
};

+ (NSArray<UIImage *> *)cutImageForHorizontalPrint:(UIImage *)orininalImage wihtHeight:(NSInteger)cutHeight {
    NSInteger imageW = (int)orininalImage.size.width / 8 * 8;
    NSInteger imageH = imageW*orininalImage.size.height/orininalImage.size.width;
    orininalImage = [orininalImage gg_scaleSize:CGSizeMake(imageW, imageH)];
    
    CGImageRef imageRef = orininalImage.CGImage;
        
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
        
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
        
    int red,grn,blu;
    UInt32 *average = malloc(sizeof(UInt32)*width*height);
    memset(average, 0x0000, sizeof(UInt32)*width*height);
        
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    CFRelease(data);

    //每个像素点所占字节
    size_t bytesPerPixel = bytesPerRow/width;
//    size_t picOffset = 0;
    if (bytesPerPixel == 1) {
//        picOffset = 206;
    }
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            UInt8 *tmpBuf = buffer+(x+y*width)*bytesPerPixel;
            int nAverage = *tmpBuf;
            
            if (1 != bytesPerPixel) {
                //不是单色的位图
                red = *(tmpBuf); // unsigned int
                grn = *(tmpBuf+1); // unsigned int
                blu = *(tmpBuf+2); // unsigned int
                //0.30 RED + 0.59 GREEN + 0.11 BLUE 灰度处理
                //                nAverage =0.3*red+0.59*grn+0.11*blu;
                nAverage = (77 * red + 151 * grn + 28 * blu) / 256;
            }
            else
            {
                nAverage = 255-nAverage;
            }
            
            *(average+x+y*width) = nAverage;
        }
    }
    
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    struct ImgArray tmpArray = cutImage((int *)average, (int)height, (int)width, (int)cutHeight * height / orininalImage.size.height);
    struct Img *imageArray = tmpArray.imageArray;
    for (int i = 0; i < tmpArray.count; i++) {
        struct Img img = *(imageArray + i);
        struct Img compareImg = compareImage(img, (int)cutHeight * height / orininalImage.size.height);
        UIImage *tmpImage = [self createBmpImg:(UInt32 *)compareImg.pixel with:compareImg.width and:compareImg.height];
        [returnArray addObject:tmpImage];
    }
    free(average);
    return returnArray;
}

//将裁剪好的图片补到指定宽度
struct Img compareImage(struct Img img, int compareHeight) {
    int width = img.width;
    int height = img.height;
    int *pixel = img.pixel;
    
    UInt32 *average = malloc(sizeof(UInt32)*width*compareHeight);
    memset(average, 0x0000, sizeof(UInt32)*width*compareHeight);
    
    for (int y = 0; y < compareHeight; y++) {
        for (int x = 0; x < width; x++) {
            int offset = x + y*width;
            if (y < height) {
                *(average + offset) = *(pixel + offset);
            }else {
                *(average + offset) = 255;
            }
            
        }
    }
    
    struct Img returnImg;
    returnImg.width = width;
    returnImg.height = compareHeight;
    returnImg.pixel = average;
    return returnImg;
}

struct ImgArray cutImage(int* pixel, int height, int width, int cutHeight) {
    int oldpixel;
        
    int blockArray[height];
    int blockCount = 0;
    int currentCount = 0;
    bool blackOrWhite = YES;
    bool firstLineisBlack = YES;
    
    for (int y = 0; y < height; y++) {
        int count = 0;
        for (int x = 0; x < width; x++) {
            int offset = x + y*width;
            oldpixel = *(pixel + offset);//旧像素值
            count += oldpixel;
        }
        if (y == 0) {
            if (count == 255 * width) {
                firstLineisBlack = NO;
                blackOrWhite = NO;
            }else {
                firstLineisBlack = YES;
                blackOrWhite = YES;
            }
        }
        
        if (count == 255 * width) {//当前是白色
            if (blackOrWhite) {//如果当前在数黑色
                blockArray[blockCount] = currentCount;//将当前块的行数写入列表
                blockCount ++;//块数量计数
                blackOrWhite = NO;//改为计算白块行数
                currentCount = 1;
            }else {
                currentCount ++;
            }
        }else {//当前是黑色
            if (blackOrWhite) {//如果当前在数黑色
                currentCount ++;
            }else {
                blockArray[blockCount] = currentCount;//将当前块的行数写入列表
                blockCount ++;//块数量计数
                blackOrWhite = YES;//改为计算黑块行数
                currentCount = 1;
            }
        }
    }
    //完成循环,写入最后一块数据
    blockArray[blockCount] = currentCount;
    blockCount ++;
    
    struct ImgArray imgArray;
    int imgCount = 0;
    
    int blockStart = 0;
    int blockHeight = 0;
    for (int i = 0; i < blockCount; i++) {
        if (i == 0 && !firstLineisBlack) {//blockHeight = 0
            blockStart += blockArray[i];
            continue;
        }
        if ((blockHeight + blockArray[i]) <= cutHeight) {
            blockHeight += blockArray[i];
        }else {
            if (blockHeight != 0) {
                struct Img img;
                img.width = width;
                img.height = blockHeight;
                int offset = blockStart*width;
                img.pixel = pixel + offset;
                imgArray.imageArray[imgCount] = img;
                imgCount ++;
            }
            
            int tmp = i % 2;
            if ((firstLineisBlack && tmp == 0) || (!firstLineisBlack && tmp != 0)) {
                blockStart += blockHeight;
                blockHeight = blockArray[i];
            }else {
                blockStart += (blockHeight + blockArray[i]);
                blockHeight = 0;
            }            
        }
    }
    
    if (blockHeight != 0) {
        struct Img img;
        img.width = width;
        img.height = blockHeight;
        int offset = blockStart*width;
        img.pixel = pixel + offset;
        imgArray.imageArray[imgCount] = img;
        imgCount ++;
    }
    
    imgArray.count = imgCount;

    return imgArray;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
