//
//  UIImage+CSImage.h
//  CSFoundationExample
//
//  Created by dianju on 2019/8/9.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CSImage)
//不是BitMap需要CPU对其解码专场转成Bitmap，GPU才能渲染
+ (UIImage *)decodeImage:(UIImage *)image toSize:(CGSize)size;
//按比例缩放绘制图片
+ (UIImage *)imageCompress:(UIImage *)sourceImage targetSize:(CGSize)size;
//缩放图片
+ (UIImage *) imageCompress:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
//取出gif图片的数组
+ (NSMutableArray *)praseGIFDataToImageArray:(NSData *)data;
//旋转图片
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
//裁剪图片
+ (UIImage *)cutImage:(UIImage*)sourceImage rect:(CGRect)rect;
//根据颜色创建图片
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color andFrame:(CGRect)rect andConnerRadius:(double)radius;
//获取图片宽高比相等对应的高
+ (CGFloat)heightForImage:(UIImage *)image fitWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
