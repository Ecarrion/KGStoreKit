//
//  IAPHelper.m
//  Hangman
//
//  Created by Ernesto Carrion on 10/10/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import "IAPHelper.h"

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    
    SKProductsRequest * _productsRequest;
}

@property (nonatomic, copy) IAPProductsBlock completionBlock;

@end

@implementation IAPHelper

- (id)initWithProducts:(NSMutableDictionary *)products {
    
    if ((self = [super init])) {
        
        _products = products;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}

#pragma mark - Actions

-(void)requestProductsWithCompletionBlock:(IAPProductsBlock)block {
    
    self.completionBlock = block;
    
    NSMutableSet * productIdentifiers = [NSMutableSet setWithCapacity:_products.count];
    [_products enumerateKeysAndObjectsUsingBlock:^(NSString * identifier, IAPProduct * product, BOOL *stop) {
       
        product.availableForPurchase = NO;
        [productIdentifiers addObject:product.productIdentifier];
    }];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

-(void)buyProduct:(IAPProduct *)product {
    
    NSAssert(product.allowedToPurchase, @"This product isn't allowed to be purchased!");
    
    NSLog(@"Buying %@...", product.productIdentifier);
    product.purchaseInProgress = YES;
    
    SKPayment * payment = [SKPayment paymentWithProduct:product.skProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
                                                        
}

-(void)restoreCompletedTransactions {
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - Private Methods

-(void)completeTransactiion:(SKPaymentTransaction *)transaction {
    
    NSLog(@"Complete transaction");
    [self provideContentForTransaction:transaction productIdentifier:transaction.payment.productIdentifier];
}

-(void)restoreTransactiion:(SKPaymentTransaction *)transaction {
    
    NSLog(@"Restore transaction");
    [self provideContentForTransaction:transaction productIdentifier:transaction.originalTransaction.payment.productIdentifier];
}

-(void)failedTransactiion:(SKPaymentTransaction *)transaction {
    
    NSLog(@"Failed Transaction");
    
    if (transaction.error.code != SKErrorPaymentCancelled)
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    
    IAPProduct * product = _products[transaction.payment.productIdentifier];
    
    [self notifyStatusForProductIdentifier:transaction.payment.productIdentifier string:@"Purchase failed."];
    product.purchaseInProgress = NO;
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForTransaction:(SKPaymentTransaction *)transaction productIdentifier:(NSString *)productIdentifier {
    
    IAPProduct * product = _products[productIdentifier];
    [self provideContentForProductIdentifier:productIdentifier];
    [self notifyStatusForProductIdentifier:productIdentifier string:@"Purchase complete!"];
    product.purchaseInProgress = NO;
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)notifyStatusForProductIdentifier:(NSString *)productIdentifier string:(NSString *)string {
    
    IAPProduct * product = _products[productIdentifier];
    [self notifyStatusForProduct:product string:string];
    
}

- (void)notifyStatusForProduct:(IAPProduct *)product string:(NSString *)string {
    
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
}

#pragma mark - Request product Delegate
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    [response.products enumerateObjectsUsingBlock:^(SKProduct * skProduct, NSUInteger idx, BOOL *stop) {
        
        IAPProduct * product = _products[skProduct.productIdentifier];
        product.skProduct = skProduct;
        product.availableForPurchase = YES;
    }];
    
    [response.invalidProductIdentifiers enumerateObjectsUsingBlock:^(NSString * invalidIdentifier, NSUInteger idx, BOOL *stop) {
        
        IAPProduct * product = _products[invalidIdentifier];
        product.availableForPurchase = NO;
    }];
    
    NSMutableArray * availableProducts = [NSMutableArray array];
    [_products enumerateKeysAndObjectsUsingBlock:^(NSString * identifier, IAPProduct * product, BOOL *stop) {
        
        if (product.availableForPurchase) {
            [availableProducts addObject:product];
        }
    }];
    
    
    if (_completionBlock)
        _completionBlock(availableProducts.copy, nil);
    _completionBlock = nil;
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    _completionBlock(nil, error);
    _completionBlock = nil;
}

-(void)requestDidFinish:(SKRequest *)request {
    
    NSLog(@"Finished");
}

#pragma mark - Buy Product Delegate
// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
 
    [transactions enumerateObjectsUsingBlock:^(SKPaymentTransaction * transaction, NSUInteger idx, BOOL *stop) {
       
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchased:
                [self completeTransactiion:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransactiion:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransactiion:transaction];
                break;
                
            default:
                break;
        }
    }];
    
}


/*
// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    
}

// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads {
    
}
*/
 
@end
