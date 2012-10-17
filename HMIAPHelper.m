//
//  HMIAPHelper.m
//  Hangman
//
//  Created by Ernesto Carrion on 10/10/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "HMIAPHelper.h"
#import "IAPProduct.h"
#import "HMContentController.h"
#import "JSNotifier.h"

@implementation HMIAPHelper

+(HMIAPHelper *)sharedInstance {
    
    static HMIAPHelper * sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    
    IAPProduct * tenHints = [[IAPProduct alloc] initWithProductIdentifier:@"com.kogi.hangman.tenhints"];
    IAPProduct * hundredHints = [[IAPProduct alloc] initWithProductIdentifier:@"com.kogi.hangman.hundredHints"];
    IAPProduct * hardWords = [[IAPProduct alloc] initWithProductIdentifier:@"com.kogi.hangman.hardwords"];
    IAPProduct * iosWords = [[IAPProduct alloc] initWithProductIdentifier:@"com.kogi.hangman.ioswords"];
    
    NSMutableDictionary * products = [@{tenHints.productIdentifier: tenHints, hundredHints.productIdentifier: hundredHints, hardWords.productIdentifier : hardWords, iosWords.productIdentifier : iosWords} mutableCopy];
    
    self = [super initWithProducts:products];
    if (self) {
    
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
-(void)provideContentForUnfinishedTransactionsWithProduct:(IAPProduct *)product {
    
    
}

/*
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    if ([productIdentifier isEqualToString:@"com.kogi.hangman.tenhints"]) {
        
        int curHints = [HMContentController sharedInstance].hints;
        [[HMContentController sharedInstance] setHints: curHints + 10];
        
    } else if ([productIdentifier isEqualToString:@"com.kogi.hangman.hundredHints"]) {
        
        int curHints = [HMContentController sharedInstance].hints;
        [[HMContentController sharedInstance] setHints: curHints + 100];
        
    } else if ([productIdentifier isEqualToString:@"com.kogi.hangman.hardwords"]) {
        
        [self unlockWordsForProductIdentifier: @"com.kogi.hangman.hardwords" directory:@"HardWords"];
        
    } else if ([productIdentifier isEqualToString:@"com.kogi.hangman.ioswords"]) {
        
        [self unlockWordsForProductIdentifier: @"com.kogi.hangman.ioswords" directory:@"iOSWords"];
    }
}


- (void)unlockWordsForProductIdentifier:(NSString *) productIdentifier directory:(NSString *)directory {
    
    IAPProduct * product = self.products[productIdentifier];
    product.purchased = YES;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSURL * resourceURL = [NSBundle mainBundle].resourceURL;
    [[HMContentController sharedInstance] unlockWordsWithDirURL:[resourceURL URLByAppendingPathComponent:directory]];
}
 */

@end
