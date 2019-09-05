//
//  NSDictionary+CSImageInfo.m
//  CSFoundationExample
//
//  Created by Andersen on 2019/9/5.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "NSDictionary+CSImageInfo.h"
#import <objc/runtime.h>

@implementation NSDictionary (CSImageInfo)
- (NSString *)title
{
    return [self valueForKey:@"title"];
}
- (NSString *)time
{
    return [self valueForKey:@"time"];
}
- (NSString *)src
{
    return [self valueForKey:@"src"];
}
- (NSString *)pic
{
    return [self valueForKey:@"pic"];
}
- (NSString *)content
{
    return [self valueForKey:@"content"];
}
- (float)rowHeight
{
    NSNumber *height = objc_getAssociatedObject(self, @"rowHeight");
    if (!height) {
        height = @([self imageHeight] + [self titleHeight]+ 48);
        self.rowHeight = [height floatValue];
    }
    return [height floatValue];
}

- (void)setRowHeight:(float)rowHeight
{
    objc_setAssociatedObject(self, @"rowHeight", @(rowHeight), OBJC_ASSOCIATION_RETAIN);
}

- (float)imageHeight
{
    NSNumber *height = objc_getAssociatedObject(self, "imageHeight");
    if (!height) {
        return 120.0;
    }else {
        return height.floatValue;
    }
}

- (void)setImageHeight:(float)imageHeight
{
    objc_setAssociatedObject(self, "imageHeight", @(imageHeight), OBJC_ASSOCIATION_RETAIN);
}

- (float)titleHeight
{
    NSNumber *height = objc_getAssociatedObject(self, "titleHeight");
    if (!height) {
        return 0.0;
    }else {
        return height.floatValue;
    }
}

- (void)setTitleHeight:(float)titleHeight
{
    objc_setAssociatedObject(self, "titleHeight", @(titleHeight), OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)bitmapImage
{
    UIImage *image = objc_getAssociatedObject(self, "bitmapImage");
    return image;
}

- (void)setBitmapImage:(UIImage *)bitmapImage
{
    objc_setAssociatedObject(self, "bitmapImage", bitmapImage, OBJC_ASSOCIATION_RETAIN);
}

- (void)dealloc
{
    objc_removeAssociatedObjects(self);
}


@end
