//
//  NSObject+CSThread.h
//  CSFoundationExample
//
//  Created by Andersen on 2019/9/5.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CSThread)

+ (void)runMain:(void (^)(void))block;
+ (void)runBackground:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
