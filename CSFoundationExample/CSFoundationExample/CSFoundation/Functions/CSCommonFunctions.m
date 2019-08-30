//
//  CSCommonFunctions.m
//  CSFoundationExample
//
//  Created by dianju on 2019/6/11.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "CSCommonFunctions.h"

@implementation CSCommonFunctions

#pragma String conversion Struct
NSString* StringFromRect(CGRect rect)
{
    return [NSString stringWithFormat:@"%f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height];
}

NSString* StringFromSize(CGSize size)
{
    return [NSString stringWithFormat:@"%f,%f",size.width,size.height];
}



NSString* StringFromIndexPath(NSIndexPath* indexPath)
{
    return [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];
}

#pragma Struct conversion String

CGSize SizeFromString(NSString* string){
    NSArray*array = [string componentsSeparatedByString:@","];
    return CGSizeMake(((NSString*)[array objectAtIndex:0]).floatValue, ((NSString*)[array objectAtIndex:1]).floatValue);
}

CGRect RectFromString(NSString*string)
{
    NSArray *array = [string componentsSeparatedByString:@","];
    return CGRectMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1]floatValue], [[array objectAtIndex:2]floatValue], [[array lastObject]floatValue]);
}

NSIndexPath* IndexPathFromString(NSString* string)
{
    NSArray* array = [string componentsSeparatedByString:@","];
    return [NSIndexPath indexPathForRow:((NSString*)[array objectAtIndex:1]).intValue inSection:((NSString*)[array objectAtIndex:0]).intValue];
}

@end
