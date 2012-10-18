//
//  HMIAPHelper.m
//  Hangman
//
//  Created by Ernesto Carrion on 10/10/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "HMStoreManager.h"
#import "KGProduct.h"
#import "HMContentController.h"
#import "JSNotifier.h"
#import "NSObject+FileAditions.h"

@implementation HMStoreManager

+(HMStoreManager *)sharedInstance {
    
    static HMStoreManager * sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    
    KGProduct * tenHints = [[KGProduct alloc] initWithProductIdentifier:@"com.kogi.hangman.tenhints"];
    KGProduct * hundredHints = [[KGProduct alloc] initWithProductIdentifier:@"com.kogi.hangman.hundredHints"];
    KGProduct * hardWords = [[KGProduct alloc] initWithProductIdentifier:@"com.kogi.hangman.hardwords"];
    KGProduct * iosWords = [[KGProduct alloc] initWithProductIdentifier:@"com.kogi.hangman.ioswords"];
    
    iosWords.consumable = hardWords.consumable = YES;
    
    NSMutableDictionary * products = [@{tenHints.productIdentifier: tenHints, hundredHints.productIdentifier: hundredHints, hardWords.productIdentifier : hardWords, iosWords.productIdentifier : iosWords} mutableCopy];
    
    self = [super initWithProducts:products];
    if (self) {
    
        NSNumber * number = [NSNumber loadFromKeyChainForService:iosWords.productIdentifier];
        if ([number boolValue]) {
            
            puts("Unlock ios words");
        } else {
            
            puts("ios words not buyed");
        }
        
        /*
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.kogi.hangman.hardwords"]) {
            //[self unlockWordsForProductIdentifier: @"com.kogi.hangman.hardwords" directory:@"HardWords"];
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.kogi.hangman.ioswords"]) {
            //[self unlockWordsForProductIdentifier: @"com.kogi.hangman.ioswords" directory:@"iOSWords"];
        }
         */
        
    }
    return self;
}

//Implement this method to handle incomplete purchases
-(void)provideContentForUnfinishedTransactionsWithProduct:(KGProduct *)product {
    
}

@end
