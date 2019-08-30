//
//  CSCommonFunctions.h
//  CSFoundationExample
//
//  Created by dianju on 2019/6/11.
//  Copyright © 2019 Andersen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSCommonFunctions : NSObject
NSString* StringFromIndexPath(NSIndexPath* indexPath);
NSString* StringFromSize(CGSize size);
NSString* StringFromRect(CGRect rect);
CGSize SizeFromString(NSString *string);
CGRect RectFromString(NSString *string);
NSIndexPath* IndexPathFromString(NSString* string);
@end

NS_ASSUME_NONNULL_END
