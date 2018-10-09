//
//  SHPaymentKit.h
//  SHPaymentKit
//
//  Created by RobinShen on 15/8/14.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHUnionPay.h"
#import "SHAliPay.h"
#import "SHPayPalPay.h"

@interface SHPaymentKitManager : NSObject

@property (readonly, nonatomic) NSArray *sourceApplications;

+ (instancetype)sharedInstance;
+ (BOOL)canSupportApplePay;
+ (void)startUnionPayWithOrderTransactionNo:(NSString *)transactionNo paymentMode:(NSString *)paymentMode presentFromViewController:(UIViewController *)viewController completeBlock:(SHUnionPayDidCompleteBlock)completeBlock;
+ (void)startApplePayWithOrderTransactionNo:(NSString *)transactionNo paymentMode:(NSString *)paymentMode presentFromViewController:(UIViewController *)viewController merchantId:(NSString *)merchantId completeBlock:(SHApplePayDidCompleteBlock)completeBlock;
+ (void)startAlipayWithSignedOrderString:(NSString *)orderString successBlock:(SHAliPayResult)success failureBlock:(SHAliPayResult)failure;
+ (void)startAlipayWithUnSignedOrderString:(NSString *)orderString successBlock:(SHAliPayResult)success failureBlock:(SHAliPayResult)failure;
+ (void)generatePaypalNonceWithClientToken:(NSString *)clientToken amount:(NSString *)amount currencyCode:(NSString *)currencyCode presentFromViewController:(UIViewController *)viewController completion:(SHPayPalPayResult)completion;
+ (BOOL)handleOpenURL:(NSURL *)url withSourceApplication:(NSString *)sourceApplication;

@end
