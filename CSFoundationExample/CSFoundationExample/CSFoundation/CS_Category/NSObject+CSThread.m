//
//  NSObject+CSThread.m
//  CSFoundationExample
//
//  Created by Andersen on 2019/9/5.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "NSObject+CSThread.h"

@implementation NSObject (CSThread)
+ (void)runMain:(void (^)(void))block
{
    if ([[NSThread currentThread] isMainThread]) {
        block();
    }else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

+ (void)runBackground:(void (^)(void))block
{
    if ([[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_global_queue(0, 0), block);
    }else {
        block();
    }
}

@end
