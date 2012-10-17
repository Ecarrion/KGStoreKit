//
//  IAPProduct.h
//  Hangman
//
//  Created by Ernesto Carrion on 10/10/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKProduct;

@interface KGProduct : NSObject

-(id) initWithProductIdentifier:(NSString *)productId;
-(BOOL) allowedToPurchase;

@property (nonatomic, strong) NSString * productIdentifier;
@property (nonatomic, strong) SKProduct * skProduct;

@property (nonatomic, assign) BOOL availableForPurchase;
@property (nonatomic, assign) BOOL purchased;
@property (nonatomic, assign) BOOL purchaseInProgress;


@end
