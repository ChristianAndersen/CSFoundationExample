//
//  CSKeyChain.m
//  CSFoundationExample
//
//  Created by dianju on 2019/8/9.
//  Copyright © 2019 Andersen. All rights reserved.
//

#import "CSKeyChain.h"
static NSString * const KEY_ALLINFO = @"www.CSKeychain.allinfo";

@implementation CSKeyChain
+ (NSString*)appName
{
    NSDictionary *info = [[NSBundle mainBundle]infoDictionary];
    return [info objectForKey:@"CFBundleDisplayName"];
}

+ (NSMutableDictionary*)getKeychainQuery:(NSString*)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,service, (__bridge_transfer id)kSecAttrService,service, (__bridge_transfer id)kSecAttrAccount,(__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible, nil];
}
+ (NSMutableDictionary*)getKeyDictionary:(NSString*)key
{
    id ret = nil;
    
    NSMutableDictionary *keychainQuery = [self getKeyDictionary:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
            
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", KEY_ALLINFO, e);
        } @finally {
            
        }
    }
    if ([ret isKindOfClass:[NSDictionary class]]) {
        return ret;
    }else{
        return [[NSMutableDictionary alloc]init];
    }
}
+ (void)saveMsg:(NSString*)msg withKey:(NSString*)key
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:KEY_ALLINFO];
    NSMutableDictionary *userPasswordKVPairs = [self getKeyDictionary:KEY_ALLINFO];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [userPasswordKVPairs setObject:msg forKey:key];
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:userPasswordKVPairs] forKey:(__bridge_transfer id)kSecValueData];
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

- (BOOL)addItemWithService:(NSString*)service account:(NSString*)account password:(NSString*)password
{
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    [queryDic setObject:service forKey:(__bridge id)kSecAttrService];                         //标签service
    [queryDic setObject:account forKey:(__bridge id)kSecAttrAccount];                         //标签account
    [queryDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];//表明存储的是一个密码
    
    OSStatus status = -1;
    CFTypeRef result = NULL;
    
    status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDic, &result);
    
    if (status == errSecItemNotFound) {
        NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
        [queryDic setObject:passwordData forKey:(__bridge id)kSecValueData];
        status = SecItemAdd((__bridge CFDictionaryRef)queryDic, NULL);
    }else if (status == errSecSuccess) {
        NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];    //把password 转换为 NSData
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:queryDic];
        [dict setObject:passwordData forKey:(__bridge id)kSecValueData];             //添加密码
        status = SecItemUpdate((__bridge CFDictionaryRef)queryDic, (__bridge CFDictionaryRef)dict);//!!!!关键的更新API
    }
    
    return (status == errSecSuccess);
}
+ (NSString*)objectForKey:(NSString*)key
{
    id ret = nil;
    NSMutableDictionary*keychainQuery = [self getKeychainQuery:KEY_ALLINFO];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", KEY_ALLINFO, e);
        } @finally {
            
        }
    }
    NSString *value;
    if ([ret isKindOfClass:[NSDictionary class]]) {
        NSDictionary *keyDic = (NSDictionary *)ret;
        value = [keyDic objectForKey:key];
    }
    return value;
}
+ (void)delete:(NSString*)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}
+ (NSString*)loadIdentifier
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:KEY_ALLINFO];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", KEY_ALLINFO, e);
        } @finally {
        }
    }
    NSString *identifier;
    if ([ret isKindOfClass:[NSDictionary class]])
    {
        
    }
}
@end
