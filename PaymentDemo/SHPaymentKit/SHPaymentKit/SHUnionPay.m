//
//  SHUnionPay.m
//  SHPaymentKit
//
//  Created by RobinShen on 15/8/14.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "SHUnionPay.h"
#import "UPAPayPlugin.h"
#import <PassKit/PassKit.h>

@interface SHUnionPay()

@property (strong, nonatomic) NSString *paymentMode;
@property (strong, nonatomic) NSString *fromScheme;
@property (strong, nonatomic) UIViewController *viewController;
@property (copy, readwrite, nonatomic) SHUnionPayDidCompleteBlock unionPayDidCompleteBlock;
@property (copy, nonatomic) SHApplePayDidCompleteBlock applePayDidCompleteBlock;

@end

@implementation SHUnionPay

#pragma mark - Public methods

- (void)payOrderWithTransactionNo:(NSString *)transactionNo presentFromViewController:(UIViewController *)viewController {
    [[UPPaymentControl defaultControl] startPay:transactionNo fromScheme:self.fromScheme mode:self.paymentMode viewController:viewController];
}

- (void)applePayOrderWithTransactionNo:(NSString *)transactionNo presentFromViewController:(UIViewController *)viewController  merchantId:(NSString *)merchantId {
    [UPAPayPlugin startPay:transactionNo mode:self.paymentMode viewController:viewController delegate:self andAPMechantID:merchantId];
}

#pragma mark - Accessors

- (void)setPaymentMode:(NSString *)paymentMode {
    _paymentMode = paymentMode;
}

- (void)setFromScheme:(NSString *)fromScheme {
    _fromScheme = fromScheme;
}

- (void)setUnionPayDidCompleteBlock:(SHUnionPayDidCompleteBlock)unionPayDidCompleteBlock {
    _unionPayDidCompleteBlock = unionPayDidCompleteBlock;
}

- (void)setApplePayDidCompleteBlock:(SHApplePayDidCompleteBlock)applePayDidCompleteBlock {
    _applePayDidCompleteBlock = applePayDidCompleteBlock;
}

+ (BOOL)canSupportApplePay {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.2) {
        if([PKPaymentAuthorizationViewController canMakePayments] && [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

#pragma mark - UPAPayPlugin delegate methods

- (void)UPAPayPluginResult:(UPPayResult *)result {
    if(self.applePayDidCompleteBlock) {
        self.applePayDidCompleteBlock(result);
    }
}

@end
