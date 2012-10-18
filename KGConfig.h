//
//  KGConfig.h
//  Hangman
//
//  Created by Ernesto Carrion on 10/18/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGConfig : NSObject

+(BOOL)saveInKeychain;
+(BOOL)validateReceipts;

@end
