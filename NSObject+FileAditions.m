//
//  NSObject+UserDefaults.m
//  Jhonson
//
//  Created by Ernesto Carrión on 11/23/11.
//  Copyright (c) 2012 All rights reserved.
//

#import "NSObject+FileAditions.h"

@interface NSObject(private)

+(NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+(BOOL)createDirectoryAtPath:(NSString *)path;

@end

@implementation NSObject (FileAditions)

-(void)saveToPrefsForKey:(id)key {
    
    if (!self)
        return;
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [prefs setObject:data forKey:key];
    [prefs synchronize];
}

+(id)loadObjectFromPrefsForKey:(id)key {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSData * data = [prefs  objectForKey:key];
    
    if (!data)
        return nil;
    
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return obj;
}

-(BOOL)saveToDiskWithPath:(NSString *)path inDirectory:(NSSearchPathDirectory)directory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:path];
    
	BOOL success = NO;
    
    success = [NSObject createDirectoryAtPath:[filePath stringByDeletingLastPathComponent]];
    
    if (!success) {
        
        return  NO;
    }
    
    NSData * dataToSave = [NSKeyedArchiver archivedDataWithRootObject:self];
    success = [dataToSave writeToFile:filePath atomically:YES];
    
    
    return success;
}

+(id)loadFromDiskWithPath:(NSString *)path inDirectory:(NSSearchPathDirectory)directory {
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:path];
    
    
    NSData * dataToLoad = [NSData dataWithContentsOfFile:filePath];
    
    id object = nil;
    if (dataToLoad)
        object = [NSKeyedUnarchiver unarchiveObjectWithData:dataToLoad];
    
    
    if (!object) {
        
        Class thisClass = [self class];
        
        if (thisClass == [NSDictionary class] || thisClass == [NSMutableDictionary class]) {
            
            object = [NSDictionary dictionaryWithContentsOfFile:filePath];
        }
        
        else if (thisClass == [NSArray class] || thisClass == [NSMutableArray class]) {
            
            object = [NSArray arrayWithContentsOfFile:filePath];
        }
        
        else if (thisClass == [NSData class]  || thisClass == [NSMutableData class]) {
            
            object = [NSData dataWithContentsOfFile:filePath];
        }
        
        else if (thisClass == [NSString class] || thisClass == [NSMutableString class]) {
            
            object = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        }
    }
    
    return object;
}


+(BOOL)createDirectoryAtPath:(NSString *)path {
        
    NSFileManager * filemgr = [NSFileManager defaultManager];
    BOOL result = [filemgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    return result;
}


+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock, (__bridge id)kSecAttrAccessible,
            nil];
}

- (void)saveToKeyChainForService:(NSString *)service{
    
    NSMutableDictionary *keychainQuery = [NSObject getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)loadFromKeyChainForService:(NSString *)service {
    
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        }
        @finally {}
        
    }
    
    if (keyData) 
        CFRelease(keyData);
    
    return ret;
}

+ (void)delete:(NSString *)service {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}



@end
