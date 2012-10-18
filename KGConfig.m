//
//  KGConfig.m
//  Hangman
//
//  Created by Ernesto Carrion on 10/18/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "KGConfig.h"

@implementation KGConfig

+(NSDictionary *) preferences {
    
    return [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"KGConfig.plist"]];
}


+(BOOL)saveInKeychain {
    
    return [[[KGConfig preferences] objectForKey:@"SavePurchasesInKeychain"] boolValue];
}

+(BOOL)validateReceipts {
    
    return [[[KGConfig preferences] objectForKey:@"ValidateReceiptsLocally"] boolValue];
}

@end
