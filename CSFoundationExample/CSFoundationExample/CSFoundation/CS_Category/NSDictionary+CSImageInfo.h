//
//  NSDictionary+CSImageInfo.h
//  CSFoundationExample
//
//  Created by Andersen on 2019/9/5.
//  Copyright © 2019 Andersen. All rights reserved.
//  分类添加属性

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CSImageInfo)
@property (weak, readonly) NSString *title;
@property (weak, readonly) NSString *time;
@property (weak, readonly) NSString *src;
@property (weak, readonly) NSString *pic;
@property (weak, readonly) NSString *content;

@property (assign, nonatomic) float imageHeight;
@property (assign, nonatomic) float titleHeight;
@property (assign, nonatomic) float rowHeight;
@property (strong, nonatomic) UIImage *bitmapImage;
@end

NS_ASSUME_NONNULL_END
