//
//  IAPHelper.h
//  Hangman
//
//  Created by Ernesto Carrion on 10/10/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "KGProduct.h"
#import "KGConfig.h"


typedef void (^IAPProductsBlock)(NSArray * products, NSError * error);
typedef void (^IAPBuySuccessBlock)(KGProduct * product, NSData * purchasedReceipt);
typedef void (^IAPBuyFailBlock)(KGProduct * product, BOOL canceled, NSError * error);

@protocol KGStoreProtocol <NSObject>

@optional
-(void)provideContentForUnfinishedTransactionsWithProduct:(KGProduct *)product;

@end

@interface KGStoreManager : NSObject <KGStoreProtocol>


@property (nonatomic, strong) NSMutableDictionary * products;

-(id)initWithProducts:(NSMutableDictionary *)products;

-(void)requestProductsWithCompletionBlock:(IAPProductsBlock)block;
-(void)buyProduct:(KGProduct *)product succesBlock:(IAPBuySuccessBlock)sBlock failureBlock:(IAPBuyFailBlock)fBlock;
-(void)restoreCompletedTransactionsWithSuccesBlock:(IAPBuySuccessBlock)sBlock failureBlock:(IAPBuyFailBlock)fBlock;

@end
