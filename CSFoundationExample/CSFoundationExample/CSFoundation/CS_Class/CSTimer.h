//
//  CS_Timer.h
//  GCD定时器
//
//  Created by Andersen on 2019/6/11.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSTimer : NSObject
//start:多久后开始
//interval:多少时间重复一次
+ (NSString*)execTask:(void(^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async;

+ (NSString*)execTarget:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async;

+ (void)cancelTask:(NSString*)TimerName;
@end

NS_ASSUME_NONNULL_END
