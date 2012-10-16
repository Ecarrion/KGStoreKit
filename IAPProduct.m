//
//  IAPProduct.m
//  Hangman
//
//  Created by Ernesto Carrion on 10/10/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "IAPProduct.h"

@implementation IAPProduct


- (id)initWithProductIdentifier:(NSString *)productId {
    
    self = [super init];
    if (self) {
        
        self.availableForPurchase = NO;
        self.productIdentifier = productId;
        self.skProduct = nil;
    }
    
    return self;
}

- (BOOL)allowedToPurchase {
    
    if (!self.availableForPurchase)
        return NO;
    
    if (self.purchaseInProgress)
        return NO;
    
    if (self.purchased)
        return NO;
    
    return YES;
}

@end
