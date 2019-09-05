//
//  NSString+CSString.h
//  CSFoundationExample
//
//  Created by dianju on 2019/8/9.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//对字符串base64编码
#define STRING_TO_BASE64( text ) [ADSFunc stringToBase64String:text]
//base64字符串解码
#define BASE64_TO_TEXT( base64 ) [ADSFunc base64StringToString:base64]
//对Url特殊字符转码
#define ENCODE_URL( text ) [ADSFunc encodeWithUrl:text]
//对Url特殊字符解码
#define DECODE_URL( base64 ) [ADSFunc decodeFromPercentEscapeString:base64]
//GBK编码
#define GBKENCODE( data ) [ADSFunc encodeByGBKWithData:data]
//获取时间戳
#define GetTimesTemp [ADSFunc getTimeDate]

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CSString)
+ (NSString *)stringToBase64String:(NSString *)text;
+ (NSString *)base64StringToString:(NSString *)base64;

+ (NSString *)encodeWithUrl:(NSString *)url;
+ (NSString *)decodeFromPercentEscapeString: (NSString *) encodeStr;

//NSStringEncoding中没有的编码
+ (NSString *)encodeByGBKWithData:(NSData*)data;
//获得时间戳
+ (NSString *)getTimeDate;
//md5
+(NSString *) md5: (NSString *)str;
@end

NS_ASSUME_NONNULL_END
