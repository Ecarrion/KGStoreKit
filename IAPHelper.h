//
//  IAPHelper.h
//  Hangman
//
//  Created by Ernesto Carrion on 10/10/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "IAPProduct.h"
#import "IAPProduct.h"

typedef void (^IAPProductsBlock)(NSArray * products, NSError * error);

@interface IAPHelper : NSObject


@property (nonatomic, strong) NSMutableDictionary * products;

-(id)initWithProducts:(NSMutableDictionary *)products;

-(void)requestProductsWithCompletionBlock:(IAPProductsBlock)block;
-(void)buyProduct:(IAPProduct *)product;
- (void)restoreCompletedTransactions;

- (void)notifyStatusForProduct:(IAPProduct *)product string:(NSString *)string;
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier;

@end
