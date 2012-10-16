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


typedef void (^IAPProductsBlock)(NSArray * products, NSError * error);
typedef void (^IAPBuySuccessBlock)(IAPProduct * product, NSData * purchasedReceipt);
typedef void (^IAPBuyFailBlock)(IAPProduct * product, BOOL canceled, NSError * error);

@interface IAPHelper : NSObject


@property (nonatomic, strong) NSMutableDictionary * products;

-(id)initWithProducts:(NSMutableDictionary *)products;

-(void)requestProductsWithCompletionBlock:(IAPProductsBlock)block;
-(void)buyProduct:(IAPProduct *)product succesBlock:(IAPBuySuccessBlock)sBlock failureBlock:(IAPBuyFailBlock)fBlock;
- (void)restoreCompletedTransactions;

@end
