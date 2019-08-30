//
//  NSString+CSString.m
//  CSFoundationExample
//
//  Created by dianju on 2019/8/9.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "NSString+CSString.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (CSString)
+ (NSString *)stringToBase64String:(NSString *)text{
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedStr = [data base64EncodedStringWithOptions:0];
    return base64EncodedStr;
}

+ (NSString *)base64StringToString:(NSString *)base64{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:data encoding:NSUTF8StringEncoding];
    return base64Decoded;
}

//一些特殊字符串无法编码用以下方法
+ (NSString *)encodeWithUrl:(NSString *)url{
    NSString *encodeStr =
    (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,NULL,(CFStringRef)@"!*'();@+$,%#[]",kCFStringEncodingUTF8));
    //汉字转码
    //NSString* encodeStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodeStr;
}

//GBK编码
+ (NSString *)encodeByGBKWithData:(NSData*)data{
    NSStringEncoding GBKEncode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *encodeStr = [[NSString alloc] initWithData:data encoding:GBKEncode];
    return encodeStr;
}
//获取时间戳
+ (NSString *)getTimeDate{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}
+(NSString *) md5: (NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//图片圆角
+ (UIImage *)imageWithColor:(UIColor *)color andFrame:(CGRect)rect andConnerRadius:(double)radius
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:radius] addClip];
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
