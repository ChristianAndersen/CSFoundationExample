//
//  CS_Timer.m
//  GCD定时器
//
//  Created by Andersen on 2019/6/11.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "CSTimer.h"

@implementation CSTimer
static NSMutableDictionary *timers;
dispatch_semaphore_t semaphore;
+ (void)initialize{
    static dispatch_once_t onceToken;
    semaphore = dispatch_semaphore_create(1);
    dispatch_once(&onceToken, ^{
        timers = [[NSMutableDictionary alloc]init];
    });
    
}

+ (NSString*)execTask:(void(^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async
{
    if (!task || (interval<0 && repeats)|| start<= 0) return nil;
    
    
    dispatch_queue_t queue = async?queue = dispatch_queue_create("asyncQueue", DISPATCH_QUEUE_SERIAL):dispatch_get_main_queue();
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start*NSEC_PER_SEC), interval*NSEC_PER_SEC, 0);//最后一个参数，允许的纳秒误差。
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSString *timerName = [NSString stringWithFormat:@"timerNo_%ld",timers.count];
    timers[timerName] = timer;
    dispatch_semaphore_signal(semaphore);
    
    dispatch_source_set_event_handler(timer, ^{
        task();
        if(!repeats)
          [self cancelTask:timerName];
    });
    
    dispatch_resume(timer);
    return timerName;
}

+ (NSString*)execTarget:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async
{
    if (!target || !selector) return nil;
    return [self execTask:^{
        if ([target respondsToSelector:selector]) {
//消除警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop

        }
    } start:start interval:interval repeats:repeats async:async];
}

+ (void)cancelTask:(NSString *)timerName{
    if (timerName.length == 0) return;
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    dispatch_source_t timer = timers[timerName];
    
    if (timer) {
        dispatch_source_cancel(timers[timerName]);
        [timers removeObjectForKey:timerName];
    }
    
    dispatch_semaphore_signal(semaphore);
}
@end
