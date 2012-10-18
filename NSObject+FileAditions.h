//
//  NSObject+UserDefaults.h
//  Jhonson
//
//  Created by Ernesto Carrión on 11/23/11.
//  Copyright (c) 2012 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FileAditions)

//User Defaults
-(void)saveToPrefsForKey:(id)key;
+(id)loadObjectFromPrefsForKey:(id)key;
+(void)deleteObjectForKeyFromPrefs:(id)key;

//Disk
-(BOOL)saveToDiskWithPath:(NSString *)path inDirectory:(NSSearchPathDirectory)directory;
+(id)loadFromDiskWithPath:(NSString *)path inDirectory:(NSSearchPathDirectory)directory;


//KeyChain
- (void)saveToKeyChainForService:(NSString *)service;
+ (id)loadFromKeyChainForService:(NSString *)service;
+ (void)deleteService:(NSString *)service;


@end
